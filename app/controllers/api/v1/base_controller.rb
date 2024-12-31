module Api
    module V1
      class BaseController < ApplicationController
        include ActionController::MimeResponds
        
        before_action :authenticate_request
        
        private
        
        def authenticate_request
          header = request.headers['Authorization']
          token = header.split(' ').last if header
          begin
            @decoded = JsonWebToken.decode(token)
            @current_user = User.find(@decoded[:user_id])
          rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
            render json: { error: 'Unauthorized' }, status: :unauthorized
          end
        end
        
        def current_user
          @current_user
        end
        
        def render_error(message, status = :unprocessable_entity)
          render json: { error: message }, status: status
        end
      end
    end
  end