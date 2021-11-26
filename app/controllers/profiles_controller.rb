class ProfilesController < ApplicationController
  
 before_action :authenticate_user!, except: [:index]
  
  def new 
    @profile = Profile.new
  end

  def create
    @user = User.find(params[:user_id])
    @profile = @user.profiles.create(profile_params)
    if  @profile.save
      :new
      redirect_to @profile
    end
  end

 # def edit
 #   @profile = Profile.find(params[:id])
 # end

 # def update
 #   @profile = Profile.find(params[:id])

 #   if  @profile.update(profile_params)
 #     redirect_to @profile
 #   else
 #     render :edit
 #   end
 # end
 #
 def show
    @profile = Profile.find(params[:id])
 end

  private
  def profile_params
    params.require(:profile).permit(:name, :social_name, :birthdate, :description, :educacional_background, :experience)
  end

end