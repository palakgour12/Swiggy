class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :dish
  before_save :generate_order_id
  has_many :orders

  validates :dish_id,presence: true

  def generate_order_id
      self.order_id = SecureRandom.hex[0..5]
  end
end
