class CustomersController < ApplicationController
  skip_before_action :authenticate_customer, only: [:create,:login]
  skip_before_action :authenticate_request

  def create
    customer=Customer.new(set_params)
    return  render json: customer if customer.save
    render json: customer.errors.full_messages
  end

  def login
    customer =Customer.find_by(email: params[:email],password: params[:password])
    if customer
      token = jwt_encode(customer_id: customer.id)
      render json: {message:"#{customer.name} logged in successfully",token: token}, status: :ok
    else
      render json: {error: "Invalid email or password.."}
    end
  end

  def status
    if params[:status].nil? || params[:status].blank?
      render json: {error: "Please enter status.."}
    else
      status = Restaurant.where(status: params[:status])
      return render json: status unless status.empty? 
      render json: {error: "No Restaurant available... "}
    end
  end

  def search_restaurant
    if params[:name].nil? || params[:name].blank?
      render json: {error: "Enter any restaurant name.."}
    else
      name=params[:name].strip if params[:name]
      restaurant = Restaurant.where("name like ?","%#{name}%")
      return  render json: restaurant unless restaurant.empty?
      render json: {error: "No such restaurant found... "}        
    end              
  end

  def index
    if params[:restaurant_id].nil? || params[:restaurant_id].blank?
      render json:  {error: "Field cant be blank.."}
    else
      dish=Dish.where("restaurant_id = ?", params[:restaurant_id])
      return  render json: dish  unless dish.empty?
      render json: {error: "Enter valid restaurant id...."}
    end
  end
  
  def search_dish
    if params[:dish].strip.empty? 
      render json: {message: "Enter dish and restaurant name.. "}
    else
      hotel=Restaurant.find_by("name like ?","%"+params[:hotel_name].strip+"%")
      dish=Dish.where("name like '%#{params[:dish].strip}%' AND restaurant_id = #{hotel.id} ")
      return render json: dish unless dish.empty?
      render json: {error: "Fileds cant be blank.."}
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
      render json: {error: "Fields cant be blank..."}
    end
    rescue NoMethodError
    render json: {message: "Please enter valid category and restaurant..."}       
  end
  
  def update_cust
    customer = Customer.find_by(id: @current_customer.id)
    return  render json: {message: " Updated successfully!!", data:customer}  if customer.update(set_params)     
    render json: {errors: customer.errors.full_messages}
  end
  
  def destroy_cust
    customer = Customer.find_by(id: @current_customer.id)
    return  render json: { message: "Your account has been deleted" } if customer.destroy
    render json: { errors: customer.errors.full_messages }
  end
  
  private
  def set_params
    params.permit(:name,:email,:password)
  end 

end
