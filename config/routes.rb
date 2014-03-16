EtsHoraire::Application.routes.draw do
  root 'select_bachelor#index'

  get 'baccalaureats' => 'select_bachelor#index', as: :select_bachelor
  post 'baccalaureats' => 'select_bachelor#choose'
  get 'choix_de_cours' => 'select_courses#index', as: :select_courses
  post 'choix_de_cours' => 'select_courses#compute'
  get 'resultats' => 'results#index', as: :results
  get 'resultats/liste_simple' => 'simple_list#index', :constraints => {format: :txt}, as: :simple_list
  get 'resultats/calendrier_ascii' => 'ascii_calendar#index', :constraints => {format: :txt}, as: :ascii_calendar
  get 'resultats/calendrier_html' => 'html_calendar#index', as: :html_calendar
end
