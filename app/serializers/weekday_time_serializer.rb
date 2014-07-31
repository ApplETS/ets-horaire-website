class WeekdayTimeSerializer < Serializer
  attribute :hour
  attribute :minutes
  deserialization_order :hour, :minutes
end