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

      periods.any? do |period|
        period.all('.hour', text: result['Période']).size == 1 &&
        period.all('.title .course', text: "#{result['Cours']}-#{result['Groupe']}").size == 1 &&
        period.all('.title .type', text: result['Type']).size == 1
      end
    end
  end
end

World(HtmlCalendarOutputHelper)