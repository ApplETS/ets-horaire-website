# -*- encoding : utf-8 -*-

class ListSchedulePrinter < Printer

  def initialize
    @name = 'Liste simple'
    @slug = 'liste_simple'
    @content_type = 'text/plain'
  end

  def output(schedules)
    output = ''
    schedules.each do |groups|
      output << 58.times.collect { "*" }.join + "\r\n"
      output << 58.times.collect { "*" }.join + "\r\n"
      output << "\n"

      groups.each do |group|
        output << "#{group.course_name}\r\n"
        output << 58.times.collect { "-" }.join + "\r\n"
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
