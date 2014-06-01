class CourseRestriction::Condition < CourseRestriction::Attribute
  attr_reader :strategy

  def initialize(name, slug, strategy)
    super(name, slug)
    @strategy = strategy
  end

  def respected?(value, count)
    @strategy.call(value, count)
  end

  def marshal_dump
    [@name, @slug]
  end

  def marshal_load(array)
    @name, @slug = array
  end

  class << self
    def find_by_slug(slug)
      all.find { |condition| condition.slug == slug }
    end

    def all
      [ CourseRestriction::Condition.new('Un maximum de', 'maximum_of', Proc.new { |value, count| count <= value }),
        CourseRestriction::Condition.new('Exactement', 'exactly', Proc.new { |value, count| count == value }),
        CourseRestriction::Condition.new('Un minimum de', 'minimum_of', Proc.new { |value, count| count >= value }) ]
    end
  end
end