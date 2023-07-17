class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :dishes ,dependent: :destroy

  enum status: { open: 'open', close: 'close' }

  validates :name, :address, :status , presence: true , on: :create
  
  before_save :detach_spaces

  def detach_spaces
    self.name = name.strip()
    self.address = address.strip()
  end
end




