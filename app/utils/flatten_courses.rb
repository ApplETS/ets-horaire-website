class FlattenCourses
  def self.to_group_courses(courses)
    group_courses = courses.collect do |course|
      course.groups.collect do |group|
        GroupCourse.new(course.name, group.periods, group.nb)
      end
    end
    group_courses.flatten
  end
end