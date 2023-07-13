class DishesController < ApplicationController
  before_action :authenticate_request
  skip_before_action :authenticate_customer
  def create
    if params[:category].empty? || params[:category].blank?
      render json: {error: "Fields cant be blank.."}
    else  
      category=Category.find_by("name like ? ","%"+params[:category]+"%")
      dish=@current_user.restaurant.dishes.new((set_params).merge(category_id: category.id))
      dish.image.attach(params[:image])
      return  render json: dish if dish.save
      render json: dish.errors.full_messages
    end
    rescue NoMethodError
    render json: {error: "Fields cant be blank.."}
  end
  
  def update
    dish =@current_user.restaurant.dishes.find_by(id: params[:id])
    return  render json: dish if dish.update(set_params)
    render json: {errors: dish.errors.full_messages}
    rescue NoMethodError
    render json: {message: "ID not found.."}
  end

  def destroy
    dish =@current_user.restaurant.dishes.find_by(id: params[:id])
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
    a=@current_user.restaurant
    dish=Dish.where("name like ? AND restaurant_id = ? ", "%"+params[:dish].strip+"%", a.id)
      return  render json: dish unless dish.empty?
      render json: {error: "Dish not found..."} 
  end

  def search_categorywise
    return  render json: {error: "Field cant be blank..."} unless params[:category].present?
    name= params[:category].strip
    @check = Category.find_by("name like ? ","%#{name}%")
    @rest=@current_user.restaurant 
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
    dish=@current_user.restaurant.dishes
    return render json: dish unless dish.empty?
    render json: {message: "No Dish available"}
  end 

  private
  def set_params
    params.permit(:name ,:price ,:image)
  end 
end
