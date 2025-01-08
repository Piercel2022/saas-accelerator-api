module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_request, only: [:login, :register]
      
      def login
        user = User.find_by(email: params[:email])
        
        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          time = Time.now + 24.hours.to_i
          
          render json: {
            token: token,
            exp: time.strftime("%m-%d-%Y %H:%M"),
            user: UserSerializer.new(user).as_json
          }, status: :ok
        else
          render_error 'Invalid email or password', :unauthorized
        end
      end
      
      def register
        user = User.new(user_params)
        
        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: {
            token: token,
            user: UserSerializer.new(user).as_json
          }, status: :created
        else
          render_error user.errors.full_messages
        end
      end
      
      def logout
        # Add token to blacklist or invalidate it
        render json: { message: 'Logged out successfully' }
      end
      
      def refresh_token
        token = JsonWebToken.encode(user_id: current_user.id)
        time = Time.now + 24.hours.to_i
        
        render json: {
          token: token,
          exp: time.strftime("%m-%d-%Y %H:%M")
        }
      end
      
      private
      
      def user_params
        params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :organization_id)
      end
    end
  end
end
