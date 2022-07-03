class JobsController < ApplicationController
  
  before_action :authenticate_headhunter!, except: [:index, :show, :search]
  
  def index
    @jobs = Job.page(params[:page])
  end
 
  def new 
    @job = Job.new
  end

  def create 
    @job = Job.new(job_params)
    if @job.save
      flash[:notice] = "You successfully registered a Job Opening."
      redirect_to @job
    else
      flash.now[:alert] = "Job Opening was not registered."
      render :new  
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to @job
    else
      flash.now[:alert] = "Job Opening was not edited."
      render :edit
    end
  end
  
  def search
    @word = params['query']
    @jobs = Job.where("code LIKE :search OR title LIKE :search OR description LIKE :search", search: "%#{@word}%")
  end   

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    redirect_to root_path
  end

  def show
    @job = Job.find(params[:id])
  end

  def applies
    @job = Job.find(params[:id])
  end

  private
  def job_params
    params.require(:job).permit(:title, :code, :description, :skills, :salary, :company, :level, :place, :date, :job_status)
  end

end