class OwnersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create,:login]
  skip_before_action :authenticate_customer

  def create
    owner=Owner.new(set_params)
    return  render json: owner if owner.save
    render json: owner.errors.full_messages
  end

  def login
    owner =Owner.find_by(email: params[:email],password: params[:password])
    if owner
      token = jwt_encode(user_id: owner.id)
      render json: {message:"#{owner.name} logged in successfully",token: token}
    else
      render json: {error: "Invalid email or password"}
    end
  end

  def search_dwn    
    return  render json: {error: "Enter any dish name.."} if params[:dish].nil? || params[:dish].blank?                                      
    a=@current_user.restaurant
    dish=Dish.where("name like ? AND restaurant_id = ? ", "%"+params[:dish].strip+"%", a.id)
    return  render json: dish unless dish.empty?
    render json: {error: "Dish not found..."} 
  end

  def index #list my dishes
    dish=@current_user.restaurant.dishes
    return render json: dish unless dish.empty?
    render json: {message: "No Dish available"}
  end 

  def search_categorywise
    return  render json: {error: "Field cant be blank..."} if params[:category].empty? || params[:category].blank?
    # name= params[:category].strip
    @check = Category.find_by("name like ? ","%"+params[:category]+"%")
    @rest=@current_user.restaurant 
    dish = Dish.where(category_id: @check.id, restaurant_id: @rest.id)
    render json: dish
    rescue NoMethodError
    render json: {error: "Category is invalid..."}
  end


  def update_owner
    owner = Owner.find_by(id: @current_user.id)
    return render json: {message: " Updated successfully!!", data:owner} if owner.update(set_params)
    render json: {errors: owner.errors.full_messages}
  end
  
  def destroy
    owner = Owner.find_by(id: @current_user.id)
   return  render json: { message: "Your account has been deleted" }  if owner.destroy
   render json: { errors: owner.errors.full_messages }
  end
  
  private
  def set_params
    params.permit(:name,:email,:password)
  end 
end
