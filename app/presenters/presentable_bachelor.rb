require 'forwardable'

class PresentableBachelor
  extend Forwardable
  def_delegators :@bachelor, :trimester_slug, :trimester_year,
                             :trimester_term, :trimester_for_new_students,
                             :slug, :name

  def initialize(bachelor)
    @bachelor = bachelor
  end

  def courses
    @bachelor.courses.map(&:name)
  end
end