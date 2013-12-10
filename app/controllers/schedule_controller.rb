# encoding: UTF-8

class ScheduleController < ApplicationController
  before_filter :ensure_file_present, only: :index
  before_filter :ensure_course_selected, only: :compute

  def index
    @filename = session[:file][:original_filename]
    server_filename = session[:file][:server_filename]

    courses = build_courses_from("files/inputs/#{server_filename}")
    @courses = courses.collect { |course| course.name }

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
    @output_types = [
      OpenStruct.new(source: "simple_list", name: "Liste simple", slug: "output-simple-list"),
      OpenStruct.new(source: "ascii_calendar", name: "Calendrier ASCII", slug: "output-ascii-calendar"),
      OpenStruct.new(source: "html_calendar", name: "Calendrier HTML", slug: "output-html-calendar")
    ]
  end

  def compute
  end

  private

  def ensure_file_present
    unless session.has_key?(:file)
      flash[:notice] = 'Veuillez téléverser un fichier PDF.'
      redirect_to select_file_path
    end
  end

  def ensure_course_selected
    unless params.has_key?(:courses)
      flash[:notice] = 'Veuillez sélectionner au minimum un cours!'
      render 'index'
    end
  end

  def build_courses_from(filename)
    courses_stream = PdfStream.from_file(filename)
    courses_struct = StreamCourseBuilder.build_courses_from(courses_stream)
    courses = courses_struct.collect { |course_struct| CourseBuilder.build course_struct }
    CourseUtils.cleanup! courses
    courses
  end
end