class OwnersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create,:login]
  skip_before_action :authenticate_customer

  def create
    sign_in=Owner.new(set_params)
    return  render json: sign_in if sign_in.save
    render json: sign_in.errors.full_messages
  end

  def login
    owner_login =Owner.find_by(email: params[:email],password: params[:password])
    if owner_login
      token = jwt_encode(user_id: owner_login.id)
      render json: {message:"#{owner_login.name} logged in successfully",token: token}
    else
      render json: {error: "Invalid email or password"}
    end
  end

  def update
    owner = Owner.find_by(id: @current_user.id)
    return render json: {message: " Updated successfully!!", data:owner} if owner.update(set_params)
    # render json: {errors: owner.errors.full_messages}
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
