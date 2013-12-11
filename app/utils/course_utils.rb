# -*- encoding : utf-8 -*-

class CourseUtils

  def self.cleanup!(courses)
    courses.uniq! { |course| course.name }
    courses.delete_if { |course| course.groups.empty? }
  end

end
