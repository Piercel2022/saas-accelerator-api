class Api::V1::BaseController < ApplicationController
    module Api
        module V1
          class BaseController < ApplicationController
            include JWTAuthentication
            
            before_action :authenticate_request
            
            private
            
            def authenticate_request
              header = request.headers['Authorization']
              token = header.split(' ').last if header
              
              begin
                decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)
                @current_user = User.find(decoded[0]['user_id'])
              rescue JWT::DecodeError
                render json: { error: 'Invalid token' }, status: :unauthorized
              end
            end
          end
        end
      end
end
