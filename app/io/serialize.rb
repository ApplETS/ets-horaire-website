class Serialize
  class << self
    def bachelor_from(bachelor)
      {
          name: bachelor.name,
          slug: bachelor.slug,
          courses: bachelor.courses.collect { |course| course_from course }
      }
    end

    def course_from(course)
      {
          name: course.name,
          groups: course.groups.collect { |group| group_from group }
      }
    end

    def schedules_from(schedules)
      schedules.collect do |schedule|
        schedule.collect do |group_course|
          group_course_from(group_course)
        end
      end
    end

    def group_course_from(group_course)
      {
          course_name: group_course.course_name,
          nb: group_course.nb,
          periods: group_course.periods.collect { |period| period_from period }
      }
    end

    def group_from(group)
      {
          nb: group.nb,
          periods: group.periods.collect { |period| period_from period }
      }
    end

    def period_from(period)
      {
          weekday: { index: period.weekday.index },
          type: period.type,
          start_time: {
              hour: period.start_time.hour,
              minutes: period.start_time.minutes
          },
          end_time: {
              hour: period.end_time.hour,
              minutes: period.end_time.minutes
          }
      }
    end
  end
end