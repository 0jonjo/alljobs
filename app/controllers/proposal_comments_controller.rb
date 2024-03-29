# frozen_string_literal: true

class ProposalCommentsController < ApplicationController
  include Author
  before_action :proposal_comment, only: %i[show edit update destroy]
  before_action :apply, only: %i[show new create edit]
  before_action :proposal, only: %i[index show new create edit update destroy]
  before_action :author, only: %i[index new create]

  def index
    @proposal_comments = ProposalComment.by_proposal_id(@proposal.id).page(params[:page])
    @comments_from_author = @proposal_comments.by_author(@author_type, @author_id).ids
  end

  def show; end

  def new
    @proposal_comment = ProposalComment.new
  end

  def edit; end

  def create
    @proposal_comment = ProposalComment.new(proposal_comment_params)
    return redirect_to apply_proposal_proposal_comments_path, notice: 'Comment created.' if @proposal_comment.save

    redirect_to request.referer, notice: "Comment can't be created."
  end

  def update
    if @proposal_comment.update(proposal_comment_params)
      redirect_to apply_proposal_proposal_comments_path, notice: 'Comment updated.'
    else
      flash[:alert] = "Comment can't be edited."
      redirect_to edit_apply_proposal_proposal_comment_path(@proposal.apply_id, @proposal.id, @proposal_comment.id)
    end
  end

  def destroy
    @proposal_comment.destroy
    redirect_to apply_proposal_proposal_comments_path, notice: 'Comment deleted.'
  end

  private

  def apply
    @apply = Apply.find(params[:apply_id])
  end

  def proposal
    @proposal = Proposal.find(params[:proposal_id])
  end

  def proposal_comment
    @proposal_comment = ProposalComment.find(params[:id])
  end

  def proposal_comment_params
    params.require(:proposal_comment).permit(:proposal_id, :author_id, :author_type, :body)
  end
end
