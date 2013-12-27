class Printer
  attr_reader :name, :slug, :content_type

  class << self
    def all
      @@printers ||= [HtmlSchedulePrinter.new, CalendarSchedulePrinter.new, ListSchedulePrinter.new]
    end

    def find_by_slug(value)
      all.find { |printer| printer.slug == value }
    end
  end
end