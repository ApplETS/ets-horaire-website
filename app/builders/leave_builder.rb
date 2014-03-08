class LeaveBuilder
  def self.build(leave)
    weekday = Weekday.new(leave['weekday'].to_i)
    start_time = WeekdayTime.new(weekday, leave['from-time'].to_i, 0)
    end_time = WeekdayTime.new(weekday, leave['to-time'].to_i, 0)
    Leave.new weekday, 'Leave', start_time, end_time
  end
end