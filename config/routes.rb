EtsHoraire::Application.routes.draw do
  root 'select_file#index'

  get 'select_file' => 'select_file#index', as: :select_file
  post 'select_file' => 'select_file#upload'
  get 'schedule' => 'schedule#index', as: :schedule
  post 'schedule' => 'schedule#compute'
end
