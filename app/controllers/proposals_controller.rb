class ProposalsController < ApplicationController

  before_action :authenticate_headhunter!, except: [:show, :index]
  before_action :find_proposal, only: [:show, :edit, :update, :destroy]
  before_action :find_apply, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :already_proposal, only: [:new, :create]
  before_action :check_apply_rejected, only: [:create, :update]

  def index
    @proposals = Proposal.page(params[:page])
  end

  def new
    @proposal = Proposal.new
  end

  def edit
  end

  def update
    p @apply
    if @proposal.update(proposal_params)
      flash[:notice] = "You successfully edited this proposal."
      redirect_to @apply
    else
      flash[:alert] = "You do not edit this proposal."
      redirect_to edit_apply_proposal_path(@proposal)
    end
  end
  
  def destroy
    if @proposal.destroy
      flash[:alert] = 'You removed the proposal from the apply.'
      redirect_to @apply
    else
      flash[:alert] = 'You do not remove the proposal from the apply.'
    end      
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
      redirect_to new_apply_proposal_path(@apply.id)
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
  def check_apply_rejected
    if @apply.accepted_headhunter == false
      flash[:alert] = "You can't create a proposal to a rejected apply."
      return redirect_to new_apply_proposal_path(@apply.id)
    end
  end
end
