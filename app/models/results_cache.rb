class ResultsCache
  attr_reader :bachelor, :selected_courses, :nb_of_courses,
              :leaves, :schedules, :restrictions

  def initialize(values = {})
    values.each_pair do |key, value|
      instance_variable_set :"@#{key}", value
    end
  end
end