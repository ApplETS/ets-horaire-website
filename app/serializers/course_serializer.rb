class CourseSerializer < Serializer
  attribute :name
  attribute :groups, Group
end