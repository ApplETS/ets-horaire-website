class GroupCourseSerializer < Serializer
  attribute :course_name
  attribute :nb
  attribute :periods, Period
end