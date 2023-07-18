class CartsController < ApplicationController
	before_action :authenticate_request
	skip_before_action :owner_check
	before_action :customer_check

	def create
		order = @current_user.carts.new(set_params)                  
		return render json: { message: "#{@current_user.name } your order has been placed successfully..."} if order.save
		render json: { message: "Please enter valid dish id.." }
	end

	def show
		orders = @current_user.carts.all
		return render json: orders unless orders.empty?
		render json: { error: "Order history is empty" }
	end

	def search_by_order_id
		order = @current_user.carts.find_by(order_id: params[:order_id])
		return render json: order if order.present?
		render json: { error:"No Order found..." }
	end

	def destroy
		order = @current_user.carts.find_by(id: params[:id])
		return render json: {message: "Order deleted from order history"} if order.destroy 
		render json: { errors: order.errors.full_messages }
		rescue NoMethodError
		render json: { message: "Order id is wrong..." }
	end

	private
	def set_params
		params.permit(:dish_id)
	end

end
