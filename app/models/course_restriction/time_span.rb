class CourseRestriction::TimeSpan < CourseRestriction::Attribute
  ALL_DAYS_SLUG = 'all_days'

  class << self
    def find_by_slug(slug)
      all.find { |timespan| timespan.slug == slug }
    end

    def all
      [CourseRestriction::TimeSpan.new('Tous les jours', ALL_DAYS_SLUG)] +
      Weekday.all.collect { |weekday| CourseRestriction::TimeSpan.new(weekday.fr.capitalize, weekday.fr) }
    end
  end
end