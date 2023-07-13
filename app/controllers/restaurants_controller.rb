class RestaurantsController < ApplicationController
  before_action :authenticate_request ,only: [:create,:update,:destroy]
  skip_before_action :authenticate_customer
  
  def create
    add_hotel= @current_user.build_restaurant(set_params)
    return  render json: add_hotel if add_hotel.save
    render json: add_hotel.errors.full_messages
  end

  def update
    hotel =@current_user.restaurant
    return render json: {message: " Updated successfully!!", data:hotel} if hotel.update(set_params)    
    render json: {errors: hotel.errors.full_messages}
    rescue NoMethodError
    render json: {message: "ID not found.."}
  end

  def destroy
    hotel =@current_user.restaurant
    return render json: {message: " Restaurant deleted!!", data:hotel}  if hotel.destroy    
    render json: {errors: hotel.errors.full_messages}
    rescue NoMethodError
    render json: {message: "ID not found.."}
  end

  def status
    return render json: {error: "Please enter status.."}  unless params[:status].present?
    hotel = Restaurant.where(status: params[:status])
      return render json: hotel unless hotel.empty? 
      render json: {error: "No Restaurant available... "}
  end

  def search_restaurant
    if params[:name].present? 
      name=params[:name].strip if params[:name]
      restaurant = Restaurant.where("name like ?","%#{name}%")
      return  render json: restaurant unless restaurant.empty?
      render json: {error: "No such restaurant found... "}    
    else    
       render json: {error: "Enter any restaurant name.."}
    end              
  end

  def show
    if params[:restaurant_id].present?
      dish=Dish.where("restaurant_id = ?", params[:restaurant_id])
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
