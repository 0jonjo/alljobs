# frozen_string_literal: true

class ProposalsController < ApplicationController
  before_action :authenticate_headhunter!, except: %i[show index accept reject]
  before_action :find_proposal, only: %i[show edit update destroy accept reject]
  before_action :find_apply, only: %i[show new create edit update destroy accept reject]
  before_action :already_proposal, only: %i[new create]

  def index
    @proposals = Proposal.page(params[:page])
  end

  def new
    @proposal = Proposal.new
  end

  def edit; end

  def update
    if @proposal.update(proposal_params)
      flash[:notice] = 'You successfully edited this proposal.'
      redirect_to @apply
    else
      flash[:alert] = 'You do not edit this proposal.'
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
    return unless user_signed_in? && @proposal.apply.user != current_user

    flash[:alert] = 'You do not have access to this proposal.'
    redirect_to root_path
  end

  def create
    proposal = @apply.build_proposal(proposal_params)
    if proposal.save
      flash[:notice] = 'You successfully create a proposal for this apply.'
      redirect_to @apply
    else
      flash[:alert] = "You can't create a proposal for this apply."
      redirect_to new_apply_proposal_path(@apply.id)
    end
  end

  def accept
    @proposal.user_accepted = true
    if @proposal.save
      profile = Profile.where(user_id: @apply.user_id).first
      SendMailSuccessUserJob.perform_async(profile.id, 'accepted this proposal',
                                           apply_proposal_path(@apply.id, @proposal.id))
      flash[:notice] = 'You successfully accepted this proposal.'
    else
      flash[:alert] = "You can't accept to this proposal."
    end
    redirect_to apply_proposal_path(@apply, @proposal)
  end

  def reject
    @proposal.user_accepted = false
    if @proposal.save
      flash[:notice] = 'You successfully rejected this proposal.'
    else
      flash[:alert] = "You can't reject to this proposal."
    end
    redirect_to apply_proposal_path(@apply, @proposal)
  end

  private

  def proposal_params
    params.require(:proposal).permit(:apply_id, :salary, :benefits, :expectations, :expected_start, :user_accepted)
  end

  def find_proposal
    @proposal = Proposal.find(params[:id])
  end

  def find_apply
    return @apply = Apply.find_by(id: @proposal.apply_id) unless @proposal.nil?

    @apply = Apply.find(params[:apply_id])
  end

  def already_proposal
    return unless Proposal.where(apply_id: params[:apply_id]).exists?

    flash[:alert] = 'There is already a proposal for this apply.'
    redirect_to @apply
  end
end
