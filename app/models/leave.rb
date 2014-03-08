class Leave < Period
  def initialize(weekday, start_time, end_time)
    super weekday, 'Leave', start_time, end_time
  end
end