require 'json'

class Convert
  class << self
    def to_hash(courses)
      courses.collect { |course| serialize_course_from course }
    end

    def from_hash(courses)
      courses.collect { |course| deserialize_course_from course }
    end

    private

    def serialize_course_from(course)
      {
        name: course.name,
        groups: course.groups.collect { |group| serialize_group_from group }
      }
    end

    def serialize_group_from(group)
      {
        nb: group.nb,
        periods: group.periods.collect { |period| serialize_period_from period }
      }
    end

    def serialize_period_from(period)
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

    def deserialize_course_from(course)
      Course.new course['name'], course['groups'].collect { |group| deserialize_group_from group }
    end

    def deserialize_group_from(group)
      Group.new group['nb'], group['periods'].collect { |period| deserialize_period_from period }
    end

    def deserialize_period_from(period)
      weekday = Weekday.new(period['weekday']['index'])
      start_time = WeekdayTime.new(weekday, period['start_time']['hour'], period['start_time']['minutes'])
      end_time = WeekdayTime.new(weekday, period['end_time']['hour'], period['end_time']['minutes'])
      Period.new weekday, period['type'], start_time, end_time
    end
  end
end