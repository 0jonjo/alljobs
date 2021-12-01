class ProfilesController < ApplicationController
  
 before_action :authenticate_user!, except: [:index]
  
  def new
    if current_user.profiles.empty?
      @profile = Profile.new
    else
      redirect_to edit_profile_path(current_user.id)
    end
  end

  def create
    @user = current_user
    @profile = @user.profiles.create(profile_params)
    if  @profile.save
      :new
      redirect_to @profile
    end
  end

  def edit
   @profile = current_user.profiles.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])

    if @profile.update(profile_params)
      redirect_to @profile
    else
      render :edit
    end
  end
 
  def show
    @profile = Profile.find(params[:id])
  end

  private
  def profile_params
    params.require(:profile).permit(:name, :social_name, :birthdate, :description, :educacional_background, :experience)
  end
end