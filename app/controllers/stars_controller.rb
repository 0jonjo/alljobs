class StarsController < ApplicationController

  before_action :authenticate_headhunter!

  def index
    @stars = Star.page(params[:page])
  end
  
  def find
    @star = Star.find(params[:id])
  end
  
  def destroy
    @star = Star.find(params[:id])
    @star.destroy
    flash[:alert] = 'You have removed the star from a profile'
    redirect_to stars_path
  end

  def show
    profile_id = @star.profile_id
    @profile = Profile.find(params[:profile_id])
    redirect_to @profile
  end

  private
  def star_params
    params.require(:star).permit(:user_id, headhunter_id)
  end
end
