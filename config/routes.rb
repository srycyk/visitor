
Rails.application.routes.draw do
  devise_for :users

  resources :tags do
    resources :bookmarks #, shallow: true
  end

  resources 'bookmarks', only: %i(index)

  resources :import_bookmarks, only: %i(index create update)

  resources :export_bookmarks, only: %i(index)

  get 'help', to: 'help#index'

  root to: 'help#index'
end
