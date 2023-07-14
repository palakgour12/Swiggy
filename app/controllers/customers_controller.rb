class CustomersController < ApplicationController
  skip_before_action :authenticate_customer, only: [:create,:login]
  skip_before_action :authenticate_request

  def create
    sign_in = Customer.new(set_params)
    return  render json: sign_in if sign_in.save
    render json: sign_in.errors.full_messages
  end

  def login
    login = Customer.find_by(email: params[:email],password: params[:password])
    if login
      token = jwt_encode(customer_id: login.id)
      render json: {message:"#{login.name} logged in successfully",token: token}, status: :ok
    else
      render json: {error: "Invalid email or password.."}
    end
  end

  def search_dish
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

  def search_category
    category_name = params[:category].strip if params[:category]
    hotel_name=params[:hotel_name].strip if params[:hotel_name]
    return  render json: {error: "Please enter valid category and restaurant..."} if category_name.blank?|| params[:hotel_name].blank?
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
  
  def update
    customer = Customer.find_by(id: @current_customer.id)
    return  render json: {message: " Updated successfully!!", data:customer}  if customer.update(set_params)     
    render json: {errors: customer.errors.full_messages}
  end
  
  def destroy
    customer = Customer.find_by(id: @current_customer.id)
    return  render json: { message: "Your account has been deleted" } if customer.destroy
    render json: { errors: customer.errors.full_messages }
  end
  
  private
  def set_params
    params.permit(:name,:email,:password)
  end 


end
