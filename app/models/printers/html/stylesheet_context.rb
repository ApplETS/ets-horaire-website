# -*- encoding : utf-8 -*-

class StylesheetContext
  PERIODS_COLORS = %w(
    rgb(90,167,157)
    rgb(49,90,119)
    rgb(43,58,101)
    rgb(210,73,82)
    rgb(151,190,126)
    rgb(231,223,154)
  )
  COLUMN_WIDTH = 150
  ROW_HEIGHT = 15
  PERIOD_PADDING = 5

  def initialize(weekdays, hours)
    @weekdays = weekdays
    @hours = hours
  end

  def get_binding
    binding
  end

  private

  def period_colors
    colors = PERIODS_COLORS.each_with_index.collect do |color, index|
      indent("&.period-#{index + 1}\n", 4.times) +
        indent("background-color: #{color}\n", 5.times) +
        indent("@if lightness(#{color}) > lightness(#aaaaaa)\n", 5.times) +
          indent("color: #4a4a4a\n", 6.times) +
        indent("@else\n", 5.times) +
          indent("color: #fafafa\n", 6.times) +
        indent("@include box-shadow(0 3px 0 darken(#{color}, 10%))\n", 5.times)
    end
    colors.flatten.join
  end

  def weekday_classes
    styles = @weekdays.each_with_index.collect do |weekday, index|
      indent("&.#{weekday}\n", 3.times) +
          indent("  left: #{COLUMN_WIDTH * index}px\n", 3.times)
    end
    styles.flatten.join
  end

  def period_classes
    from_classes + "\n" + duration_classes
  end

  def from_classes
    styles = @hours.each_with_index.collect do |hour, index|
      hour_zerofilled = zerofill(hour)
      foreach_quarter.collect do |nb|
        indent("&.from-#{hour_zerofilled}#{zerofill nb * 15}\n", 4.times) +
        indent("  top: #{index * ROW_HEIGHT * 2 + nb * ROW_HEIGHT / 2}px\n", 4.times)
      end
    end
    styles.flatten.join
  end

  def duration_classes
    styles = @hours.each_with_index.collect do |hour, index|
      hour_zerofilled = zerofill(index)
      foreach_quarter.collect do |nb|
        indent("&.duration-#{hour_zerofilled}#{zerofill nb * 15}\n", 4.times) +
            indent("  height: #{index * ROW_HEIGHT * 2 + nb * ROW_HEIGHT / 2 - PERIOD_PADDING * 2}px\n", 4.times)
      end
    end
    styles.flatten.join
  end

  def zerofill(hour)
    hour.to_s.rjust(2, "0")
  end

  def foreach_quarter
    4.times
  end

  def indent(content, times)
    indentation = times.collect { "  " }.join
    "#{indentation}#{content}"
  end
end
