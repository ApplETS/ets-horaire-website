# encoding: utf-8

Alors(/^je devrais avoir comme cours:$/) do |results|
  key = output_key_of(current_url)
  results_data = Rails.cache.read(key)
  should_have_all_periods_persisted(results, results_data.schedules)
end