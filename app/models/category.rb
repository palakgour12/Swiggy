class Category < ApplicationRecord
  has_many :dishes ,dependent: :destroy
  
  before_save :detach_spaces

  def detach_spaces
    self.name = name.strip()
  end
end
