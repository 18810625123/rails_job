Rails.application.routes.draw do
  resources :works
  resources :recruit_infos
  resources :cities
  resources :industries
  resources :companies

  mount V1, at: '/v1/'

end
