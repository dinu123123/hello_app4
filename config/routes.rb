  Rails.application.routes.draw do
  
  devise_for :users
  
  resources :generic_tolls do
  collection { post :import}
  end

  resources :invoiced_trips do
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

  # Butonul all clicks from any page inside events are intercepted by the events controler which should 
  # have an extract_out method to handle the request
  get "/events/extract_out", as: "mission"
  get "/events/extract_explicit", as: "mission1"

  get "/events/weekly", as: "weekly"
  
  get "/events/db", as: "db"
  get "/events/help", as: "help"

  get "/de_tolls/file_import", as: "de_toll_file_import"
  get "/de_tolls/index", as: "de_toll_index_import"

  get "/be_tolls/file_import", as: "be_toll_file_import"
  get "/be_tolls/index", as: "be_toll_index_import"

  get "/fuel_expenses/file_import", as: "fuel_expense_file_import"

  resources :fuel_expenses do
  collection { post :import}
  end

  resources :de_tolls do
  collection { post :import }
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

  resources :main_menus

  resources :driver_expenses do
  collection { post :import }
  end
  
  resources :truck_expenses do
  collection { post :import }
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
#root 'extra#data_in'
root to: "extra#data_in"

  #get 'profiles/charities',   :to => 'profiles#charities_index'


  #get 'localhost:3000/#home'

  #get 'localhost:3000/#home', :to => "/events/weekly"
    


end
