class CategorySerializer < ActiveModel::Serializer
  attributes :id,:name
 has_many :dishes
 
end
