# -*- encoding : utf-8 -*-

class BachelorBuilder
  NAMES = {
    'hor_SEG' => 'Enseignements généraux',
    'hor_CTN' => 'Génie de la construction',
    'hor_ELE' => 'Génie électrique',
    'hor_LOG' => 'Génie logiciel',
    'hor_MEC' => 'Génie mécanique',
    'hor_GOL' => 'Génie des opérations et de la logistique',
    'hor_GPA' => 'Génie de la production automatisée',
    'hor_GTI' => "Génie des technologies de l'information"
  }

  class << self
    def build(bachelor_slug, courses_struct)
      courses = courses_struct.collect { |course_struct| CourseBuilder.build course_struct }
      CourseUtils.cleanup! courses

      Bachelor.new transform(bachelor_slug), bachelor_slug.downcase, courses
    end

    private

    def transform(bachelor_slug)
      raise "Missing bachelor slug '#{bachelor_slug}' in BachelorBuilder." unless NAMES.has_key?(bachelor_slug)
      NAMES[bachelor_slug]
    end
  end
end