class HtmlSchedulePrinter < Printer
  def initialize
    @name = 'Calendrier HTML'
    @slug = 'html_calendar'
  end

  def path(key)
    html_calendar_path(cle: key)
  end
end
