# encoding: utf-8

Étantdonné /^je suis un étudiant en (.*), inscrit à la session d’(.*)$/ do |bachelor, session|
  visit path_to("la page d'accueil")
  click_link session
  slug = session.downcase.gsub('é', 'e').gsub(' ', '_')
  within "##{slug}-panel-collapse" do
    click_link bachelor
  end

  should_have_resume_containing(bachelor, session)
end