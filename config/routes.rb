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

      # -------------------- #
      #      Customers       #
      # -------------------- #
      namespace :customers do
        concerns :findable
      end
      resources :customers, only: [:index, :show] do
        scope module: :customers do
          resources :invoices, :transactions, only: [:index]
        end
      end

      # -------------------- #
      #        Items         #
      # -------------------- #
      namespace :items do
        concerns :findable
      end
      resources :items, only: [:index, :show] do
        scope module: :items do
          resources :invoice_items, only: [:index]

      # -------------------- #
      #     Transactions     #
      # -------------------- #
      namespace :transactions do
        concerns :findable
      end
      resources :transactions, only: [:index, :show] do
        scope module: :transactions do

      # -------------------- #
      #       Invoices       #
      # -------------------- #
      namespace :invoices do
        concerns :findable
      end
      resources :invoices, only: [:index, :show] do
        scope module: :invoices do
          resources :transactions, :items, :invoice_items, only: [:index]
        end
      end
        end
      end
    end
  end
end
