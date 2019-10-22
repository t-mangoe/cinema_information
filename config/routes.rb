Rails.application.routes.draw do
  get 'cinema_informations/home',     to: 'cinema_informations#home'
  get 'cinema_informations/api', to: 'cinema_informations#api'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
