class DishSerializer < ActiveModel::Serializer
  attributes :id,:name,:price,:image
  
  
  def image
    object.image.url
  end
end
