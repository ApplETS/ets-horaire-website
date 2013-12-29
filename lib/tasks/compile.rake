require_relative '../helpers/printing_helper'
require 'erb'
require 'compass'

include PrintingHelper
namespace :compile do
  desc 'Compile CSS of HTML Calendar for faster processing'
  task :html_calendar_css => :environment do
    print_title 'Compiling CSS of HTML Calendar'

    stylesheet_context = StylesheetContext.new
    css = open_css_template do |erb|
      puts '- Compiling template'
      ERB.new(erb.read).result(stylesheet_context.get_binding)
    end

    destination_css = Rails.root.join('app/assets/stylesheets/html_calendar/style.compiled.sass')
    puts "- Writing to #{destination_css}"
    File.open(destination_css, 'w') do |file|
      file.write css
    end
  end

  private

  def open_css_template(&block)
    File.open(Rails.root.join('app/models/printers/html/ressources/stylesheet.css.sass.erb'), 'r', &block)
  end

end