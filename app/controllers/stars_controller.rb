# frozen_string_literal: true

class StarsController < ApplicationController
  before_action :authenticate_headhunter!
  before_action :already_star, only: [:create]

  def index
    @stars = Star.where(headhunter_id: current_headhunter.id).page(params[:page])
  end

  def find
    @star = Star.find(params[:id])
  end

  def destroy
    @star = Star.find(params[:id])
    @star.destroy
    flash[:alert] = 'You have removed the star from the apply'
    redirect_to stars_path
  end

  def show; end

  def create
    if (@star = Star.new(headhunter_id: params[:headhunter_id], apply_id: params[:apply_id]))
      if @star.save
        flash[:notice] = 'You successfully starred this apply.'
      else
        flash[:alert] = "You can't starred this apply."
      end
    end
    redirect_to request.referrer
  end

  private

  def star_params
    params.require(:star).permit(:headhunter_id, :apply_id)
  end

  def already_star
    return unless Star.where(headhunter_id: params[:headhunter_id], apply_id: params[:apply_id]).exists?

    flash[:alert] = "You're already starred this apply."
    redirect_to request.referrer
  end
end
