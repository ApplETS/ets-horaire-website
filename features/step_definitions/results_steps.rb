# encoding: utf-8

Alors(/^il devrait n'y avoir que (\d+) résultats possibles$/) do |nb_results|
  within '#results' do
    expect(page).to have_selector('.result-caption', text: "Nombre de combinaisons: #{nb_results}")
  end
end

Alors(/^une mention de (.*) à la session d’(.*)$/) do |bachelor, session|
  should_have_resume_containing(bachelor, session)
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

  page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
  expect(current_path).to eq(path_to("la page de #{output_type}"))
end