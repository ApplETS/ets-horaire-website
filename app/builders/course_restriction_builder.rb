class CourseRestrictionBuilder
  def self.build(restrictions)
    return [] if restrictions.nil?

    restrictions.collect { |restriction| CourseRestriction.new(restriction) }
  end
end