class CourseRestriction
  VALUE_RANGE = (1..3)

  attr_accessor :time_span, :condition, :value

  def initialize(params)
    @time_span = CourseRestriction::TimeSpan.find_by_slug(params['time_span'])
    @condition = CourseRestriction::Condition.find_by_slug(params['condition'])
    @value = params['value'].to_i
  end

  def respected?(week)
    if all_days_restriction?
      all_days_respect_condition_of(week)
    else
      @condition.respected?(@value, week[weekday.index].size)
    end
  end

  private

  def all_days_restriction?
    @time_span.slug == CourseRestriction::TimeSpan::ALL_DAYS_SLUG
  end

  def all_days_respect_condition_of(week)
    week.all? do |courses|
      @condition.respected?(@value, courses.size)
    end
  end

  def weekday
    Weekday.fr(@time_span.slug)
  end
end