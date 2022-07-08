class AppliesController < ApplicationController
  
  before_action :authenticate_headhunter!, except: [:index, :show, :destroy, :create]
  before_action :apply_find, only: [:find, :edit, :update, :destroy, :show]

  def index
    if user_signed_in?
      @applies = current_user.applies.page(params[:page]) 
    else
      @applies = Apply.page(params[:page])
    end
  end

  def new 
    @apply = Apply.new
  end

  def edit
  end

  def update
    @apply.accepted_headhunter = false
    if @apply.update(apply_params)
      flash[:notice] = "You successfully rejected this apply."
      redirect_to @apply
    else
      flash.now[:alert] = "You can't reject this apply."
      render :edit
    end
  end

  def create
    if Apply.where(job_id: params[:job_id], user_id: params[:user_id]).exists?
      flash[:alert] = "You're already applied to this job opening."
      redirect_to request.referrer
    else
      @apply = Apply.new(job_id: params[:job_id], user_id: params[:user_id])
      if @apply.save
        redirect_to @apply
        flash[:notice] = "You successfully applied to this job."
      end
    end  
  end
 
  def find
  end
  
  def destroy
    @apply.destroy
    flash[:alert] = 'The application for this job has been removed.'
    redirect_to root_path
  end

  def show
    if user_signed_in? && @apply.user != current_user
      flash[:alert] = 'You do not have access to this apply.'
      redirect_to root_path
    end     
  end
  
  private
  def apply_params
    params.require(:apply).permit(:application_user, :accepted_headhunter, :feedback_headhunter, :user_id, :job_id)
  end

  def apply_find
    @apply = Apply.find(params[:id])
  end
end
