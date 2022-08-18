class Api::V1::JobsController < Api::V1::ApiController

  def show
    begin
      @job = Job.find(params[:id])
      render status: 200, json: @job.as_json(except: [:created_at,:updated_at])
    rescue
      render status: 404, json: @job  
    end    
  end 

  def index
    @jobs = Job.all
    render status: 200, json: @jobs.as_json(except: [:created_at,:updated_at])
  end   

  def create
    @job = Job.new(job_params)
    if @job.save
      render status: 201, json: @job  
    else
      render status: 412, json: { errors: @job.errors.full_messages }
    end
  end

  private
  def job_params
    params.require(:job).permit(:title, :code, :description, :skills, :salary, :company, :level, :place, :date, :job_status)
  end
end