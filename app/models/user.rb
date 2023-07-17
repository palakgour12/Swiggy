class User < ApplicationRecord
  has_one :restaurant ,dependent: :destroy
  has_many :carts ,dependent: :destroy
  
  validates :name,format: {with: /\A[a-zA-Z]+(?: [a-zA-Z]+)*[a-zA-Z]\z/},presence: true 
  validates :email, presence: true, uniqueness: true,format: {with: /\A[a-zA-Z]+[a-zA-Z0-9._]*@[a-zA-Z]+\.+[a-z]{2,3}/}, on: :create
  validates :password, length: {minimum: 8},format: {with: /\A\S+\z/},presence: true
end
