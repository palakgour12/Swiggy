class DishesController < ApplicationController
  before_action :authenticate_request
  before_action :owner_check ,except: [:search_dish, :search_category]
  before_action :customer_check ,only: [:search_dish, :search_category]
  
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
    render json: {message: "Enter valid dish id.."}
  end

  def destroy
    dish = @current_user.restaurant.dishes.find_by(id: params[:id])
    return render json: dish if dish.destroy 
    render json: {errors: dish.errors.full_messages}
    rescue NoMethodError
    render json: {message: "Enter valid dish id.."}
  end

  def search_by_id #particular
    dish = @current_user.restaurant.dishes.find_by_id params[:id]
    return  render json: dish  if dish
    render json: {message: "Please enter valid dish id"}
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

  def search_dish #customer
    if params[:dish].strip.empty? 
      render json: {message: "Enter dish and restaurant name.. "}
    else
      hotel = Restaurant.find_by("name like ?","%"+params[:hotel_name].strip+"%")
      dish = Dish.where("name like '%#{params[:dish].strip}%' AND restaurant_id = #{hotel.id} ")
      return render json: dish unless dish.empty?
      render json: {error: "Enter valid dish and restaurant.."}
    end
    rescue
    render json: {error: "Invalid restaurant or dish.."} 
  end

def search_category #customer***
  category_name = params[:category].strip if params[:category]
  hotel_name=params[:hotel_name].strip if params[:hotel_name]
  return  render json: {error: "Please enter valid category and restaurant..."} if category_name.blank?|| hotel_name.blank?
  category =  Category.find_by("name like ?","%#{category_name}%")
  restaurant= Restaurant.find_by("name like ?","%#{hotel_name}%")
  return render json:  {error: "Please enter valid category and restaurant..."} if category.nil? || restaurant.nil?
  dish = Dish.find_by(category_id: category.id, restaurant_id: restaurant.id)
  if dish.nil?
    render json: {message: "No dish found..."}
  else 
    render json: {data: [restaurant.name,category.name,dish.name]}, status: :ok 
  end
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
