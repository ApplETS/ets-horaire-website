class Deserialize
  class << self
    def bachelor_from(bachelor)
      Bachelor.new bachelor['name'], bachelor['slug'], bachelor['courses'].collect { |course| course_from course }
    end

    def course_from(course)
      Course.new course['name'], course['groups'].collect { |group| group_from group }
    end

    def schedules_from(schedules)
      schedules.collect do |schedule|
        schedule.collect do |group_course|
          group_course_from(group_course)
        end
      end
    end

    def group_course_from(group_course)
      GroupCourse.new group_course['course_name'], group_course['periods'].collect { |period| period_from period }, group_course['nb']
    end

    def group_from(group)
      Group.new group['nb'], group['periods'].collect { |period| period_from period }
    end

    def period_from(period)
      weekday = Weekday.new(period['weekday']['index'])
      start_time = WeekdayTime.new(weekday, period['start_time']['hour'], period['start_time']['minutes'])
      end_time = WeekdayTime.new(weekday, period['end_time']['hour'], period['end_time']['minutes'])
      Period.new weekday, period['type'], start_time, end_time
    end
  end
end