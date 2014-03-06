# encoding: utf-8

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