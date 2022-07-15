class ProposalsController < ApplicationController

  before_action :authenticate_headhunter!, except: [:show, :index]
  before_action :find_proposal, only: [:show]
  before_action :find_apply, only: [:show, :new, :create]
  before_action :already_proposal, only: [:new, :create]

  def index
    @proposals = Proposal.page(params[:page])
  end

  def new
    @proposal = Proposal.new
  end
  
  def destroy
    @proposal.destroy
    flash[:alert] = 'You have removed the proposal from the apply.'
    redirect_to root_path
  end

  def show
    if user_signed_in? && @proposal.apply.user != current_user
      flash[:alert] = 'You do not have access to this proposal.'
      redirect_to root_path
    end
  end

  def create
    proposal = @apply.build_proposal(proposal_params)
    if proposal.save
      flash[:notice] = "You successfully create a proposal for this apply."
      redirect_to @apply
    else  
      flash[:alert] = "You can't create a proposal for this apply."
      redirect_to @apply
    end
  end

  private
  def proposal_params
    params.require(:proposal).permit(:apply_id, :salary, :benefits, :expectations, :expected_start)
  end
  def find_proposal
    @proposal = Proposal.find(params[:id])
  end 
  def find_apply
    @apply = Apply.find(params[:apply_id])
  end  
  def already_proposal
    if Proposal.where(apply_id: params[:apply_id]).exists?
      flash[:alert] = "There is already a proposal for this apply."
      redirect_to @apply
    end  
  end
end
