class AppliesController < ApplicationController
  def index
    @applies = Apply.all
  end
 
  def new 
    @apply = Apply.new
  end

  def create 
    @apply = Apply.new(apply_params)
    if  @apply.save
      :new
      redirect_to @apply
    end
  end

  def edit
    @apply = Apply.find(params[:id])
  end

  def update
    @apply = Apply.find(params[:id])

    if  @apply.update(apply_params)
      redirect_to @apply
    else
      render :edit
    end
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
    params.require(:apply).permit(:application_user, :accepted_headhunter, :feedback_headhunter).permit(user_ids: [], job_ids: [])
  end

end
