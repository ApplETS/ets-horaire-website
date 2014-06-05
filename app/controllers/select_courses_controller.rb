# encoding: UTF-8

require 'digest/sha1'
require 'json'

class SelectCoursesController < ApplicationController
  HOURS_TO_EXPIRY = 24
  COURSES_RANGE = (1..5)

  before_filter :build_form_data

  def index
    bachelor = Bachelor.find_by_slug_and_trimester_slug(params['baccalaureat'], params['trimestre'])
    return redirect_back_to_selection if bachelor.nil?

    render_populated_form_with(bachelor)
  end

  def compute
    bachelor = Bachelor.find_by_slug_and_trimester_slug(schedule('bachelor'), schedule('trimester'))

    return render_minimum_course_selection_with(bachelor) if @selected_courses.nil?
    return render_valid_number_of_courses_with(bachelor) unless nb_of_courses_within_limit?

    courses = filter_courses(bachelor)
    schedule_finder = build_schedule_finder
    schedules = schedule_finder.combinations_for(courses, @nb_of_courses)

    return render_no_results_found_with(bachelor) if schedules.empty?
    fulfill_output_flow(schedules, bachelor, schedule_finder.reached_limit?)
  end

  private

  def build_form_data
    @nb_of_courses = (schedule('number_of_courses') || '').to_i
    @selected_courses = (schedule('courses').try(:keys) || [])
    @leaves = LeavesBuilder.build(schedule('filters.leaves'))
    @restrictions = CourseRestrictionBuilder.build(schedule('filters.restrictions'))
  end

  def schedule(param)
    keys = param.split('.')
    result = params['schedule']
    keys.each { |key| result = result.try(:[], key) }
    result
  end

  def filter_courses(bachelor)
    courses = bachelor.courses.find_all { |course| @selected_courses.include?(course.name) }
    courses = FlattenCourses.to_group_courses(courses)
    courses.keep_if { |group_course| LeavesFilter.keep?(group_course, @leaves) }
    courses
  end

  def build_schedule_finder
    schedule_finder = ScheduleFinder.new
    schedule_finder.shovel_filter = Proc.new do |courses|
      CourseRestrictionFilter.keep?(courses, @restrictions)
    end
    schedule_finder
  end

  def redirect_back_to_selection
    flash[:notice] = 'Veuillez spécifier un baccalauréat valide!'
    redirect_to root_path
  end

  def render_no_results_found_with(bachelor)
    flash[:notice] = 'Aucun résultat trouvé. Veuillez essayer une différente combinaison de cours ou restreindre vos critères.'
    render_populated_form_with(bachelor)
  end

  def render_minimum_course_selection_with(bachelor)
    flash[:notice] = 'Veuillez sélectionner au minimum un cours!'
    render_populated_form_with(bachelor)
  end

  def render_valid_number_of_courses_with(bachelor)
    flash[:notice] = 'Veuillez spécifier un nombre de cours valide!'
    render_populated_form_with(bachelor)
  end

  def fulfill_output_flow(schedules, bachelor, has_reached_limit)
    flash[:notice] = "Seulement les #{ScheduleFinder::RESULTS_LIMIT} premiers résultats sont affichés. Veuillez fournir plus de critères pour des résultats optimals." if has_reached_limit
    flash[:alert] = "Vos combinaisons vont être sauvegardés pour #{HOURS_TO_EXPIRY} heures."

    hash = store_results_of(schedules, bachelor)
    redirect_to results_path(cle: hash)
  end

  def store_results_of(schedules, bachelor)
    hash = SecureRandom.uuid
    Rails.cache.write hash, ResultsCache.new({
        bachelor: bachelor,
        schedules: schedules,
        selected_courses: @selected_courses,
        nb_of_courses: @nb_of_courses,
        leaves: @leaves,
        restrictions: @restrictions
    }), expires_in: HOURS_TO_EXPIRY.hours
    hash
  end

  def nb_of_courses_within_limit?
    @nb_of_courses.present? && @nb_of_courses <= @selected_courses.size && COURSES_RANGE.include?(@nb_of_courses)
  end

  def render_populated_form_with(bachelor)
    @bachelor = PresentableBachelor.new(bachelor)
    @courses_range = COURSES_RANGE

    render 'index'
  end
end