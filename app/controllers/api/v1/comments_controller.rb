# frozen_string_literal: true

module Api
  module V1
    class CommentsController < Api::V1::ApiController
      before_action :set_comment, only: %i[destroy]

      def index
        @comments = if Current.user?
                      Comment.by_apply(params[:apply_id]).open
                    else
                      Comment.by_apply(params[:apply_id]) + Comment.for_headhunter(Current.requester_id)
                    end

        render status: :ok, json: @comments.as_json
      end

      def create
        return render_unauthorized if user_not_owner_apply?

        @comment = Comment.new(comment_params)
        @comment.author_id   = Current.requester_id
        @comment.author_type = Current.requester_type

        @comment.save!
        render status: :created, json: @comment
      end

      def destroy
        return render_unauthorized unless requester_is_author?

        @comment.destroy!
        head :no_content
      end

      private

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def comment_params
        params.expect(comment: %i[title body]).merge(apply_id: params[:apply_id])
      end

      def requester_is_author?
        @comment.author_id == Current.requester_id && @comment.author_type == Current.requester_type
      end

      def user_not_owner_apply?
        Current.user? && Apply.find(params[:apply_id]).user_id != Current.requester_id
      end
    end
  end
end
