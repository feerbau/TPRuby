Rails.application.routes.draw do
  get 'export/index'
  # get 'export_all', to: "export#export_all"
  get 'export_all', to: "export#export_all"
  get 'export_book/(:id)', to: "export#export_book", as: 'export_book'
  get 'export_note/(:id)', to: "export#export_note", as: 'export_note'
  resources :notes
  resources :books
  devise_for :users
  get 'home/index'
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
