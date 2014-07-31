# -*- encoding : utf-8 -*-

class WeekdayTime
  include Serializable

  MINUTES_PER_HOUR = 60
  MINUTES_PER_DAY = 24 * MINUTES_PER_HOUR

  attr_reader :hour, :minutes

  def initialize(hour, minutes)
    @hour = hour
    @minutes = minutes
    @weekday_time_int = hour * MINUTES_PER_HOUR + minutes
  end

  def to_i
    @weekday_time_int
  end

  def to_s
    "#{zerofill @hour}h#{zerofill @minutes}"
  end

  private

  def zerofill(time)
    time.to_s.rjust(2, "0")
  end

end
