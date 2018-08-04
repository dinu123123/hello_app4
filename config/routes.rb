  Rails.application.routes.draw do
  resources :generic_tolls
  resources :invoiced_trips
  resources :clients
  resources :belgium_tolls


  get 'germany_tolls/index'
  get 'germany_tolls/import'


  get 'fuel_expenses/index'

  get 'fuel_expenses/import'

  get 'events/extract_out'
  get "/events/extract_explicit"
  #resources :fuel_expenses


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
  get "/events/extract_explicit", as: "explicit"

  get "/de_tolls/file_import", as: "de_toll_file_import"
  get "/de_tolls/index", as: "de_toll_index_import"

  get "/fuel_expenses/file_import", as: "fuel_expense_file_import"


  resources :fuel_expenses do
  collection { post :import}
  end

  resources :germany_tolls do
  collection { post :import }
  end


  resources :de_tolls do
  collection { post :import }
  end

  #root to: "fuel_expenses#index"

  #root to: "germany_tolls#index"


  resources :main_menus
  resources :events
  resources :driver_expenses
  resources :drivers
  resources :truck_expenses
  resources :trucks

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'extra#data_in'

end
