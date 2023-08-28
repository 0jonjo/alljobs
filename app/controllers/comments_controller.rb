class CommentsController < ApplicationController

  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :get_profile, only: [:show, :edit, :update, :destroy]


  def index
    @comments = @profile.comments.all
  end

  def show
    @comments = Comment.all
  end

  def new
    @comment = Comment.new
  end

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.headhunter_id = current_headhunter.id
    return redirect_to request.referrer, notice: "Comment created." if @comment.save
    redirect_to request.referrer, notice: "Comment can't be created."
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
    redirect_to request.referrer, notice: "Comment deleted."
  end

  private
    def get_profile
      @profile = Profile.find(params[:profile_id])
    end

    def set_comment
      return @comment = Comment.find_by(profile_id: @comment.profile_id, headhunter_id: current_headhunter.id) unless @comment.nil?
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:profile_id, :headhunter_id, :body)
    end
end