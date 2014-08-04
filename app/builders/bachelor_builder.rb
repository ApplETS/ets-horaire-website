# -*- encoding : utf-8 -*-

class BachelorBuilder
  class << self
    def build(file_struct, courses_struct)
      courses = courses_struct.collect { |course_struct| CourseBuilder.build course_struct }
      CourseUtils.cleanup! courses

      Bachelor.new bachelor_name_from(file_struct), file_struct.slug, courses
    end

    private

    def bachelor_name_from(file_struct)
      Bachelor::NAMES.fetch(file_struct.slug)
    rescue KeyError
      raise "Missing bachelor slug '#{file_struct.slug}' in BachelorBuilder."
    end
  end
end