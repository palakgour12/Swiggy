class RestaurantsController < ApplicationController
  before_action :authenticate_request
  skip_before_action :authenticate_customer
  
  def create
    res= @current_user.build_restaurant(set_params)
    return  render json: res if res.save
    render json: res.errors.full_messages
  end

  def update_rest
    rest =@current_user.restaurant
    return render json: {message: " Updated successfully!!", data:rest} if rest.update(set_params)    
    render json: {errors: rest.errors.full_messages}
    rescue NoMethodError
    render json: {message: "ID not found.."}
  end

  def destroy_rest
    rest =@current_user.restaurant
    return render json: {message: " Restaurant deleted!!", data:rest}  if rest.destroy    
    render json: {errors: rest.errors.full_messages}
    rescue NoMethodError
    render json: {message: "ID not found.."}
  end

  private
  def set_params
    params.permit(:name,:address,:status)
  end 

end
