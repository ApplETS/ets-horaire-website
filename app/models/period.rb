# -*- encoding : utf-8 -*-

class Period
  include Serializable

  MINUTES_PER_DAY = 24 * 60

  attr_reader :weekday, :type, :start_time, :end_time

  def initialize(weekday, type, start_time, end_time)
    @weekday = weekday
    @type = type
    @start_time = start_time
    @end_time = end_time
  end

  def duration
    @end_time.to_i - @start_time.to_i
  end

  def conflicts?(period)
    !(before?(period) || after?(period))
  end

  def start_time_week_i
    @weekday.index * MINUTES_PER_DAY + @start_time.to_i
  end

  def end_time_week_i
    @weekday.index * MINUTES_PER_DAY + @end_time.to_i
  end

  private

  def before?(period)
    period.start_time_week_i < start_time_week_i &&
    period.end_time_week_i < start_time_week_i
  end

  def after?(period)
    period.start_time_week_i > end_time_week_i &&
    period.end_time_week_i > end_time_week_i
  end

end
