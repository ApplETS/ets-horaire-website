# encoding: utf-8

Étantdonné /^je suis un étudiant en (.*), inscrit à la session d’(.*)$/ do |bachelor, session|
  visit path_to("la page d'accueil")

  slug = session.downcase.gsub(/[Éé]/, 'e').gsub(' ', '_')
  id = "##{slug}-panel-collapse"
  click_link(session) unless find(id, visible: false)['class'].split(' ').include?('in')
  within(id) { click_link(bachelor) }

  should_have_resume_containing(bachelor, session)
end