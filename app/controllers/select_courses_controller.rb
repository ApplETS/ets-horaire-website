# encoding: UTF-8

require 'digest/sha1'
require 'json'

class SelectCoursesController < ApplicationController
  RESULTS_LIMIT = 100

  before_filter :ensure_trimester_and_bachelor_present_and_valid
  before_filter :ensure_course_selected, only: :compute

  def index
    render_populated_form
  end

  def compute
    courses = @bachelor.courses.find_all { |course| params[:courses].keys.include?(course.name) }
    schedule_finder = ScheduleFinder.new(RESULTS_LIMIT)
    schedules = schedule_finder.combinations_for(courses, 2)

    return render_no_results_found if schedules.empty?
    fulfill_output_flow(schedule_finder, schedules)
  end

  private

  def render_no_results_found
    flash[:notice] = 'Aucun résultat trouvé. Veuillez essayer une différente combinaison de cours ou restreindres vos critères.'
    render_populated_form
  end

  def fulfill_output_flow(schedule_finder, schedules)
    flash[:notice] = "Seulement les #{RESULTS_LIMIT} premiers résultats sont affichés. Veuillez fournir plus de critères pour des résultats optimals." if schedule_finder.reached_limit?
    hash = store_results_of(schedules)
    redirect_to output_path(cle: hash)
  end

  def store_results_of(schedules)
    serialized_schedules = Serialize.schedules_from(schedules)
    hash = SecureRandom.uuid
    Rails.cache.write hash, {
        trimester_year: @bachelor.trimester.year,
        trimester_term: @bachelor.trimester.term,
        trimester_is_for_new_students: @bachelor.trimester.for_new_students?,
        bachelor_name: @bachelor.name,
        selected_courses: params[:courses].keys,
        serialized_schedules: serialized_schedules
    }.to_json
    hash
  end

  def ensure_trimester_and_bachelor_present_and_valid
    return redirect_back_to_selection unless params.has_key?(:trimestre) || params.has_key?(:baccalaureat)
    @bachelor = Bachelor.find_by_slug_and_trimester_slug(params[:baccalaureat], params[:trimestre])
    return redirect_back_to_selection if @bachelor.nil?
  end

  def ensure_course_selected
    return if params.has_key?(:courses)

    flash[:notice] = 'Veuillez sélectionner au minimum un cours!'
    render_populated_form
  end

  def redirect_back_to_selection
    flash[:notice] = 'Veuillez spécifier un baccalauréat valide!'
    redirect_to root_path
  end

  def render_populated_form
    populate_form_with_parameters
    populate_form_with_data
    render 'index'
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
end