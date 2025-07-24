Rails.application.routes.draw do
  resources :courses
  resources :lessons do
    post 'complete', on: :member
  end
  get 'users/:id/stats', to: 'users#stats'
  post 'login', to: 'auth#login'
end 