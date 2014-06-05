# encoding: UTF-8

require 'json'

class ResultsController < ApplicationController
  before_filter :ensure_key_present

  def index
    @outputs = Printer.all
    @key = params[:cle]

    results_data = Rails.cache.read(params[:cle])
    return flash_invalid_key if results_data.nil?

    @bachelor = PresentableBachelor.new(results_data.bachelor)
    assign_view_variables_with(results_data)
  end

  private

  def ensure_key_present
    return if params.has_key?(:cle)
    redirect_to root_path
  end

  def flash_invalid_key
    flash[:notice] = "Votre clé n'est plus valide!"
    redirect_to root_path
  end

  def assign_view_variables_with(results_data)
    @schedules = results_data.schedules
    @nb_of_courses = results_data.nb_of_courses
    @selected_courses = results_data.selected_courses
    @leaves = results_data.leaves
    @restrictions = results_data.restrictions
    @results_limit = ScheduleFinder::RESULTS_LIMIT
  end
end