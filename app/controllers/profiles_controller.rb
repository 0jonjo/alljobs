class ProfilesController < ApplicationController

 before_action :authenticate_user!, except: [:index, :show]
 before_action :authenticate_headhunter!, only: [:index]
 before_action :set_profile_check_user, only: [:show, :update, :edit]

  def index
    @profiles = Profile.page(params[:page])
  end

  def new
    return @profile = Profile.new if current_user.profile.blank?
    redirect_to profile_path(current_user.id)
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
    return redirect_to @profile if @profile.save
    render :new
  end

  def edit
  end

  def update
    return redirect_to @profile if @profile.update(profile_params)
    render :edit
  end

  def show
    headhunter_id = current_headhunter.id if headhunter_signed_in?
    @comments = @profile.comments.all
    @comment = @profile.comments.build
  end

  private
  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:name, :social_name, :birthdate, :description, :educacional_background, :experience, :city, :user_id, :country_id)
  end

  def set_profile_check_user
    @profile = Profile.find(params[:id])
    redirect_to root_path if user_signed_in? && @profile.user != current_user
  end
end