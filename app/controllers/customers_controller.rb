class CustomersController < ApplicationController
  skip_before_action :authenticate_customer, only: [:create,:login]
  skip_before_action :authenticate_request

  def create
    sign_in=Customer.new(set_params)
    return  render json: sign_in if sign_in.save
    render json: sign_in.errors.full_messages
  end

  def login
    login_data =Customer.find_by(email: params[:email],password: params[:password])
    if login_data
      token = jwt_encode(customer_id: login_data.id)
      render json: {message:"#{login_data.name} logged in successfully",token: token}, status: :ok
    else
      render json: {error: "Invalid email or password.."}
    end
  end

  def search_dish
    if params[:dish].strip.empty? 
      render json: {message: "Enter dish and restaurant name.. "}
    else
      hotel=Restaurant.find_by("name like ?","%"+params[:hotel_name].strip+"%")
      dish=Dish.where("name like '%#{params[:dish].strip}%' AND restaurant_id = #{hotel.id} ")
      return render json: dish unless dish.empty?
      render json: {error: "Enter valid dish and restaurant.."}
    end
    rescue
    render json: {error: "Invalid restaurant or dish.."} 
  end

  def search_category
    unless params[:category].strip.empty?|| params[:category].blank? && params[:hotel_name].strip.empty? || params[:hotel_name].blank?
      @check =  Category.find_by("name like '%#{params[:category].strip}%'")
      @rest= Restaurant.find_by("name like '%#{params[:hotel_name].strip}%'")
      @dish = Dish.find_by(category_id: @check.id, restaurant_id: @rest.id)
      array=[]
      array<<@rest.name
      array<<@check.name 
      array<<@dish.name
      render json: {data: array}, status: :ok
    else 
      render json: {error: "Please enter valid category and restaurant..."}
    end
    rescue NoMethodError
    render json: {message: "Please enter valid category and restaurant..."}       
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
