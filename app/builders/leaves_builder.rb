class LeavesBuilder
  def self.build(leaves)
    return [] if leaves.nil?

    leaves.collect do |leave|
      weekday = Weekday.fr(leave['weekday'].downcase)
      start_time = WeekdayTime.new(weekday, leave['from-time'].to_i, 0)
      end_time = WeekdayTime.new(weekday, leave['to-time'].to_i, 0)
      Leave.new weekday, start_time, end_time
    end
  end
end