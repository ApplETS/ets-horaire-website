# -*- encoding : utf-8 -*-

class ListSchedulePrinter < Printer
  HEADING_WIDTH = 58

  def initialize
    @name = 'Liste simple'
    @slug = 'liste_simple'
    @content_type = 'text/plain'
  end

  def output(schedules)
    output = ''
    schedules.each_with_index do |groups, index|
      output << "#{fill_heading(index + 1)}\r\n"
      output << "#{fill_heading}\r\n\r\n"

      groups.each do |group|
        output << "#{group.course_name}\r\n"
        output << HEADING_WIDTH.times.collect { "-" }.join + "\r\n"
        group_zerofilled = group.nb.to_s.rjust(2, "0")
        output << "#{spacify(group_zerofilled)}#{output_period(group.periods[0])}"
        group.periods[1..-1].each do |period|
          output << "#{spacify}#{output_period(period)}"
        end
        output << "\r\n"
      end
    end
    output
  end

  private

  def fill_heading(text = '')
    text = text.to_s
    text << ' ' unless text.empty?
    filling = (HEADING_WIDTH - text.length).times.collect { '*' }.join
    "#{text}#{filling}"
  end

  def output_period(period)
    "#{spacify(period.type)}#{spacify(weekday period)}#{period.start_time.to_s} - #{period.end_time.to_s}\r\n"
  end

  def spacify(text = "")
    spaces = (15 - text.length).times.collect { " " }.join
    "#{text}#{spaces}"
  end

  def weekday(period)
    period.weekday.fr.capitalize
  end

end
