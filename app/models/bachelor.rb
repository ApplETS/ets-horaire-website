class Bachelor
  attr_reader :name, :slug, :courses
  attr_accessor :trimester

  def initialize(name, slug, courses)
    @name = name
    @slug = slug
    @courses = courses
  end
end