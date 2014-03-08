class ResultsCache
  attr_accessor :trimester_year, :trimester_term, :trimester_is_for_new_students,
                :bachelor_name, :selected_courses, :nb_of_courses, :leaves,
                :schedules, :trimester_slug, :bachelor_slug

  def initialize(values = {})
    values.each_pair do |key, value|
      instance_variable_set :"@#{key}", value
    end
  end
end