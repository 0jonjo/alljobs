# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :profile, only: %i[edit update destroy]

  def new
    @comment = Comment.new
  end

  def edit; end

  def create
    @comment = Comment.new(comment_params)
    @comment.headhunter_id = current_headhunter.id
    return redirect_to request.referer, notice: "Comment created." if @comment.save

    redirect_to request.referer, notice: "Comment can't be created."
  end

  def update
    if @comment.update(comment_params)
      redirect_to @profile, notice: "Comment updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to request.referer, notice: "Comment deleted."
  end

  private

  def profile
    @profile = Profile.find(params[:profile_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:profile_id, :headhunter_id, :body)
  end
end
