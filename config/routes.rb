  Rails.application.routes.draw do
  
  
  resources :card_events
  resources :cards
  resources :dispatchers
  resources :periodics_categories
  resources :pricings
  resources :trailers
  devise_for :users, :controllers => { :sessions => "custom_sessions", :registrations => "registrations"}, 
                     path_names: {sign_in: "login", sign_out: "logout"}


devise_scope :user do
  match '/sign-in', to: "devise/sessions#new", via: :login
end

  resources :generic_tolls do
  collection { post :import}
  end

  
  resources :clients do
  collection { post :import}
  end
  
  resources :belgium_tolls do
  collection { post :import}
  end




  get 'germany_tolls/index'
  get 'germany_tolls/import'
  get 'fuel_expenses/index'
  get 'fuel_expenses/import'
  get 'events/extract_out'
  #get '/events/delete_upload'

  # https://stackoverflow.com/questions/30315498/ruby-on-rails-how-to-link-route-from-one-view-page-to-another-view-page-with-a
  # linking a web page path to another page
  # In your routes.rb:
  # get "/path/to/your/mission/page", to: "static_pages#mission", as: "mission"
  # In our case we didnt need the to: paramenter; see the <%= link_to "OUT", mission_url %> present 
  # in our application.html.erb
  #
  # In the submit forms you need to use mission_path rather than mission
  # example:
  # <%= form_tag mission_path, :method => 'get' do %> 

  # there should exist a controller with the same name as events and inside a method extract_out

  # The button all clicks from any page inside events are intercepted by the events controler which should 
  # have an extract_out method to handle the request
  get "/events/extract_out", as: "mission"
 
  get "/events/index", as: "mission2"

  get "/activities/index", as: "mission5"
  get "/activities/CombinexPallets", as: "mission51"
  get "/activities/pdf_index", as: "mission52"

  get "/periodics/index", as: "mission6" 
  get "/repairs/index", as: "mission7" 

  get "/extra/dkv", as: "dkv_import_url"


  get "/invoiced_trips/index", as: "mission3"
  get "/invoiced_trips/index_special", as: "index_special"
  get "/invoiced_trips/new_special", as: "new_special"






  get "/invoices/index", as: "mission4"

  get "/driver_expenses/index", as: "dv"

  get "/truck_expenses/index", as: "tr"


  get "/events/extract_explicit", as: "mission1"

  get "/events/weekly", as: "weekly"
  get "/events/weekly", as: "schedule"


  get "/events/db", as: "db"

  post 'invoiced_trips/print', to: 'invoiced_trips#print' 
  post 'invoices/print', to: 'invoices#print' 
  post 'invoices/email', to: 'invoices#email' 
 
  post 'activities/email', to: 'activities#email' 


  get "/events/help", as: "help"
  get "/events/oil", as: "oil"



  get "/de_tolls/file_import", as: "de_toll_file_import"
  get "/de_tolls/index", as: "de_toll_index_import"

  get "/drivers/index", as: "drivers_index_import"

  get "/be_tolls/file_import", as: "be_toll_file_import"
  get "/be_tolls/index", as: "be_toll_index_import"

  get "/fuel_expenses/file_import", as: "fuel_expense_file_import"


get "home/download_pdf"


  resources :fuel_expenses do
  collection { post :import}
  collection { post :import_as24}
  collection { post :import_dkv}
  end

  resources :de_tolls do
  collection { post :import }
  collection { post :import_as24 }  
  end


  resources :be_tolls do
  collection { post :import }
  end

  resources :trucks do
  collection { post :import }
  end

  resources :drivers do
  collection { post :import }
  end

  resources :events do
   collection { post :import }
   collection { post :import_db }
  end

  resources :events do
    member do
      delete :delete_image
    end
  end

  resources :invoiced_trips do
  collection { post :import}
  end

  resources :invoiced_trips do
    member do
      delete :delete_image
    end
  end

  resources :invoices do
  collection { post :import}
  end

  resources :periodics  do
  collection { post :import}
  end

  resources :periodics  do
    member do
      delete :delete_image
    end
  end

  resources :repairs  do
  collection { post :import}
  end

  resources :repairs  do
    member do
      delete :delete_image
    end
  end

  resources :activities  do
    collection do
      post :import 
      post :edit_individual 
      put :update_individual 
      put :update_multiple   

    end
  end

  resources :activities  do
    member do
      delete :delete_image
    end
  end

  resources :activities  do
    member do
      delete :delete_trip_image
    end
  end

  resources :periodics_categories  do
  collection { post :import}
  end


  resources :main_menus

  resources :driver_expenses do
  collection { post :import }
  end
  
  resources :driver_expenses do
    member do
      delete :delete_image
    end
  end

  resources :truck_expenses do
  collection { post :import }
  end

  resources :truck_expenses do
    member do
      delete :delete_image
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
#root 'extra#data_in'
#root to: "extra#data_in"

root to: "extra#data_in"

#root :controller => 'static', :action => '/' 

  #get 'profiles/charities',   :to => 'profiles#charities_index'


  #get 'localhost:3000/#home'

  #get 'localhost:3000/#home', :to => "/events/weekly"
    


end
