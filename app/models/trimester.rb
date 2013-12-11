class Trimester
  attr_reader :year, :term, :bachelors

  def initialize(year, term, bachelors, is_for_new_students)
    @year = year
    @term = term
    @bachelors = bachelors
    @is_for_new_students = is_for_new_students
  end

  def for_new_students?
    @is_for_new_students
  end
end