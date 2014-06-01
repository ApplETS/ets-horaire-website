# encoding: UTF-8

require 'json'

class ResultsController < ApplicationController
  before_filter :ensure_key_present
  before_filter :ensure_key_valid
  before_filter :ensure_output_exists, only: :result

  def index
    @outputs = Printer.all
    @key = params[:cle]
    @trimester_year = @results_data.trimester_year
    @trimester_term = @results_data.trimester_term
    @trimester_is_for_new_students = @results_data.trimester_is_for_new_students
    @bachelor_name = @results_data.bachelor_name
    @selected_courses = @results_data.selected_courses
    @nb_of_courses = @results_data.nb_of_courses
    @leaves = @results_data.leaves
    @trimester_slug = @results_data.trimester_slug
    @bachelor_slug = @results_data.bachelor_slug
    @results_limit = ScheduleFinder::RESULTS_LIMIT
    @restrictions = @results_data.restrictions
  end

  private

  def ensure_key_present
    return if params.has_key?(:cle)
    redirect_to root_path
  end

  def ensure_key_valid
    @results_data = Rails.cache.read(params[:cle])
    return flash_invalid_key if @results_data.nil?

    @schedules = @results_data.schedules
  end

  def flash_invalid_key
    flash[:notice] = "Votre clé n'est plus valide!"
    redirect_to root_path
  end
end