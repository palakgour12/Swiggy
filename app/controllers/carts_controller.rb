class CartsController < ApplicationController
	skip_before_action :authenticate_request

	def create
		order = @current_customer.carts.new(set_params)                  
		return render json: { message: "#{@current_customer.name } your order has been placed successfully..."} if order.save
		render json: { message: "Please enter valid dish id.." }
	end

	def show
		orders = @current_customer.carts.all
		return render json: orders unless orders.empty?
		render json: { error: "Order history is empty" }
	end

	def order_id
		order = Cart.where(order_id: params[:order_id])
		return render json: order unless order.empty?
		render json: { error:"Order not found" }
	end

	def destroy
		order =@current_customer.carts.find_by(id: params[:id])
		return render json: {message: "Order deleted from order history"} if order.destroy 
		render json: { errors: order.errors.full_messages }
		rescue NoMethodError
		render json: { message: "ID not found.." }
	end

	private
	def set_params
		params.permit(:dish_id)
	end

end
