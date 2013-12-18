# encoding: UTF-8

require 'json'

class OutputController < ApplicationController
  before_filter :ensure_key_present
  before_filter :ensure_key_valid
  before_filter :ensure_ouput_exists, only: :result

  def index
    @outputs = Printer.all
    @key = params[:cle]
    @trimester_year = @results_data['trimester_year']
    @trimester_term = @results_data['trimester_term']
    @trimester_is_for_new_students = @results_data['trimester_is_for_new_students']
    @bachelor_name = @results_data['bachelor_name']
    @selected_courses = @results_data['selected_courses']
    @nb_of_courses = @results_data['nb_of_courses']
    @days_off = @results_data['days_off']
    @trimester_slug = @results_data['trimester_slug']
    @bachelor_slug = @results_data['bachelor_slug']
  end

  def result
    output = @printer.output(@schedules)
    render text: output, content_type: @printer.content_type
  end

  private

  def ensure_key_present
    return if params.has_key?(:cle)
    redirect_to root_path
  end

  def ensure_key_valid
    data = Rails.cache.read(params[:cle])
    return flash_invalid_key if data.nil?

    @results_data = JSON.parse(data)
    @schedules = Deserialize.schedules_from(@results_data['serialized_schedules'])
  end

  def flash_invalid_key
    flash[:notice] = "Votre clé n'est plus valide!"
    redirect_to root_path
  end

  def ensure_ouput_exists
    @printer = Printer.find_by_slug(params[:output_type])
    return unless @printer.nil?

    redirect_to output_path(cle: params[:cle])
  end
end