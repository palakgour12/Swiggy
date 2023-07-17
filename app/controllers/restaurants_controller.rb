class RestaurantsController < ApplicationController
  before_action :authenticate_request 
  before_action :owner_check ,only: [:create,:update,:destroy]
  before_action :customer_check ,except: [:create,:update,:destroy]
  
  def create
    restaurant = @current_user.build_restaurant(set_params)
    return  render json: restaurant if restaurant.save
    render json: restaurant.errors.full_messages
  end

  def update
    restaurant = @current_user.restaurant
    return render json: {message: " Updated successfully!!", data:restaurant} if restaurant.update(set_params)    
    render json: {errors: restaurant.errors.full_messages}
  end

  def destroy
    restaurant = @current_user.restaurant
    return render json: {message: " Restaurant deleted!!", data:restaurant}  if restaurant.destroy    
    render json: {errors: restaurant.errors.full_messages}
  end

  def status
    return render json: {error: "Please enter status.."}  unless params[:status].present?
    restaurant = Restaurant.where(status: params[:status])
      return render json: restaurant unless restaurant.empty? 
      render json: {error: "No Restaurant available... "}
  end

  def search_restaurant
    if params[:name].present? 
      name = params[:name].strip if params[:name]
      restaurant = Restaurant.where("name like ?","%#{name}%")
      return  render json: restaurant unless restaurant.empty?
      render json: {error: "No such restaurant found... "}    
    else    
       render json: {error: "Enter any restaurant name.."}
    end              
  end

  def show
    if params[:restaurant_id].present?
      dish = Dish.where("restaurant_id = ?", params[:restaurant_id])
      return  render json: dish  unless dish.empty?
      render json: {error: "Enter valid restaurant id...."}
    else
      render json:  {error: "Restaurant id cant be blank.."}
    end
  end

  private
  def set_params
    params.permit(:name,:address,:status)
  end 
end
