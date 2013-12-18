class DaysOffFilter
  class << self
    def scan(schedules, restrictions)
      schedules.find_all do |schedule|
        schedule.all? do |group_course|
          group_course.periods.all? do |period|
            !conflicts?(restrictions, period)
          end
        end
      end
    end

    private

    def conflicts?(restrictions, period)
      restrictions.any? do |restriction|
        restriction_period = build_restriction_as_period(restriction)
        period.conflicts?(restriction_period)
      end
    end

    def build_restriction_as_period(restriction)
      weekday = Weekday.new(restriction['weekday'].to_i)
      start_time = WeekdayTime.new(weekday, restriction['from-time'].to_i, 0)
      end_time = WeekdayTime.new(weekday, restriction['to-time'].to_i, 0)
      Period.new(weekday, 'Restriction', start_time, end_time)
    end
  end
end