Rails.application.routes.draw do
  devise_for :users do
    match 'users/sign_out' => "devise/sessions#destroy"
  end
  root "static_pages#home"
  get "static_pages/help"
  get "static_pages/about"
end
