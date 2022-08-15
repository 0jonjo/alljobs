class Api::V1::JobsController < ActionController::API
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
end