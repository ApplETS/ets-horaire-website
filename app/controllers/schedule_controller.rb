# encoding: UTF-8

class ScheduleController < ApplicationController
  before_filter :ensure_bachelor_exists, only: :index
  before_filter :populate_form, only: :index
  before_filter :ensure_course_selected, only: :compute
  before_filter :ensure_output_selected, only: :compute

  def index
    populate_form
  end

  def compute
  end

  private

  def ensure_bachelor_exists
    return redirect_back_to_selection unless params.has_key?(:trimester)
    @trimester_param = params[:trimester]

    trimester_slug, bachelor_slug = params[:trimester].split('-')
    return redirect_back_to_selection if trimester_slug.nil? || bachelor_slug.nil?

    @trimester = TrimesterDatabase.instance.find_by(trimester_slug)
    return redirect_back_to_selection if @trimester.nil?

    @bachelor = @trimester.bachelors.find { |bachelor| bachelor.slug == bachelor_slug }
    return redirect_back_to_selection if @bachelor.nil?
  end

  def redirect_back_to_selection
    flash[:notice] = 'Veuillez choisir un baccalauréat.'
    redirect_to root_path
  end

  def populate_form
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

  def ensure_course_selected
    unless params.has_key?(:courses)
      flash[:notice] = 'Veuillez sélectionner au minimum un cours!'
      ensure_bachelor_exists
      populate_form
      render 'index'
    end
  end

  def ensure_output_selected
    unless params.has_key?(:output_types)
      flash[:notice] = 'Veuillez sélectionner au minimum un type de sortie!'
      ensure_bachelor_exists
      populate_form
      render 'index'
    end
  end
end