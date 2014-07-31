class Bachelor
  include Serializable

  attr_reader :name, :slug, :courses
  attr_accessor :trimester

  def initialize(name, slug, courses)
    @name = name
    @slug = slug
    @courses = courses
  end

  def self.find_by_slug_and_trimester_slug(bachelor_slug, trimester_slug)
    trimester = TrimesterDatabase.instance.all.find { |trimester| trimester.slug == trimester_slug }
    return nil if trimester.nil?

    bachelor = trimester.bachelors.find { |bachelor| bachelor.slug == bachelor_slug }
    return nil if bachelor.nil?

    bachelor.trimester = trimester
    bachelor
  end
end