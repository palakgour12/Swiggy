class Dish < ApplicationRecord
  belongs_to :category
  belongs_to :restaurant
  has_many :cart ,dependent: :destroy
  has_one_attached :image, dependent: :destroy

  validates :name,:price,:image, presence: true
  
  before_save :detach_spaces

  def detach_spaces
    self.name = name.strip()
  end
end




