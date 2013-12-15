# encoding: UTF-8

require 'pp'

class ScheduleController < ApplicationController
  before_filter :ensure_trimester_and_bachelor_present_and_valid
  before_filter :ensure_course_selected, only: :compute
  before_filter :ensure_output_selected, only: :compute

  def index
    populate_form
  end

  def compute
    courses = @bachelor.courses.find_all { |course| params[:courses].keys.include?(course.name) }
    schedule_finder = ScheduleFinder.new(100)
    schedules = schedule_finder.combinations_for(courses, 3)
    flash[:notice] = 'BLA!' if schedule_finder.reached_limit?

    p '------------------------------' * 100
    render text: schedules.size
  end

  private

  def ensure_trimester_and_bachelor_present_and_valid
    redirect_back_to_selection unless params.has_key?(:trimester) || params.has_key?(:bachelor)
    @bachelor = Database.instance.find_bachelor_by_slug_and_trimester_slug(params[:bachelor], params[:trimester])
    return redirect_back_to_selection if @bachelor.nil?
  end

  def redirect_back_to_selection
    flash[:notice] = 'Veuillez spécifier un baccalauréat valide!'
    redirect_to root_path
  end

  def populate_form
    populate_form_with_parameters
    populate_form_with_data
  end

  def populate_form_with_parameters
    @trimester_slug = @bachelor.trimester.slug
    @bachelor_slug = @bachelor.slug
    @trimester_year = @bachelor.trimester.year
    @trimester_term = @bachelor.trimester.term
    @trimester_is_for_new_students = @bachelor.trimester.for_new_students?
    @bachelor_name = @bachelor.name
    @courses = @bachelor.courses
  end

  def populate_form_with_data
    populate_filters
    populate_outputs
  end

  def populate_filters
    @days_off = []
    (params.try(:[], 'filters').try(:[], 'day-off') || []).size.times do |index|
      @days_off << OpenStruct.new(
        weekday_value: params['filters']['day-off'][index]['weekday'].to_i,
        from_time_value: params['filters']['day-off'][index]['from-time'].to_i,
        to_time_value: params['filters']['day-off'][index]['to-time'].to_i
      )
    end

    @simple_filters = [
      OpenStruct.new(name: "Nombre de cours", slug: "number-of-courses")
    ]
  end

  def populate_outputs
    @output_types = [
      OpenStruct.new(source: "simple_list", name: "Liste simple", slug: "output-simple-list"),
      OpenStruct.new(source: "ascii_calendar", name: "Calendrier ASCII", slug: "output-ascii-calendar"),
      OpenStruct.new(source: "html_calendar", name: "Calendrier HTML", slug: "output-html-calendar")
    ]
  end

  def ensure_course_selected
    return if params.has_key?(:courses)

    flash[:notice] = 'Veuillez sélectionner au minimum un cours!'
    populate_form
    render 'index'
  end

  def ensure_output_selected
    return if params.has_key?(:output_types)

    flash[:notice] = 'Veuillez sélectionner au minimum un type de sortie!'
    populate_form
    render 'index'
  end
end