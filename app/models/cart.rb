class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :dish
  before_save :order
  has_many :orders

  validates :dish_id,presence: true

  def order
      self.order_id = SecureRandom.hex[0..5]
  end
end
