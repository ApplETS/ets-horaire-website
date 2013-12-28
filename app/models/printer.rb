class Printer
  include Rails.application.routes.url_helpers

  attr_reader :name, :slug

  class << self
    def all
      @@printers ||= [HtmlSchedulePrinter.new, AsciiCalendarPrinter.new, SimpleListPrinter.new]
    end

    def find_by_slug(value)
      all.find { |printer| printer.slug == value }
    end
  end
end