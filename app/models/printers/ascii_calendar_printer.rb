# -*- encoding : utf-8 -*-

class AsciiCalendarPrinter < Printer
  include WeekdayHelper

  COLUMN_WIDTH = 16
  NB_COLUMNS = 5
  FULL_COLUMN_SPACE = COLUMN_WIDTH.times.collect { " " }.join
  MINUTES_PER_HOUR = 60
  WEEKDAY_HOURS = (0..6).collect { |index| index * 24 * 60 }

  def initialize
    @name = 'Calendrier ASCII'
    @slug = 'ascii_calendar'
  end

  def output(schedules)
    @output = ''
    @weekdays = necessary_weekdays_of(schedules)
    @full_line_width = (@weekdays.size * (COLUMN_WIDTH + 1) + 6)
    schedules.each_with_index do |schedule, index|
      @output << "#{fill_heading(index + 1)}\r\n"
      @output << "#{line_fill}\r\n\r\n"
      print schedule
      @output << "\r\n"
    end
    @output
  end

  def path(key)
    ascii_calendar_path(format: :txt, cle: key)
  end

  private

  def fill_heading(text = '')
    text = text.to_s
    text << ' ' unless text.empty?
    "#{text}#{line_fill(text.size)}"
  end

  def line_fill(padding = 0, char = '*')
    (@full_line_width - padding).times.collect { char }.join
  end

  def print(schedule)
    week_line = @weekdays.collect { |weekday| align_left(weekday.fr.capitalize) }.join('|')

    @output << "     #{line_fill(5, '-')}\r\n"
    @output << "     |#{week_line}|\r\n"
    @output << "     #{line_fill(5, '-')}\r\n"
    (8..23).each do |hour|
      @output << print_line(hour, schedule)
    end
    @output << "     #{line_fill(5, '-')}\r\n"
  end

  def print_line(hour, schedule)
    hour_zerofilled = hour.to_s.rjust(2, "0")
    output = "#{hour_zerofilled}:00|"
    @weekdays.each do |weekday|
      output << "#{print_column(WEEKDAY_HOURS[weekday.index], hour, schedule)}|"
    end
    "#{output}\r\n"
  end

  def print_column(weekday, hour, schedule)
    column = FULL_COLUMN_SPACE
    start_line_period = nil
    description = nil
    end_line_period = nil

    schedule.each do |group|
      group.periods.each do |period|
        start_line_period = period if start_line?(weekday, hour, period)
        description = print_description_line(group, period) if description_line?(weekday, hour, period)
        end_line_period = period if end_line?(weekday, hour, period)
      end
    end

    if description.nil?
      column = print_start_line(start_line_period) unless start_line_period.nil?
      column = print_end_line(end_line_period) unless end_line_period.nil?
      column = print_full_line(start_line_period, end_line_period) unless start_line_period.nil? || end_line_period.nil?
    else
      column = description
    end

    column
  end

  def print_start_line(period)
    align_left zerofill_time(period.start_time_week_i), "-"
  end

  def start_line?(weekday, hour, period)
    schedule_start_time = period.start_time_week_i - weekday - hour * MINUTES_PER_HOUR
    schedule_start_time >= 0 && schedule_start_time < 60
  end

  def print_description_line(group, period)
    group_nb = group.nb.to_s.rjust(2, "0")
    full_course_denomination = "#{group.course_name}-#{group_nb}"
    short_course_type = shortify(period.type)
    justify full_course_denomination, short_course_type
  end

  def shortify(text)
    text.split(/([-\/ ])/).collect { |word| word[0].upcase }.join
  end

  def zerofill_time(time)
    minutes = time % MINUTES_PER_HOUR
    minutes.to_s.rjust(2, "0")
  end

  def description_line?(weekday, hour, period)
    schedule_start_time = period.start_time_week_i - weekday - hour * MINUTES_PER_HOUR
    schedule_start_time >= -60 && schedule_start_time < 0
  end

  def print_end_line(period)
    align_right zerofill_time(period.end_time_week_i), "-"
  end

  def end_line?(weekday, hour, period)
    schedule_end_time = period.end_time_week_i - weekday - hour * MINUTES_PER_HOUR
    schedule_end_time >= 0 && schedule_end_time < 60
  end

  def print_full_line(start_line_period, end_line_period)
    start_time = start_line_period.start_time_week_i % 60
    start_time_zerofilled = start_time.to_s.rjust(2, "0")
    end_time = end_line_period.end_time_week_i % 60
    end_time_zerofilled = end_time.to_s.rjust(2, "0")
    justify start_time_zerofilled, end_time_zerofilled, "-"
  end

  def print_filling_for(text, filler)
    (COLUMN_WIDTH - text.length).times.collect { filler }.join
  end

  def align_left(text, filler = " ")
    "#{text}#{print_filling_for text, filler}"
  end

  def align_right(text, filler = " ")
    "#{print_filling_for text, filler}#{text}"
  end

  def justify(left_text, right_text, filler = " ")
    spaces_nb = COLUMN_WIDTH - left_text.length - right_text.length
    spaces = spaces_nb.times.collect { filler }.join
    "#{left_text}#{spaces}#{right_text}"
  end
end
