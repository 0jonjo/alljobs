# frozen_string_literal: true

class AppliesController < ApplicationController
  before_action :authenticate_headhunter!, except: %i[index show destroy create]
  before_action :authenticate_user!, only: [:index]
  before_action :apply_find, only: %i[find edit update destroy show]
  before_action :user_has_profile

  def index
    @applies = current_user.applies.sorted_id.page(params[:page])
  end

  def new
    @apply = Apply.new
  end

  def edit; end

  def update
    return redirect_to @apply if @apply.update(apply_params)

    render :edit
  end

  def create
    return redirect_to request.referer if Apply.applied_by_user(params[:job_id], params[:user_id]).exists?

    @apply = Apply.new(job_id: params[:job_id], user_id: params[:user_id])
    redirect_to @apply if @apply.save
  end

  def find; end

  def destroy
    @apply.destroy
    redirect_to job_path(@apply.job_id)
  end

  def show
    redirect_to root_path if user_signed_in? && @apply.user != current_user
  end

  private

  def apply_params
    params.require(:apply).permit(:user_id, :job_id)
  end

  def apply_find
    @apply = Apply.find(params[:id])
  end
end
