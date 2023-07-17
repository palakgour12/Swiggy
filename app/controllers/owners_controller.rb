class OwnersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create,:login]
  skip_before_action :customer_check
  before_action :owner_check , only: [:update, :destroy]

  def create
    sign_in = User.new(set_params)
    return  render json: sign_in if sign_in.save
    render json: sign_in.errors.full_messages
  end

  def login
    login = User.find_by(email: params[:email],password: params[:password])
    if login
      token = jwt_encode(user_id: login.id)
      render json: {message:"#{login.name} logged in successfully",token: token}
    else
      render json: {error: "Invalid email or password"}
    end
  end

  def update
    owner = @current_user
    return render json: {message: " Updated successfully!!", data:owner} if owner.update(set_params)
    render json: {errors: owner.errors.full_messages}
  end
  
  def destroy
    owner = @current_user
   return  render json: { message: "Your account has been deleted" }  if owner.destroy
   render json: { errors: owner.errors.full_messages }
  end
  
  private
  def set_params
    params.permit(:name,:email,:password,:type)
  end 
end
