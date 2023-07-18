Rails.application.routes.draw do
 
  #...............owner............................
  post '/login' ,to: "owners#login"
  resource :owners

  #............restaurant..........................
  get '/search' ,to: "restaurants#search"
  resource :restaurants
  
  #............dish................................
  # get '/search_dish', to: "dishes#search_dish"
  get '/search_dwn', to: "dishes#search_namewise"
  get '/search_categorywise' ,to: "dishes#search_categorywise"
  get '/search_by_id' ,to: "dishes#search_by_id"
  get '/search_dish', to: "dishes#search_dish"
  get '/search_category', to: "dishes#search_category"
  resource :dishes
  
  #..............customer...........................
  
  post 'customer/login' ,to: "customers#login"
  resource :customers

  #................cart..........................
  get '/search_by_order_id', to: 'carts#search_by_order_id'
  resource :carts

end
