class User < ApplicationRecord
  has_one :restaurant ,dependent: :destroy
  has_many :carts ,dependent: :destroy
  
  validates :name,format: {with: /\A[a-zA-Z]+(?: [a-zA-Z]+)*[a-zA-Z]\z/},presence: true 
  validates :email, presence: true, uniqueness: true,format: {with: /\A[a-zA-Z]+[a-zA-Z0-9._]*@[a-zA-Z]+\.+[a-z]{2,3}/}, on: :create
  validates :password,presence: true,format: {with: /\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x , message: "must be at least 6 characters and include one number,letter and special symbol."}
end
