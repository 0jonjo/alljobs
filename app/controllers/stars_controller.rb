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
    flash[:alert] = 'You have removed the star from the apply'
    redirect_to stars_path
  end

  def show
    profile_id = @star.profile_id
    @profile = Profile.find(params[:profile_id])
    redirect_to @profile
  end

  def create
    if Star.where(headhunter_id: params[:headhunter_id], profile_id: params[:profile_id], apply_id: params[:apply_id]).exists?
      flash[:alert] = "You're already starred this apply."
    elsif
      @star = Star.new(headhunter_id: params[:headhunter_id], profile_id: params[:profile_id], apply_id: params[:apply_id])
      if @star.save
        flash[:notice] = "You successfully starred this apply."
      else  
        flash[:alert] = "You can't starred this apply."
      end
    end
    redirect_to request.referrer
  end

  private
  def star_params
    params.require(:star).permit(:profile_id, :headhunter_id, :apply_id)
  end
end
