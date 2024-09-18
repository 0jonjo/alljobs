# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :authenticate_headhunter!, except: %i[index show search]
  before_action :find_job, only: %i[show edit update destroy applies drafted archived published]
  before_action :user_has_profile

  def index
    which_index(:published)
  end

  def index_draft
    which_index(:draft)
    render 'jobs/index'
  end

  def index_archived
    which_index(:archived)
    render 'jobs/index'
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    return redirect_to @job if @job.save

    render :new
  end

  def edit; end

  def update
    return redirect_to @job if @job.update(job_params)

    render :edit
  end

  def search
    @term = params['query']
    @jobs = Job.search_web(@term)
  end

  def destroy
    @job.destroy
    redirect_to root_path
  end

  def show
    @user_applied = Apply.applied_by_user(@job.id, current_user.id) if user_signed_in?
  end

  def drafted
    return redirect_to @job if @job.draft!

    render :new
  end

  def archived
    return redirect_to @job if @job.archived!

    render :new
  end

  def published
    if @job.published!
      # Adjust I18n text like this flash[:notice] = "You successfully published this job."
      return redirect_to @job
    end

    render :new
  end

  def applies; end

  private

  def find_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :code, :description, :skills, :salary, :company_id, :country_id, :city,
                                :level, :date, :job_status)
  end

  def which_index(status)
    @jobs = Job.indexed(status).page(params[:page])
  end
end
