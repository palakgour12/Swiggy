class CartSerializer < ActiveModel::Serializer
  attributes :id,:order_id,:dish_name, :dish_price
  
  def dish_name
    object.dish.name
  end
 
  def dish_price
    object.dish.price
  end
 
end
