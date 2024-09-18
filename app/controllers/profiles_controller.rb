# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :authenticate_headhunter!, only: [:index]
  before_action :set_profile_check_user, only: %i[show update edit]

  def index
    @profiles = Profile.page(params[:page])
  end

  def new
    return @profile = Profile.new if current_user.profile.blank?

    @profile = Profile.find_by(user_id: current_user.id)
    redirect_to @profile
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
    if @profile.save
      @profile.send_mail_success('created', profile_path(@profile.id))
      redirect_to @profile
    else
      render :new
    end
  end

  def edit; end

  def update
    if @profile.update(profile_params)
      @profile.send_mail_success('updated', profile_path(@profile.id))
      redirect_to @profile
    else
      render :edit
    end
  end

  def show
    @comments = Comment.comments_by_headhunter(current_headhunter, @profile) if headhunter_signed_in?
    @comment = @profile.comments.build
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:name, :social_name, :birthdate, :description, :educacional_background,
                                    :experience, :city, :user_id, :country_id)
  end

  def set_profile_check_user
    @profile = Profile.find(params[:id])
    redirect_to root_path if user_signed_in? && @profile.user != current_user
  end
end
