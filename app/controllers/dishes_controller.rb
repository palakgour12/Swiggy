class DishesController < ApplicationController
  before_action :authenticate_request
  skip_before_action :authenticate_customer
  def create
      if params[:category].present?
        category = Category.find_by("name like ? ","%"+params[:category]+"%")
        dish = @current_user.restaurant.dishes.new((set_params).merge(category_id: category.id))
        return  render json: dish if dish.save
        render json: dish.errors.full_messages
    else
      render json: {error: "Fields cant be blank.."}
    end
  end
  
  def update
    dish = @current_user.restaurant.dishes.find_by(id: params[:id])
    return  render json: dish if dish.update(set_params)
    render json: {errors: dish.errors.full_messages}
    rescue NoMethodError
    render json: {message: "ID not found.."}
  end

  def destroy
    dish = @current_user.restaurant.dishes.find_by(id: params[:id])
    return render json: dish if dish.destroy 
    render json: {errors: dish.errors.full_messages}
    rescue NoMethodError
    render json: {message: "ID not found.."}
  end

  def search_by_id #particular
    dish = @current_user.restaurant.dishes.find(params[:id])
    return  render json: dish  if dish
    render json: {message: "Dish not found"}
    rescue ActiveRecord::RecordNotFound
    render json: {message: "Dish id is wrong.."}
  end

  def search_namewise  
    return  render json: {error: "Enter any dish name.."} unless params[:dish].present?                                 
    hotel = @current_user.restaurant
    dish = Dish.where("name like ? AND restaurant_id = ? ", "%"+params[:dish].strip+"%", hotel.id)
      return  render json: dish unless dish.empty?
      render json: {error: "Dish not found..."} 
  end

  def search_categorywise
    return  render json: {error: "Field cant be blank..."} unless params[:category].present?
    name= params[:category].strip
    @check = Category.find_by("name like ? ","%#{name}%")
    @rest = @current_user.restaurant 
    dish = Dish.where(category_id: @check.id, restaurant_id: @rest.id)
    unless dish.empty?
    render json: dish
    else
      render json: {error: "No dish found"}
    end
    rescue NoMethodError
    render json: {error: "Category is invalid..."}
  end  

def show #all 
  restaurant = @current_user.restaurant
  if restaurant.nil?
    render json:{error: "Please add restaurant first.."}
  else
    return render json: restaurant.dishes unless restaurant.dishes.empty?
    render json: {message: "No Dish available"}
  end
end 

private
  def set_params
    params.permit(:name ,:price ,:image)
  end 
end
