EtsHoraire::Application.routes.draw do
  root 'select_bachelor#index'

  get 'baccalaureats' => 'select_bachelor#index', as: :select_bachelor
  post 'baccalaureats' => 'select_bachelor#choose'
  get 'choix_de_cours' => 'select_courses#index', as: :select_courses
  post 'choix_de_cours' => 'select_courses#compute'
  get 'resultats' => 'output#index', as: :output
  get 'resultats/:output_type' => 'output#result', as: :output_result
end
