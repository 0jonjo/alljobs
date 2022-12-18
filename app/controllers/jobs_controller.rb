class JobsController < ApplicationController
  
  before_action :authenticate_headhunter!, except: [:index, :show, :search]
  before_action :find_id_job, only: [:edit, :update, :destroy, :show, :applies, :drafted, :archived, :published]
  before_action :user_has_profile

  def index
    @jobs = Job.where(job_status: :published).page(params[:page])
  end

  def index_draft
    @jobs = Job.where(job_status: :draft).page(params[:page])
  end

  def index_archived
    @jobs = Job.where(job_status: :archived).page(params[:page])
  end
 
  def new 
    @job = Job.new
  end

  def create 
    @job = Job.new(job_params)
    return redirect_to @job if @job.save
    render :new  
  end

  def edit
  end

  def update
    return redirect_to @job if @job.update(job_params)
    render :edit
  end
  
  def search
    @word = params['query']
    @jobs = Job.where("code LIKE :search OR title LIKE :search OR description LIKE :search", search: "%#{@word}%")
  end   

  def destroy
    @job.destroy
    redirect_to root_path
  end

  def show
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
    return redirect_to @job if @job.published!
    render :new  
  end

  def applies
  end

  private
  def job_params
    params.require(:job).permit(:title, :code, :description, :skills, :salary, :company, :level, :place, :date, :job_status)
  end
  def find_id_job
    @job = Job.find(params[:id])
  end
end