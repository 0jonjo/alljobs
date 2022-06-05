class CommentsController < ApplicationController
    
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @profile = Profile.find(params[:id])
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
    @headhunter = current_headhunter 
    @comment = Comment.new(comment_params)
    @comment.headhunter_id = @headhunter.id
    @comment.datetime = Time.now
    
    if @comment.save
      redirect_to request.referrer, notice: "Comment created."
    else
      render @profile
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    redirect_to request.referrer, notice: "Comment deleted."   
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end 

    def comment_params
      params.require(:comment).permit(:profile_id, :headhunter_id, :body, :datetime)
    end
end