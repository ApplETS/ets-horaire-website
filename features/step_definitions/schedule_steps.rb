# encoding: utf-8

Étantdonné /^je suis un ancien étudiant à l'ÉTS, inscrit à la session d’automne 2013$/ do
  visit path_to('the home page')
  click_link '2013 - Automne'
  within('#automne_2013-panel-collapse') do
    find('label', :text => 'Génie logiciel').click
  end
  click_button 'Soumettre'
end

Étantdonné(/^j'ai spécifié (.*) comme cours qui m'intéressent$/) do |courses_string|
  course_names = courses_string.split(/\s*[, ]\s*|\s*et\s*/).reject(&:empty?)
  p course_names
  sleep 50
  pending
end

Étantdonné(/^je spécifie comme contrainte les combinaisons de 3 cours seulement$/) do
  pending
end

Alors(/^je devrais recevoir un résultat de toutes les combinaisons d'horaires possibles pour 3 cours seulement$/) do
  pending
end