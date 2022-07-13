class ProposalsController < ApplicationController

  #before_action :authenticate_headhunter!, only: [:show]
  #before_action :authenticate_user!, only: [:show]

  def index
    @proposals = Proposal.page(params[:page])
  end
  
  def find
    @proposal = Proposal.find(params[:id])
  end
  
  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy
    flash[:alert] = 'You have removed the proposal from the apply'
    redirect_to root_path
  end

  def show
    @proposal = Proposal.find(params[:id])
  end

  def create
    if Proposal.where(headhunter_id: params[:headhunter_id], profile_id: params[:profile_id], apply_id: params[:apply_id]).exists?
      flash[:alert] = "You're already starred this apply."
    elsif
      @star = Star.new(headhunter_id: params[:headhunter_id], profile_id: params[:profile_id], apply_id: params[:apply_id])
      if @star.save
        flash[:notice] = "You successfully starred this apply."
      else  
        flash[:alert] = "You can't starred this apply."
      end
    end
    redirect_to request.referrer
  end

  private
  def proposal_params
    params.require(:proposal).permit(:apply_id, :salary, :benefits, :expectations, :expected_start)
  end
end
