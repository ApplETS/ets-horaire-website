# -*- encoding : utf-8 -*-

class Bachelor
  include Serializable

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

  attr_reader :name, :slug, :courses
  attr_accessor :trimester

  def initialize(name, slug, courses)
    @name = name
    @slug = slug
    @courses = courses
  end

  def self.find_by_slug_and_trimester_slug(bachelor_slug, trimester_slug)
    trimester = TrimesterDatabase.instance.all.find { |trimester| trimester.slug == trimester_slug }
    return nil if trimester.nil?

    bachelor = trimester.bachelors.find { |bachelor| bachelor.slug == bachelor_slug }
    return nil if bachelor.nil?

    bachelor.trimester = trimester
    bachelor
  end
end