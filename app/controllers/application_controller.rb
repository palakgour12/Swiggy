class ApplicationController < ActionController::API
  include JsonWebToken
  before_action :authenticate_request
  before_action :owner_check
  before_action :customer_check

  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end
  private
  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound 
      render json: {error: "User not found" }                                #change
    rescue JWT::DecodeError 
      render json: {error: "You need to login first" }                          #change
  end
   
   def owner_check
    unless @current_user.type == 'Owner'
        render json: {error: 'Owner not found..'}
    end
  end

  def customer_check
    unless @current_user.type == 'Customer'
        render json: {error: 'Customer not found..'}
    end
  end
  
end
