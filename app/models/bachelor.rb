class Bachelor
  attr_reader :name, :slug, :courses

  def initialize(name, slug, courses)
    @name = name
    @slug = slug
    @courses = courses
  end
end