# encoding: utf-8

Étantdonné /^je suis un étudiant en (.*), inscrit à la session d’(.*)$/ do |bachelor, session|
  visit path_to('the home page')
  click_link session
  slug = session.downcase.gsub('é', 'e').gsub(' ', '_')
  within "##{slug}-panel-collapse" do
    click_link bachelor
  end

  within '.bachelor-choice-resume' do
    expect(page).to have_selector("input[value='#{bachelor}']")
    expect(page).to have_selector("input[value='#{session}']")
    expect(page).to have_selector("input[value='Nouveaux Étudiants: Non']")
  end
end

Étantdonné(/^j'ai spécifié (.*) comme cours qui m'intéressent$/) do |string_of_courses|
  courses = string_of_courses.split(/\s*[, ]\s*|\s*et\s*/).reject(&:empty?)
  within '.courses_choice .courses-list' do
    courses.each do |course|
      find('label', text: course).click
    end
  end
end

Étantdonné(/^je spécifie comme contrainte les combinaisons de (\d+) cours seulement$/) do |nb_courses|
  within '.courses_choice .number-of-courses-selection' do
    find('label', text: nb_courses).click
  end
end

Lorsque(/^je soumets mon choix$/) do
  within '.courses_choice' do
    click_button 'Soumettre'
  end
end

Alors(/^il devrait n'y avoir que (\d+) résultats possibles$/) do |nb_results|
  within '#results' do
    expect(page).to have_selector('.result-caption', text: "Nombre de combinaisons: #{nb_results}")
  end
end

Alors(/^une mention de (.*) à la session d’(.*)$/) do |bachelor, session|
  within '.bachelor-choice-resume' do
    expect(page).to have_selector("input[value='#{bachelor}']")
    expect(page).to have_selector("input[value='#{session}']")
    expect(page).to have_selector("input[value='Nouveaux Étudiants: Non']")
  end
end

Alors(/^une mention des cours sélectionnés: (.*)$/) do |string_of_courses|
  courses = string_of_courses.split(/\s*[, ]\s*|\s*et\s*/).reject(&:empty?)
  within '.courses-list' do
    courses.each do |course|
      expect(page).to have_selector('label', text: course)
    end
  end
end

Alors(/^une mention de la contrainte de (\d+) cours, sans aucun congé$/) do |nb_courses|
  expect(page).to have_selector("input.number-of-courses[value='#{nb_courses}']")
  expect(page).to have_selector(".leaves input[value='Aucun']")
end

Lorsque(/^je sélectionne le (.*)$/) do |output_type|
  click_link output_type
end

Alors(/^je devrais voir apparaitre:$/) do |results|
  page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)

  weekdays = {
    'lundi' => 'monday',
    'mardi' => 'tuesday',
    'mercredi' => 'wednesday',
    'jeudi' => 'thursday',
    'vendredi' => 'friday'
  }

  results.hashes.each do |result|
    weekday = weekdays[result["Jour"].downcase]
    periods = page.all(".schedule-#{result["Numéro d'horaire"]} .schedule .weekday.#{weekday} .period" )

    periods.any? do |period|
      period.all('.hour', text: result['Période']).size == 1 &&
      period.all('.title .course', text: "#{result['Cours']}-#{result['Groupe']}").size == 1 &&
      period.all('.title .type', text: result['Type']).size == 1
    end
  end
end