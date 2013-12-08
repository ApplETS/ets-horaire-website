# encoding: UTF-8

class ScheduleController < ApplicationController
  def index
    return handle_missing_filename unless session.has_key?(:filename)

    @filename = session[:filename]
    @courses = %w(LOG121 MAT145 COM110)
    @days_off = []
    (params['day-off-weekday'] || []).size.times do |index|
      @days_off << OpenStruct.new(
        weekday_value: params['day-off-weekday'][index].to_i,
        from_time_value: params['day-off-from-time'][index].to_i,
        to_time_value: params['day-off-to-time'][index].to_i
      )
    end

    @simple_filters = [
      OpenStruct.new(name: "Nombre de cours minimum", slug: "minimum-number-of-courses"),
      OpenStruct.new(name: "Nombre de cours maximum", slug: "minimum-number-of-maximum")
    ]
    @output_types = [
      OpenStruct.new(source: "simple_list", name: "Liste simple", slug: "output-simple-list"),
      OpenStruct.new(source: "ascii_calendar", name: "Calendrier ASCII", slug: "output-ascii-calendar"),
      OpenStruct.new(source: "html_calendar", name: "Calendrier HTML", slug: "output-html-calendar")
    ]
  end

  private

  def handle_missing_filename
    flash[:notice] = 'Veuillez téléverser un fichier PDF.'
    redirect '/'
  end
end