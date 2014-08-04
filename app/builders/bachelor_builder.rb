# -*- encoding : utf-8 -*-

class BachelorBuilder
  class << self
    def build(file_struct, courses_struct)
      courses = courses_struct.collect { |course_struct| build_course(course_struct) }
      CourseUtils.cleanup! courses

      Bachelor.new bachelor_name_from(file_struct), file_struct.slug, courses
    end

    private

    def bachelor_name_from(file_struct)
      Bachelor::NAMES.fetch(file_struct.slug)
    rescue KeyError
      raise "Missing bachelor slug '#{file_struct.slug}' in BachelorBuilder."
    end

    def build_course(course_struct)
      groups = course_struct.groups.collect { |gs| build_group(gs) }
      Course.new(course_struct.name, groups)
    end

    def build_group(group_struct)
      periods = group_struct.periods.collect { |ps| PeriodBuilder.build(ps) }
      Group.new(group_struct.nb, periods)
    end
  end
end