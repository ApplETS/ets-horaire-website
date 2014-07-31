class PeriodSerializer < Serializer
  attribute :weekday, Weekday
  attribute :type
  attribute :start_time, WeekdayTime
  attribute :end_time, WeekdayTime
end