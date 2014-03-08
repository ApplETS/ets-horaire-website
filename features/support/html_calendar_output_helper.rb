# encoding: utf-8

module HtmlCalendarOutputHelper
  WEEKDAYS = {
    'lundi' => 'monday',
    'mardi' => 'tuesday',
    'mercredi' => 'wednesday',
    'jeudi' => 'thursday',
    'vendredi' => 'friday'
  }

  def should_have_all_periods_of(results)
    results.hashes.each do |result|
      weekday = WEEKDAYS[result["Jour"].downcase]
      periods = page.all(".schedule-#{result["Numéro d'horaire"]} .schedule .weekday.#{weekday} .period")

      has_period = periods.any? do |period|
        begin
          period.find('.hour', text: result['Période'])
          period.find('.title .course', text: "#{result['Cours']}-#{result['Groupe']}")
          period.find('.title .type', text: result['Type'])

          true
        rescue Capybara::ElementNotFound
          false
        end
      end

      fail("Result: #{result} not found") unless has_period
    end
  end
end

World(HtmlCalendarOutputHelper)