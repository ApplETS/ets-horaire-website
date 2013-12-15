# -*- encoding : utf-8 -*-

class BachelorBuilder
  NAMES = {
    'seg' => 'Enseignements généraux',
    'ctn' => 'Génie de la construction',
    'ele' => 'Génie électrique',
    'log' => 'Génie logiciel',
    'mec' => 'Génie mécanique',
    'gol' => 'Génie des opérations et de la logistique',
    'gpa' => 'Génie de la production automatisée',
    'gti' => "Génie des technologies de l'information"
  }

  class << self
    def build(file_struct, courses_struct)
      courses = courses_struct.collect { |course_struct| CourseBuilder.build course_struct }
      CourseUtils.cleanup! courses

      Bachelor.new bachelor_name_from(file_struct), file_struct.slug, courses
    end

    private

    def bachelor_name_from(file_struct)
      raise "Missing bachelor slug '#{file_struct.slug}' in BachelorBuilder." unless NAMES.has_key?(file_struct.slug)
      NAMES[file_struct.slug]
    end
  end
end