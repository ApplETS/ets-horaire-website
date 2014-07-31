class BachelorSerializer < Serializer
  attribute :name
  attribute :slug
  attribute :courses, Course
end