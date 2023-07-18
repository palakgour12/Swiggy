class DishesController < ApplicationController
  before_action :authenticate_request
  before_action :owner_check ,except: [:search_dish, :search_category]
  before_action :customer_check ,only: [:search_dish, :search_category]
  before_action :find_dish_id ,only: [:update, :destroy, :search_by_id]
  
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
    return  render json: @dish if @dish.update(set_params)
    render json: {errors: @dish.errors.full_messages}
  end

  def destroy
    return render json: {message: "dish removed from menu.."} if @dish.destroy 
    render json: {errors: @dish.errors.full_messages}
  end

  def search_by_id 
    return  render json: @dish
  end

  def search_namewise  
    return  render json: {error: "Enter any dish name.."} unless params[:dish].present?                                 
    restaurant = @current_user.restaurant
    dish = Dish.where("name like ? AND restaurant_id = ? ", "%"+params[:dish].strip+"%", restaurant.id)
      return  render json: dish unless dish.empty?
      render json: {error: "Dish not found..."} 
      rescue NoMethodError
      render json: {message: "Enter valid dish name.."}
  end

  def search_categorywise 
    return  render json: {error: "Field cant be blank..."} unless params[:category].present?
    dishes = Dish.joins(:category).where("categories.name like ? ","%#{params[:category].strip}%") 
    if dishes
      result=[]
      dishes.each do |dish|
      restaurant = dish.restaurant
        if restaurant.user_id == @current_user.id
          result.append(dish)
        end
      end
      render json: result
    else
      render json: {error: "Dish not found..."}
    end
  end  

  def search_dish #customer
    unless params[:dish].present? and params[:hotel_name].present?
      render json: {message: "Enter dish and restaurant name.. "}
    else
      dish = Dish.joins(:restaurant).where("restaurants.name like '%#{params[:hotel_name].strip}%' and dishes.name like '%#{params[:dish].strip}%'" )
       return render json: dish unless dish.empty?
      render json: {error: "Enter valid dish and restaurant.."}
    end
  end

  def search_category
    category = Category.where("name like ?","%#{params[:category]}%")
    render json: category
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

  def find_dish_id
    @dish = @current_user.restaurant.dishes.find_by(id: params[:id])
    unless @dish
      render json: {error: "Enter valid dish id.."}
    end
    rescue NoMethodError
    render json: {message: "Add restaurant first.."}
  end

end
