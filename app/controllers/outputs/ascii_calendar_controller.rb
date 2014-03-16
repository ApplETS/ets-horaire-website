class AsciiCalendarController < BaseOutputController
  def index
    respond_to do |format|
      format.text { render text: @printer.output(@schedules) }
    end
  end
end