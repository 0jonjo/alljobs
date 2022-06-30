class ProfilesController < ApplicationController
  
 before_action :authenticate_user!, except: [:index, :show, :star_select]
 before_action :authenticate_headhunter!, only: [:star_select]
 before_action :set_profile, only: [:update]

  def index
    @profiles = Profile.page(params[:page])
  end
  
  def new
    if Profile.where(user_id: current_user.id).blank?
      @profile = Profile.new
    else
      redirect_to profile_path(current_user.id)
    end
  end

  def create
    @user = current_user
    @profile = @user.profiles.create(profile_params)
    if @profile.save
      flash[:notice] = "Profile registered."
      redirect_to @profile
    else
      flash.now[:alert] = "Profile doesn't registered." 
      render :new  
    end
  end

  def edit
    @profile = Profile.find_by(user_id: current_user.id)
    user_id = @profile.user_id
  end

  def update
    if @profile.update(profile_params)
      redirect_to @profile
    else
      flash.now[:alert] = "Profile doesn't edited."
      render :edit
    end
  end
 
  def show
    if user_signed_in? && Profile.where(user_id: current_user.id).blank?
      @profile = current_user.profiles.build
    end  
    @profile = Profile.find(params[:id]) 
    if user_signed_in? && @profile.user != current_user
      flash[:alert] = 'You do not have access to this profile.'
      redirect_to root_path
    end 
    if headhunter_signed_in?
      headhunter_id = current_headhunter.id
    end  
    @comments = @profile.comments.all
    @comment = @profile.comments.build 
  end

  private
  def set_profile
    @profile = Profile.find(params[:id])
  end  
  def profile_params
    params.require(:profile).permit(:name, :social_name, :birthdate, :description, :educacional_background, :experience, :user_id)
  end
end