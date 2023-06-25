class AppliesController < ApplicationController

  before_action :authenticate_headhunter!, except: [:index, :show, :destroy, :create]
  before_action :authenticate_user!, only: [:index]
  before_action :apply_find, only: [:find, :edit, :update, :destroy, :show]
  before_action :user_has_profile

  def index
    @applies = current_user.applies.page(params[:page])
  end

  def new
    @apply = Apply.new
  end

  def edit; end

  def update
    @apply.accepted_headhunter = false
    return redirect_to @apply if @apply.update(apply_params)
    render :edit
  end

  def create
    return redirect_to request.referrer if Apply.where(job_id: params[:job_id], user_id: params[:user_id]).exists?
    @apply = Apply.new(job_id: params[:job_id], user_id: params[:user_id])
    redirect_to @apply if @apply.save
  end

  def find
  end

  def destroy
    @apply.destroy
    redirect_to root_path
  end

  def show
    return redirect_to root_path if user_signed_in? && @apply.user != current_user
  end

  private
  def apply_params
    params.require(:apply).permit(:feedback_headhunter, :user_id, :job_id)
  end

  def apply_find
    @apply = Apply.find(params[:id])
  end
end
