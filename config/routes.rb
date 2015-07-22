Rails.application.routes.draw do

  root to: 'categories#index'
  resources :questions, except: [:index,:edit,:update] do
    member do
      post :vote
    end
    resources :comments, only: [:create] do
      member do
        post :vote
      end
    end
  end

  resources :images, except: [:index,:edit,:update] do
    member do
      post :vote
    end
    resources :comments, only: [:create] do
      member do
        post :vote
      end
    end
  end

  resources :categories, except: [:edit,:update] do
    member do
      get :search
    end
  end

  get '/register', to: 'users#new'
  resources :users, only: [:show, :create,:edit,:update] do
    member do
      post :member
      get :notifications
    end 
  end

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  resources :sessions, only: :create

  get 'group/search_school_index', to: 'groups#search_school_index' 
  resources :groups, except: [:edit,:update,:destroy] do 
    get 'category/:id', to: 'groups#category', as: :category 
    get 'search_group_category', path: '/category/:id/search_group_category'
    resources :gategories, only: [:show,:new,:create] do
      member do
        get :search
      end
    end
    member do
      get :search
    end
  end

  resources :searches, only: [:index]

  resources :my_classes, only: [:create]
  delete 'my_classes/delete', to: 'my_classes#destroy'
  get 'my_classes/info', to: 'my_classes#info'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
