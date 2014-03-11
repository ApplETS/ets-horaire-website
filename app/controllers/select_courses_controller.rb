# encoding: UTF-8

require 'digest/sha1'
require 'json'

class SelectCoursesController < ApplicationController
  HOURS_TO_EXPIRY = 24
  COURSES_RANGE = (1..5)

  before_filter :ensure_trimester_and_bachelor_present_and_valid, only: :index
  before_filter :find_bachelor, only: :compute
  before_filter :ensure_course_selected, only: :compute
  before_filter :ensure_nb_of_courses_within_limit, only: :compute

  def index
    render_new_form
  end

  def compute
    courses = @bachelor.courses.find_all { |course| @courses.include?(course.name) }

    @leaves = LeavesBuilder.build(params.try(:[], 'schedule').try(:[], 'filters').try(:[], 'leaves'))
    schedule_finder = ScheduleFinder.build do |c|
      c.additional_comparator do |groups_combinations, group|
        LeavesFilter.valid?(group, @leaves)
      end
    end
    schedules = schedule_finder.combinations_for(courses, @nb_of_courses)

    return render_no_results_found if schedules.empty?
    fulfill_output_flow(schedule_finder, schedules)
  end

  private

  def render_no_results_found
    flash[:notice] = 'Aucun résultat trouvé. Veuillez essayer une différente combinaison de cours ou restreindre vos critères.'
    render_populated_form
  end

  def fulfill_output_flow(schedule_finder, schedules)
    flash[:notice] = "Seulement les #{ScheduleFinder::RESULTS_LIMIT} premiers résultats sont affichés. Veuillez fournir plus de critères pour des résultats optimals." if schedule_finder.reached_limit?
    flash[:alert] = "Vos combinaisons vont être sauvegardés pour #{HOURS_TO_EXPIRY} heures."
    hash = store_results_of(schedules)
    redirect_to output_path(cle: hash)
  end

  def store_results_of(schedules)
    hash = SecureRandom.uuid
    Rails.cache.write hash, ResultsCache.new({
        trimester_year: @bachelor.trimester.year,
        trimester_term: @bachelor.trimester.term,
        trimester_is_for_new_students: @bachelor.trimester.for_new_students?,
        bachelor_name: @bachelor.name,
        selected_courses: @courses,
        nb_of_courses: @nb_of_courses,
        leaves: @leaves,
        schedules: schedules,
        trimester_slug: @bachelor.trimester.slug,
        bachelor_slug: @bachelor.slug
    }), expires_in: HOURS_TO_EXPIRY.hours
    hash
  end

  def ensure_trimester_and_bachelor_present_and_valid
    @bachelor = Bachelor.find_by_slug_and_trimester_slug(params[:baccalaureat], params[:trimestre])
    return redirect_back_to_selection if @bachelor.nil?
  end

  def find_bachelor
    @bachelor = Bachelor.find_by_slug_and_trimester_slug(params['schedule']['bachelor'], params['schedule']['trimester'])
  end

  def ensure_course_selected
    @courses = params['schedule']['courses'].try(:keys)
    return unless @courses.nil?

    flash[:notice] = 'Veuillez sélectionner au minimum un cours!'
    render_populated_form
  end

  def ensure_nb_of_courses_within_limit
    @nb_of_courses = (params['schedule']['number_of_courses'] || '').to_i
    return if nb_of_courses_within_limit?

    flash[:notice] = 'Veuillez spécifier un nombre de cours valide!'
    render_populated_form
  end

  def nb_of_courses_within_limit?
    @nb_of_courses.present? && @nb_of_courses <= @courses.size && COURSES_RANGE.include?(@nb_of_courses)
  end

  def redirect_back_to_selection
    flash[:notice] = 'Veuillez spécifier un baccalauréat valide!'
    redirect_to root_path
  end

  def render_new_form
    populate_form_with_parameters
    render 'index'
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
    @courses_range = COURSES_RANGE
    @leaves = []
  end

  def populate_form_with_data
    @leaves = LeavesBuilder.build(params['schedule'].try(:[], 'filters').try(:[], 'leaves'))
  end
end