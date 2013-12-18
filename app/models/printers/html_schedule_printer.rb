# -*- encoding : utf-8 -*-

require 'haml'

class HtmlSchedulePrinter< Printer

  def initialize
    @name = 'Calendrier HTML'
    @slug = 'calendrier_html'
    @content_type = 'text/html'
  end

  def output(schedules)
    html = nil
    css = WebpageBuilder.css
    html_schedules = WebpageBuilder.html(schedules)
    open_template do |haml|
      html = Haml::Engine.new(haml.read).render(Object.new, normalize_css: normalize_css, css: css, content: html_schedules)
    end
    html
  end

  private

  def open_template(&block)
    File.open(File.join(File.dirname(__FILE__), "./html/ressources/output_template.html.haml"), "r", &block)
  end

  def normalize_css
    File.open(File.join(File.dirname(__FILE__), "./html/ressources/normalize.css"), "r") { |f| f.read }
  end

end
