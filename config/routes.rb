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
        get :random, action: :show, controller: :random
        get :most_revenue, action: :index, controller: :most_revenues
        get :revenue, action: :index, controller: :most_revenues
        get :most_items, action: :index, controller: :most_items
      end
      resources :merchants, only: [:index, :show] do
        scope module: :merchants do
          resources :items, :invoices, :customers_with_pending_invoices, only: [:index]
          get :revenue, action: :show, controller: :revenue
          get :favorite_customer, action: :show, controller: :favorite_customer
        end
      end

      # -------------------- #
      #      Customers       #
      # -------------------- #
      namespace :customers do
        concerns :findable
        get :random, action: :show, controller: :random
      end
      resources :customers, only: [:index, :show] do
        scope module: :customers do
          resources :invoices, :transactions, only: [:index]
          get :favorite_merchant, action: :show, controller: :favorite_merchant
        end
      end

      # -------------------- #
      #        Items         #
      # -------------------- #
      namespace :items do
        concerns :findable
        get :random, action: :show, controller: :random
        get :most_revenue, action: :index, controller: :most_revenues
        get :most_items, action: :index, controller: :most_items
      end
      resources :items, only: [:index, :show] do
        scope module: :items do
          resources :invoice_items, only: [:index]
          get :merchant, action: :show, controller: :merchants
          get :best_day, action: :show, controller: :best_day
        end
      end

      # -------------------- #
      #     Transactions     #
      # -------------------- #
      namespace :transactions do
        concerns :findable
        get :random, action: :show, controller: :random
      end
      resources :transactions, only: [:index, :show] do
        scope module: :transactions do
          get :invoice, action: :show, controller: :invoices
        end
      end

      # -------------------- #
      #       Invoices       #
      # -------------------- #
      namespace :invoices do
        concerns :findable
        get :random, action: :show, controller: :random
      end
      resources :invoices, only: [:index, :show] do
        scope module: :invoices do
          resources :transactions, :items, :invoice_items, only: [:index]
          get :merchant, action: :show, controller: :merchants
          get :customer, action: :show, controller: :customers
        end
      end

      # -------------------- #
      #     InvoiceItems     #
      # -------------------- #
      namespace :invoice_items do
        concerns :findable
        get :random, action: :show, controller: :random
      end
      resources :invoice_items, only: [:index, :show] do
        scope module: :invoice_items do
          get :item, action: :show, controller: :items
          get :invoice, action: :show, controller: :invoices
        end
      end
    end
  end
end
