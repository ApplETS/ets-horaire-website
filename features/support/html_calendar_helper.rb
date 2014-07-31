# encoding: utf-8

module HtmlCalendarHelper
  def build_period_hierarchy_with(periods)
    schedules = []
    periods.hashes.each do |period|
      schedule_index = period["Numéro d'horaire"].to_i - 1
      schedules[schedule_index] ||= []

      course_name = period['Cours']
      group_nb = period['Groupe'].to_i

      group_course = find_group_course(course_name, group_nb, schedules[schedule_index])
      if group_course.nil?
        group_course = GroupCourse.new(course_name, [], group_nb)
        schedules[schedule_index] << group_course
      end

      time_matches = /^(\d{2})h(\d{2}) - (\d{2})h(\d{2})$/.match(period['Période'])
      weekday = Weekday.fr(period['Jour'].downcase)
      start_time = WeekdayTime.new(time_matches[1].to_i, time_matches[2].to_i)
      end_time = WeekdayTime.new(time_matches[3].to_i, time_matches[4].to_i)
      period = Period.new(weekday, period['Type'], start_time, end_time)

      group_course.periods << period
    end
    schedules
  end

  def persist_to_app(key, schedules)
    Rails.cache.write key, ResultsCache.new(schedules: schedules)
  end

  def should_have_all_periods_of(results)
    results.hashes.each do |result|
      weekday = Weekday.fr(result["Jour"].downcase).en
      periods = page.all(".schedule-#{result["Numéro d'horaire"]} .schedule .weekday.#{weekday} .period")

      has_period = periods.any? do |period|
        begin
          period.find('.hour', text: result['Période'])
          period.find('.title .course', text: "#{result['Cours']}-#{result['Groupe']}")
          period.find('.title .type', text: result['Type'])

          true
        rescue Capybara::ElementNotFound
          false
        end
      end

      fail("Result: #{result} not found") unless has_period
    end
  end

  private

  def find_group_course(course_name, group_nb, group_courses)
    group_courses.find do |group_course|
      group_course.course_name == course_name && group_course.nb == group_nb
    end
  end
end

World(HtmlCalendarHelper)