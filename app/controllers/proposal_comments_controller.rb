# frozen_string_literal: true

class ProposalCommentsController < ApplicationController
  before_action :proposal_comment, only: %i[show edit update destroy]
  before_action :apply, only: %i[show new create edit]
  before_action :proposal, only: %i[index show new create edit update destroy]

  def index
    @proposal_comments = ProposalComment.where(proposal_id: @proposal.id).page(params[:page])
  end

  def show; end

  def new
    @proposal_comment = ProposalComment.new
  end

  def edit; end

  def create
    @proposal_comment = ProposalComment.new(proposal_comment_params)
    @proposal_comment.proposal_id = @proposal.id
    author
    return redirect_to apply_proposal_proposal_comments_path, notice: 'Comment created.' if @proposal_comment.save

    redirect_to request.referrer, notice: "Comment can't be created."
  end

  def update
    if @proposal_comment.update(proposal_comment_params)
      redirect_to request.referrer, notice: 'Comment updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @proposal_comment.destroy
    redirect_to @proposal_comments, notice: 'Comment deleted.'
  end

  private

  def apply
    @apply = Apply.find(params[:apply_id])
  end

  def author
    if headhunter_signed_in?
      @proposal_comment.author_id = current_headhunter.id
      @proposal_comment.author_type = current_headhunter.class
    else
      @proposal_comment.author_id = current_user.id
      @proposal_comment.author_type = current_user.class
    end
  end

  def proposal
    @proposal = Proposal.find(params[:proposal_id])
  end

  def proposal_comment
    @proposal_comment = ProposalComment.find(params[:id])
  end

  def proposal_comment_params
    params.require(:proposal_comment).permit(:id, :proposal_id, :author_id, :author_type, :body)
  end
end
