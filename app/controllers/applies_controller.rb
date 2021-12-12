class AppliesController < ApplicationController
  
  before_action :authenticate_headhunter!, except: [:show]
  
  def index
    @applies = Apply.page(params[:page])
  end
 
  def find
    @apply = Apply.find(params[:id])
  end
  
  def destroy
    @apply = Apply.find(params[:id])
    @apply.destroy

    redirect_to root_path
  end

  def show
    @apply = Apply.find(params[:id])
  end

  private
  def apply_params
    params.require(:apply).permit(:application_user, :accepted_headhunter, :feedback_headhunter, :user_id, :job_id)
  end

end
