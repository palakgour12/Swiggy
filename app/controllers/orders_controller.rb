class OrdersController < ApplicationController
	def create
		order = @current_user.orders.new(set_params)                  
		return render json: { message: "#{@current_user.name } your order has been placed successfully..."} if order.save
		render json: { message: "Please enter valid dish id.." }

	end


	private
	def set_params
		params.permit(:order_id)
	end
end
