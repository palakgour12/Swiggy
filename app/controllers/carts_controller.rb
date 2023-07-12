class CartsController < ApplicationController
	skip_before_action :authenticate_request

	def create
		cart = @current_customer.carts.new(set_params)                  
		return render json: {message: "#{@current_customer.name} your order has been placed successfully..."} if cart.save
		render json: { message: "Cant place the order" }
	end

	def index
		cart = @current_customer.carts.all
		return render json: cart unless cart.empty?
		render json: { error: "Cart is empty" }
	end

	def search_by_id
		order = Cart.where(order_id: params[:order_id])
		return render json: order unless order.empty?
		render json: { error:"Order not found" }
	end

	def destroy_cart
		cart =@current_customer.carts.find_by(id: params[:id])
		return render json: {message: "Order deleted from order history"} if cart.destroy 
		render json: { errors: cart.errors.full_messages }
		rescue NoMethodError
		render json: { message: "ID not found.." }
	end

	private
	def set_params
		params.permit(:dish_id)
	end

end
