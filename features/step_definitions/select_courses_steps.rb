# encoding: utf-8

Étantdonné(/^je choisi (.*) comme cours qui m'intéressent$/) do |string_of_courses|
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

Étantdonné(/^je spécifie les congés:$/) do |leaves|
  within '.leaves-list' do
    leaves.hashes.each do |leave|
      find('a', text: 'Ajouter un congé').click
      all(".leave-row select[name='filters[leaves][][weekday]']").last.select leave['Jour']
      all(".leave-row select[name='filters[leaves][][from-time]']").last.select leave['Début']
      all(".leave-row select[name='filters[leaves][][to-time]']").last.select leave['Fin']
    end
  end
end

Lorsque(/^je soumets mon choix$/) do
  within '.courses_choice' do
    click_button 'Soumettre'
  end
end