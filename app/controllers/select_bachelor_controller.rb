# encoding: UTF-8

class SelectBachelorController < ApplicationController
  before_filter :ensure_year_period_selected, only: :choose

  def index
    render_trimesters
  end

  def choose
    trimester_slug, bachelor_slug = params[:year_period].split('-')
    redirect_to select_courses_path(trimestre: trimester_slug, baccalaureat: bachelor_slug)
  end

  private

  def ensure_year_period_selected
    return if params.has_key?(:year_period)

    flash[:notice] = 'Veuillez choisir un baccalauréat.'
    render_trimesters
  end

  def render_trimesters
    @trimesters = TrimesterDatabase.instance.sorted
    render 'index'
  end
end