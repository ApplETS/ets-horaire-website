# -*- encoding : utf-8 -*-

class HtmlCalendarController < BaseOutputController
  layout 'html_calendar'

  HOURS = (8..23)
  WeekdayStruct = Struct.new(:name, :periods)
  PeriodStruct = Struct.new(:nb, :start_time, :end_time, :duration, :course, :type)

  def index
    transform_schedules
    @weekdays = weekdays
    @hours = HOURS
  end

  private

  def transform_schedules
    @weekdays_from_schedules = []
    html_schedules = []

    @schedules.each do |schedule|
      weekdays = []
      schedule.each_with_index do |course_group, index|
        course_group.periods.each do |period|
          if weekdays.none? { |weekday| weekday.name == period.weekday.en }
            periods = []
            @weekdays_from_schedules << period.weekday
            weekdays << WeekdayStruct.new(period.weekday.en, periods)
          else
            periods = (weekdays.find { |weekday| weekday.name == period.weekday.en }).periods
          end

          periods << PeriodStruct.new(index + 1, period.start_time, period.end_time, period.duration, "#{course_group.course_name}-#{course_group.nb}", period.type)
        end
      end
      html_schedules << weekdays
    end
    @schedules = html_schedules
  end

  def weekdays
    standard_weekdays + optional_weekdays
  end

  def standard_weekdays
    Week.workdays
  end

  def optional_weekdays
    Week.weekend.keep_if { |weekday| @weekdays_from_schedules.include?(weekday) }
  end
end