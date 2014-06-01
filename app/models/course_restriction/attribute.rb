class CourseRestriction::Attribute
  attr_accessor :name, :slug

  def initialize(name, slug)
    @name = name
    @slug = slug
  end

  def ==(c)
    @slug == c.slug
  end
end