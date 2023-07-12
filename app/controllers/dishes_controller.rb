class DishesController < ApplicationController
    before_action :authenticate_request
    skip_before_action :authenticate_customer
    def create
      if params[:category].empty? || params[:category].blank?
        render json: {error: "Fields cant be blank.."}
      else  
        category=Category.find_by("name like ? ","%"+params[:category]+"%")
        dish=@current_user.restaurant.dishes.new((set_params).merge(category_id: category.id))
        dish.image.attach(params[:image])
        return  render json: dish if dish.save
        render json: dish.errors.full_messages
      end
      rescue NoMethodError
      render json: {error: "Fields cant be blank.."}
    end
    
    def show 
      dish = @current_user.restaurant.dishes.find(params[:id])
      return  render json: dish  if dish
      render json: {message: "Dish not found"}
      rescue ActiveRecord::RecordNotFound
      render json: {message: "Dish id is wrong.."}
    end

    def update_dish
      dish =@current_user.restaurant.dishes.find_by(id: params[:id])
      return  render json: dish if dish.update(set_params)
      render json: {errors: dish.errors.full_messages}
      rescue NoMethodError
      render json: {message: "ID not found.."}
    end

    def destroy_dish
      dish =@current_user.restaurant.dishes.find_by(id: params[:id])
      return render json: dish if dish.destroy 
      render json: {errors: dish.errors.full_messages}
      rescue NoMethodError
      render json: {message: "ID not found.."}
    end

  private
  def set_params
    params.permit(:name ,:price ,:image)
  end 
end
