class AppliesController < ApplicationController
  
  before_action :authenticate_headhunter!, except: [:index, :show, :destroy]
  
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
    @apply = Apply.new(apply_params)
    if @apply.save
      :new
      redirect_to @apply
      flash[:notice] = "You successfully applied to this job."
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


  def star_select
    headhunter = current_headhunter
    if Star.where(headhunter: headhunter, profile_id: params[:profile_id], apply_id: params[:apply_id]).exists?
      flash[:alert] = "You're already starred this apply."
    elsif
      @star = Star.new(headhunter: headhunter, profile_id: params[:profile_id], apply_id: params[:apply_id])
      @star.save
      flash[:notice] = "You successfully starred this apply."
    else  
      flash[:alert] = "You can't starred this apply."
    end
    redirect_to request.referrer
  end

  private
  def apply_params
    params.require(:apply).permit(:application_user, :accepted_headhunter, :feedback_headhunter, :user_id, :job_id)
  end
end
