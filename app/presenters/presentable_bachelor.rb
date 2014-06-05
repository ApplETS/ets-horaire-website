require 'forwardable'

class PresentableBachelor
  extend Forwardable

  def_delegators :@bachelor, :slug, :name

  def initialize(bachelor)
    @bachelor = bachelor
  end

  def trimester_slug
    @bachelor.trimester.slug
  end

  def trimester_year
    @bachelor.trimester.year
  end

  def trimester_term
    @bachelor.trimester.term
  end

  def trimester_for_new_students?
    @bachelor.trimester.for_new_students?
  end

  def courses
    @bachelor.courses.map(&:name)
  end
end