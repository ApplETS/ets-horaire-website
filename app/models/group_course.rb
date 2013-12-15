# -*- encoding : utf-8 -*-

class GroupCourse < Group

  attr_reader :course_name

  def initialize(course_name, periods, group_nb)
    super group_nb, periods
    @course_name = course_name
  end

  def conflicts?(group)
    same_course_name?(group) || super(group)
  end

  private

  def same_course_name?(group)
    @course_name == group.course_name
  end

end
