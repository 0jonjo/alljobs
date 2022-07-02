class AppliesController < ApplicationController
  
  before_action :authenticate_headhunter!, except: [:index, :show, :destroy, :create]
  
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

  def create
    if Apply.where(job_id: params[:job_id], user_id: current_user.id)
      flash[:alert] = "You're already applied to this job opening."
      redirect_to request.referrer
    else
      @apply = Apply.new(apply_params)
      if @apply.save
        :new
        redirect_to @apply
        flash[:notice] = "You successfully applied to this job."
      end
    end  
  end
 
  def find
    @apply = Apply.find(params[:id])
  end
  
  def destroy
    @apply = Apply.find(params[:id])
    @apply.destroy
    flash[:alert] = 'The application for this job has been removed.'
    redirect_to root_path
  end

  def show
    @apply = Apply.find(params[:id])
    if user_signed_in? && @apply.user != current_user
      flash[:alert] = 'You do not have access to this apply.'
      redirect_to root_path
    end     
  end
  
  private
  def apply_params
    params.require(:apply).permit(:application_user, :accepted_headhunter, :feedback_headhunter, :user_id, :job_id)
  end
end
