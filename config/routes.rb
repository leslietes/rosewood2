Rails.application.routes.draw do

  resources :faqs

  get 'admin'   => "checkins#index"
  scope :admin do
    devise_for :users
    resource :setting, only: [:create,:edit, :update,:show]
    resources :rooms do
      get 'vacancies', on: :collection
      resources 'reservations', except: :index
    end
    resources :checkins, except: [:edit,:update,:destroy] do
      post 'new_roommate',    on: :member
      get  'remove_occupant', on: :member
      get  'remove_utility',  on: :member
      get  'vacate',          on: :member
      post 'transfer',        on: :member
      get  'print',           on: :collection
      resources :notices, except: [:index,:destroy]
    end
    resources :occupants
    resources :utilities
    resources :billings do
      resources :billing_details, except: [:new,:create] do
        post 'add_billing_utilities', on: :member
        delete 'remove_billing_utilities', on: :member
        delete 'remove_billing_occupant', on: :member
        post 'add_billing_occupant', on: :member
      end

      get  'electricity_reading', on: :member
      post 'electricity_reading', on: :member
      get  'water_reading', on: :member
      post 'water_reading', on: :member
      get  'reports',         on: :collection
      get  'print_summary',   on: :member
      get  'final_billing',   on: :member
      post 'final_billing',   on: :member
    end
    resources :users, only: :index

    delete 'admin/billings/:billing_id/billing_details_id/:billing_details_id/billing_utilities/:id' => 'billing_details#remove_billing_utilities', as: :remove_billing_utilities

    put 'billings/:billing_id/billing_details/:billing_details_id/add_comment' => 'billing_details#add_comments', as: :add_billing_detail_comments
  end

  match 'contact' => "home#contact", :via => [:get, :post]
  get   'location'=> "home#location"

  devise_scope :user do
    get 'login', :to => 'devise/sessions#new'
    get 'logout',:to => 'devise/sessions#destroy'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # redirect to home page on 404
  get  '*path' => redirect('/')

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
