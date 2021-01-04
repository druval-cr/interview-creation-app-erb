Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :interviews, :except => [:show]
  root "interviews#index"
end
