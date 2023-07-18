class RestaurantsController < ApplicationController
  before_action :authenticate_request 
  before_action :owner_check ,only: [:create,:update,:destroy]
  before_action :customer_check ,except: [:create,:update,:destroy]
  before_action :find_restaurant ,only: [:update, :destroy]
  
  def create
    restaurant = @current_user.build_restaurant(set_params)
    return  render json: restaurant if restaurant.save
    render json: restaurant.errors.full_messages
  end

  def update
    return render json: {message: " Updated successfully!!", data:@restaurant} if @restaurant.update(set_params)    
    render json: {errors: @restaurant.errors.full_messages}
  end

  def destroy
    return render json: {message: " Restaurant deleted!!", data:@restaurant}  if @restaurant.destroy    
    render json: {errors: @restaurant.errors.full_messages}
  end

  def search_by_status
    restaurant = Restaurant.where(status: params[:status])
    return render json: restaurant unless restaurant.empty? 
    render json: {error: "No Restaurant available... "}
  end

  def search_by_restaurant_name
    restaurant = Restaurant.where("name like ?","%"+params[:name].strip+"%")
    return  render json: restaurant unless restaurant.empty?
    render json: {error: "No such restaurant found... "}                
  end

  def search
    if params[:status].present?
      search_by_status()
    elsif params[:name].present?
      search_by_restaurant_name()
    else
      render json: Restaurant.all
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

  def find_restaurant
    @restaurant = @current_user.restaurant
  end
end
