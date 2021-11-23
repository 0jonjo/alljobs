class JobsController < ApplicationController
  
before_action :authenticate_headhunter!, except: [:index]
  
  def index
    @jobs = Job.all
  end

  def new 
    @job = Job.new
  end

  def create 
    @job = Job.new(job_params)
    if  @job.save
      :new
      redirect_to @job
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])

    if  @job.update(job_params)
      redirect_to @job
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    redirect_to root_path
  end

  def show
    @job = Job.find(params[:id])
  end

  private
  def job_params
    params.require(:job).permit(:title, :description, :skills, :salary, :company, :level, :place, :date)
  end

end