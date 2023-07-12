Rails.application.routes.draw do
 
  #...............owner............................
  delete '/destroy' , to: "owners#destroy"
  patch '/update_owner', to: "owners#update_owner"
  get '/search_dwn', to: "owners#search_dwn"
  post '/login' ,to: "owners#login"
  get '/search_categorywise' ,to: "owners#search_categorywise"
  resources :owners

  #............restaurant..............
  patch '/update_rest' ,to: "restaurants#update_rest"
  delete '/destroy_rest' ,to: "restaurants#destroy_rest"
  resources :restaurants
  #............dish.........................
  delete '/destroy_dish' , to: "dishes#destroy_dish"
  patch '/update_dish' ,to: "dishes#update_dish"
  resources :dishes
  
  #..............customer...........................
  post '/order_list' ,to: "customers#order_list"
  get '/status' ,to: "customers#status"
  get '/search_restaurant' ,to: "customers#search_restaurant"
  get '/search_dish', to: "customers#search_dish"
  get '/search_category', to: "customers#search_category"
  post 'customer/login' ,to: "customers#login"
  patch '/update_cust' ,to: "customers#update_cust"
  delete '/destroy_cust' ,to: "customers#destroy_cust"
  resources :customers

  #................cart..........................
  resources :carts
  delete '/destroy_cart' , to: "carts#destroy_cart"
  get '/order_id', to: 'carts#search_by_id'

end
