# encoding: UTF-8

require 'digest/sha1'

class ScheduleController < ApplicationController
  RESULTS_LIMIT = 100
  OUTPUTS = {
    'simple-list' => ListSchedulePrinter,
    'ascii-calendar' => CalendarSchedulePrinter,
    'html-calendar' => HtmlSchedulePrinter
  }

  before_filter :ensure_trimester_and_bachelor_present_and_valid
  before_filter :ensure_course_selected, only: :compute
  before_filter :ensure_output_selected, only: :compute

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
    create_outputs_on_server_using(schedules)
    render text: schedules.size
  end

  def create_outputs_on_server_using(schedules)
    hash = SecureRandom.uuid
    output_directory = Rails.root.join("files/outputs/#{hash}")
    return hash if File.directory?(output_directory)

    Dir.mkdir(output_directory)
    params['output_types'].keys.each do |output_type|
      klass = OUTPUTS[output_type]
      destination = File.join(output_directory, output_type)
      klass.send(:output, schedules, destination)
    end
    return hash
  end

  def ensure_trimester_and_bachelor_present_and_valid
    redirect_back_to_selection unless params.has_key?(:trimester) || params.has_key?(:bachelor)
    @bachelor = Database.instance.find_bachelor_by_slug_and_trimester_slug(params[:bachelor], params[:trimester])
    return redirect_back_to_selection if @bachelor.nil?
  end

  def ensure_course_selected
    return if params.has_key?(:courses)

    flash[:notice] = 'Veuillez sélectionner au minimum un cours!'
    render_populated_form
  end

  def ensure_output_selected
    return if params.has_key?(:output_types)

    flash[:notice] = 'Veuillez sélectionner au minimum un type de sortie!'
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
      OpenStruct.new(source: "simple_list", name: "Liste simple", slug: "simple-list"),
      OpenStruct.new(source: "ascii_calendar", name: "Calendrier ASCII", slug: "ascii-calendar"),
      OpenStruct.new(source: "html_calendar", name: "Calendrier HTML", slug: "html-calendar")
    ]
  end
end