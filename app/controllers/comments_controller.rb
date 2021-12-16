class CommentsController < ApplicationController
    before_action :authenticate_headhunter!

  def index
    @comments = Comment.page(params[:page])
  end
  
  def new
    @comment = Comment.new
  end

  def create
    @headhunter = current_headhunter
    @comment = @headhunter.comments.create(comment_params)
    if  @comment.save
      :new
      redirect_to @profile
    end
  end

  def edit
    @comment = current_headhunter.comments.find_by(headhunter_id: current_headhunter.id)
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      redirect_to @comment
    else
      render :edit
    end
  end
 
  def show
    @comment = Comment.find(params[:id])
  end

  private
  def comment_params
    params.require(:comment).permit(:datetime, :body, :profile_id, :headhunter_id)
  end
end
