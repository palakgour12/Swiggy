class CustomersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create,:login]
  skip_before_action :owner_check
  before_action :customer_check , only: [:update, :destroy]
  before_action :find_customer , only: [:update, :destroy, :show]

  def create
    sign_in = User.new(set_params)
    return  render json: sign_in if sign_in.save
    render json: sign_in.errors.full_messages
  end

  def login
    login = User.find_by(email: params[:email],password: params[:password])
    if login
      token = jwt_encode(user_id: login.id)
      render json: {message:"#{login.name} logged in successfully",token: token}, status: :ok
    else
      render json: {error: "Invalid email or password.."}
    end
  end

  def update
    return  render json: {message: " Updated successfully!!", data:@customer}  if @customer.update(set_params)     
    render json: {errors: @customer.errors.full_messages}
  end
  
  def destroy
    return  render json: { message: "Your account has been deleted" } if @customer.destroy
    render json: { errors: @customer.errors.full_messages }
  end

   def show
    render json: @customer
  end
  
  private
  def set_params
    params.permit(:name,:email,:password,:type)
  end 


  def find_customer
    @customer = @current_user
    return @customer
  end

 end
