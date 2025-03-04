# frozen_string_literal: true

require 'rails_helper'

describe 'Comments API' do
  let(:apply) { create(:apply) }
  let(:another_user) { create(:user) }
  let(:headhunter) { create(:headhunter) }
  let(:comment) { create(:comment, author_id: headhunter.id, author_type: headhunter.class, apply_id: apply.id) }
  let(:comment_closed) { create(:comment, author_id: headhunter.id, author_type: headhunter.class, apply_id: apply.id, status: :closed) }
  let(:comment_closed_another_headhunter) { create(:comment, author_id: create(:headhunter).id, author_type: headhunter.class, apply_id: apply.id, status: :closed) }
  let(:comment_restricted) { create(:comment, author_id: headhunter.id, author_type: headhunter.class, apply_id: apply.id, status: :restrict) }

  context 'GET /api/v1/job/apply/comments' do
    context 'with success - headhunter' do
      before do
        comment
        comment_closed
        comment_closed_another_headhunter
        allow_any_instance_of(Api::V1::CommentsController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::CommentsController).to receive(:decode).and_return([{ 'requester_type' => 'Headhunter', 'requester_id' => headhunter.id }])
        allow_any_instance_of(Api::V1::CommentsController).to receive(:requester_exists?).and_return(true)
      end

      it 'and correct status' do
        get api_v1_job_apply_comments_path(apply.job_id, apply.id)

        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'and correct response' do
        get api_v1_job_apply_comments_path(apply.job_id, apply.id)

        expect(json_response.first['id']).to eq(comment.id)
        expect(json_response.first['apply_id']).to eq(apply.id)
        expect(json_response.count).to eq(2)
      end
    end

    context 'with success - user' do
      before do
        comment
        comment_closed
        allow_any_instance_of(Api::V1::CommentsController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::CommentsController).to receive(:decode).and_return([{ 'requester_type' => 'User', 'requester_id' => apply.user_id }])
        allow_any_instance_of(Api::V1::CommentsController).to receive(:requester_exists?).and_return(true)
      end

      it 'and correct status' do
        get api_v1_job_apply_comments_path(apply.job_id, apply.id)

        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'and correct response' do
        get api_v1_job_apply_comments_path(apply.job_id, apply.id)

        expect(json_response.first['id']).to eq(comment.id)
        expect(json_response.first['apply_id']).to eq(apply.id)
        expect(json_response.count).to eq(1)
      end
    end
  end

  context 'POST /api/v1/job/apply/comments' do
    context 'with success' do
      let(:params) { { comment: { body: comment.body } } }

      before do
        allow_any_instance_of(Api::V1::CommentsController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::CommentsController).to receive(:decode).and_return([{ 'requester_type' => 'Headhunter', 'requester_id' => headhunter.id }])
        allow_any_instance_of(Api::V1::CommentsController).to receive(:requester_exists?).and_return(true)
        post api_v1_job_apply_comments_path(apply.job_id, apply.id), params: params, as: :json
      end

      it 'and correct status' do
        expect(response.status).to eq 201
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'and correct response' do
        expect(json_response['author_id']).to eq(headhunter.id)
        expect(json_response['apply_id']).to eq(apply.id)
        expect(json_response['body']).to eq(comment.body)
      end
    end

    context 'with error' do
      context 'body is blank' do
        let(:params) { { comment: { body: '' } } }

        before do
          allow_any_instance_of(Api::V1::CommentsController).to receive(:valid_token?).and_return(true)
          allow_any_instance_of(Api::V1::CommentsController).to receive(:decode).and_return([{ 'requester_type' => 'Headhunter', 'requester_id' => headhunter.id }])
          allow_any_instance_of(Api::V1::CommentsController).to receive(:requester_exists?).and_return(true)
          post api_v1_job_apply_comments_path(apply.job_id, apply.id), params:, as: :json
        end

        it 'and correct status' do
          expect(response.status).to eq 412
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end

        it 'and correct response' do
          expect(json_response['errors'].first).to eq('Comentário não pode ficar em branco')
        end
      end

      context 'user tries to comment in another user apply' do
        let(:user) { create(:user) }
        let(:params) { { comment: { body: comment.body } } }

        before do
          allow_any_instance_of(Api::V1::CommentsController).to receive(:valid_token?).and_return(true)
          allow_any_instance_of(Api::V1::CommentsController).to receive(:decode).and_return([{ 'requester_type' => 'User', 'requester_id' => user.id + 99 }])
          allow_any_instance_of(Api::V1::CommentsController).to receive(:requester_exists?).and_return(true)
          post api_v1_job_apply_comments_path(apply.job_id, apply.id), params: params, as: :json
        end

        it 'and receive the correct status' do
          expect(response.status).to eq 401
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end

        it 'and receive the correct response' do
          expect(json_response['error']).to eq('Forneça um cabeçalho de Autorização válido.')
        end
      end
    end
  end

  context 'DELETE /api/v1/job/apply/comments/:id' do
    context 'with success' do
      before do
        comment
        allow_any_instance_of(Api::V1::CommentsController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::CommentsController).to receive(:decode).and_return([{ 'requester_type' => 'Headhunter', 'requester_id' => headhunter.id }])
        allow_any_instance_of(Api::V1::CommentsController).to receive(:requester_exists?).and_return(true)
        delete api_v1_job_apply_comment_path(apply.job_id, apply.id, comment.id)
      end

      it 'and correct status' do
        expect(response.status).to eq 204
      end

      it 'and remove the comment' do
        expect(Comment.all.count).to eq(0)
      end
    end

    context 'with error - is not the author' do
      before do
        comment
        allow_any_instance_of(Api::V1::CommentsController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::CommentsController).to receive(:decode).and_return([{ 'requester_type' => 'User', 'requester_id' => headhunter.id }])
        allow_any_instance_of(Api::V1::CommentsController).to receive(:requester_exists?).and_return(true)
        delete api_v1_job_apply_comment_path(apply.job_id, apply.id, comment.id)
      end

      it 'and receive the correct status' do
        expect(response.status).to eq 401
      end

      it 'and receive the correct response' do
        expect(json_response['error']).to eq('Forneça um cabeçalho de Autorização válido.')
      end
    end
  end
end
