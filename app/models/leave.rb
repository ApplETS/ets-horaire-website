class Leave < Period
  FROM_TIME_RANGE = (8..23)
  TO_TIME_RANGE = (9..24)

  def initialize(weekday, start_time, end_time)
    super weekday, 'Leave', start_time, end_time
  end
end