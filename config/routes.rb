EtsHoraire::Application.routes.draw do
  root 'select_file#index'

  get 'choisir' => 'select_file#index', as: :select_file
  post 'choisir' => 'select_file#choose'
  get 'horaire' => 'schedule#index', as: :schedule
  post 'horaire' => 'schedule#compute'
end
