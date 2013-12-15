# encoding: UTF-8

class SelectFileController < ApplicationController
  before_filter :ensure_year_period_selected, only: :choose

  def index
    @trimesters = Database.instance.sorted
  end

  def choose
    trimester_slug, bachelor_slug = params[:year_period].split('-')
    redirect_to schedule_path(trimester: trimester_slug, bachelor: bachelor_slug)
  end

  private

  def ensure_year_period_selected
    return if params.has_key?(:year_period)
    flash[:notice] = 'Veuillez choisir un baccalauréat dans un trimester.'
    render 'index'
  end
end