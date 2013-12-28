# -*- encoding : utf-8 -*-

class HtmlCalendarController < BaseOutputController
  HOURS = (8..23)
  WeekdayStruct = Struct.new(:name, :periods)
  PeriodStruct = Struct.new(:css_class, :start_time, :end_time, :duration, :course, :type)

  layout 'html_calendar'

  def index
    convert_schedules
    @weekdays = weekdays
    @hours = HOURS
  end

  private

  def convert_schedules
    html_schedules = []
    @schedules.each do |schedule|
      weekdays = []
      schedule.each_with_index do |course_group, index|
        course_group.periods.each do |period|
          if weekdays.none? { |weekday| weekday.name == period.weekday.en }
            periods = []
            weekdays << WeekdayStruct.new(period.weekday.en, periods)
          else
            periods = (weekdays.find { |weekday| weekday.name == period.weekday.en }).periods
          end

          periods << PeriodStruct.new("period-#{index + 1}", period.start_time, period.end_time, period.duration, "#{course_group.course_name}-#{course_group.nb}", period.type)
        end
      end
      html_schedules << weekdays
    end
    @schedules = html_schedules
  end

  def weekdays
    Weekday::LANGUAGES[:FR].first(5).collect { |weekday| weekday.capitalize }
  end
end