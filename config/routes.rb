Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :findable do
    get 'find_all', to: 'finders#index'
    get 'find', to: 'finders#show'
  end

  namespace :api do
    namespace :v1 do

      # -------------------- #
      #      Merchants       #
      # -------------------- #
      namespace :merchants do
        concerns :findable
      end
      resources :merchants, only: [:index, :show] do
        scope module: :merchants do
          resources :items, :invoices, :customers_with_pending_invoices, only: [:index]
        end
      end
      end
      resources :merchants, only: [:index, :show]
    end
  end
end
