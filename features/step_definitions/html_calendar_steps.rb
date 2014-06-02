# encoding: utf-8

When(/^un horaire avec la clé (.*) et composé des périodes:$/) do |key, periods|
  @periods = periods
  schedules = build_period_hierarchy_with(periods)
  persist_to_app(key, schedules)
end

When(/^j'accède au calendrier HTML avec la clé (.*)$/) do |key|
  visit path_to('la page de Calendrier HTML') + "?cle=#{key}"
end

When(/^je devrais voir les cours correspondant$/) do
  should_have_all_periods_of(@periods)
end