# frozen_string_literal: true

module Api
  module V1
    class CommentsController < Api::V1::ApiController
      include Token
      before_action :authenticate_with_token, only: %i[index create destroy]
      before_action :requester, only: %i[create destroy]
      before_action :set_comment, only: %i[destroy]

      def index
        @comments = current_user_id ? Comment.by_apply(params[:apply_id]).open : Comment.by_apply(params[:apply_id]) + Comment.for_headhunter(current_headhunter_id)

        render status: :ok, json: @comments.as_json
      end

      def destroy
        return render_unauthorized unless requester_is_author?

        return render status: :precondition_failed, json: { errors: @comment.errors.full_messages } if @comment.errors.any?

        render status: :no_content, json: {} if @comment.destroy
      end

      def create
        return render_unauthorized if user_not_owner_apply?

        @comment = Comment.new(comment_params)

        author(@comment)

        return render status: :created, json: @comment if @comment.save

        render status: :precondition_failed, json: { errors: @comment.errors.full_messages }
      end

      private

      def comment_params
        params.require(:comment).permit(:title, :body).merge(apply_id: params[:apply_id])
      end

      def author(comment)
        comment.author_id = @requester_id
        comment.author_type = @requester_type
      end

      def requester_is_author?
        @comment.author_id == @requester_id && @comment.author_type == @requester_type
      end

      def user_not_owner_apply?
        @requester_type == 'User' ? Apply.find(params[:apply_id]).user_id != @requester_id : false
      end
    end
  end
end
