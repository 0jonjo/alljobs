class Api::V1::JobsController < ActionController::API
  def show
    @job = Job.find(params[:id])
    render status: 200, json: @job  
  end 
end