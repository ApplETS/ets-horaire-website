module WeekdayHelper
  def necessary_weekdays_of(schedules)
    standard_weekdays + optional_weekdays_in(schedules)
  end

  def standard_weekdays
    Week.workdays
  end

  def optional_weekdays_in(schedules)
    weekdays_in_schedule = collect_weekdays_of(schedules)
    Week.weekend.keep_if { |weekday| weekdays_in_schedule.include?(weekday) }
  end

  def collect_weekdays_of(schedules)
    weekdays_in_schedule = []
    schedules.each do |schedule|
      schedule.each do |course_group|
        course_group.periods.each { |period| weekdays_in_schedule << period.weekday }
      end
    end
    weekdays_in_schedule
  end
end