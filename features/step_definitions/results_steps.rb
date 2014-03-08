# encoding: utf-8

Alors(/^il devrait n'y avoir que (\d+) résultats possibles$/) do |nb_results|
  within '#results' do
    expect(page).to have_selector('.result-caption', text: "Nombre de combinaisons: #{nb_results}")
  end
end

Alors(/^il devrait y avoir une mention de (.*) à la session d’(.*)$/) do |bachelor, session|
  should_have_resume_containing(bachelor, session)
end

Alors(/^il devrait y avoir une mention des cours sélectionnés: (.*)$/) do |string_of_courses|
  courses = string_of_courses.split(/\s*[, ]\s*|\s*et\s*/).reject(&:empty?)
  within '.courses-list' do
    courses.each do |course|
      expect(page).to have_selector('label', text: course)
    end
  end
end

Alors(/^il devrait y avoir une mention de la contrainte de (\d+) cours(.*)$/) do |nb_courses, leave_condition|
  expect(page).to have_selector("input.number-of-courses[value='#{nb_courses}']")
  expect(page).to have_selector(".leaves input[value='Aucun']") if leave_condition == ', sans aucun congé'
end

Alors(/^il devrait y avoir des mentions pour les congés:$/) do |leaves|
  within '.leaves table' do
    leaves.hashes.each do |leave|
      has_leave = all('tbody tr').any? do |leave_row|
        begin
          leave_row.find('td', text: leave['Jour'])
          leave_row.find('td', text: leave['Début'])
          leave_row.find('td', text: leave['Fin'])

          true
        rescue Capybara::ElementNotFound
          false
        end
      end
      fail "Leave: #{leave} not found" unless has_leave
    end
  end
end

Lorsque(/^je sélectionne le (.*)$/) do |output_type|
  click_link output_type

  page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
  expect(current_path).to eq(path_to("la page de #{output_type}"))
end