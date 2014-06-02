# encoding: utf-8

Alors(/^je devrais avoir comme cours:$/) do |results|
  results_data = Rails.cache.read(output_key_of_current_url)
  should_have_all_periods_persisted(results, results_data.schedules)
end

When(/^il devrait y avoir des liens vers les sorties:$/) do |outputs|
  outputs.hashes.each do |output|
    output_name = output['Sortie']
    output_path = path_to("la page de #{output_name}") + "?cle=#{output_key_of_current_url}"

    expect(page).to have_link(output_name, output_path)
  end
end