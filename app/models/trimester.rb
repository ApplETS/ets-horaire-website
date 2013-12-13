class Trimester
  attr_reader :year, :term, :slug, :bachelors

  def initialize(year, term, slug, bachelors, is_for_new_students)
    @year = year
    @term = term
    @slug = slug
    @bachelors = bachelors
    @is_for_new_students = is_for_new_students
  end

  def for_new_students?
    @is_for_new_students
  end
end