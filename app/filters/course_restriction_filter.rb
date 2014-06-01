class CourseRestrictionFilter
  class << self
    def keep?(courses, restrictions)
      return true if restrictions.empty?

      week = regroup_periods_into_week_of(courses)
      restrictions.all? { |restriction| restriction.respected?(week) }
    end

    private

    def regroup_periods_into_week_of(courses)
      Weekday.all.collect do |weekday|
        collect_course_names_by(weekday, courses)
      end
    end

    def collect_course_names_by(weekday, courses)
      course_names = []
      courses.each do |course|
        course.periods.each do |period|
          course_names << course.course_name if period.weekday == weekday && !course_names.include?(course.course_name)
        end
      end
      course_names
    end
  end
end