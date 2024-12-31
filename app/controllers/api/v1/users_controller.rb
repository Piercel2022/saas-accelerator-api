module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: [:show, :update, :destroy]
      before_action :authorize_organization_access, except: [:profile, :update_profile]
      
      def index
        @users = current_user.organization.users
                            .includes(:organization)
                            .order(created_at: :desc)
                            .page(params[:page])
                            .per(20)
        
        render json: @users,
               each_serializer: UserSerializer,
               meta: pagination_meta(@users)
      end
      
      def show
        render json: @user,
               serializer: UserSerializer,
               include: ['organization']
      end
      
      def create
        authorize! :create, User
        @user = current_user.organization.users.build(user_params)
        
        if @user.save
          UserMailer.welcome(@user).deliver_later
          render json: @user,
                 serializer: UserSerializer,
                 status: :created
        else
          render_error @user.errors.full_messages
        end
      end
      
      def update
        authorize! :update, @user
        
        if @user.update(user_params)
          render json: @user,
                 serializer: UserSerializer
        else
          render_error @user.errors.full_messages
        end
      end
      
      def destroy
        authorize! :destroy, @user
        
        if @user.admin? && @user.organization.users.admin.count == 1
          render_error "Can't remove the last admin user"
        else
          @user.discard # Using soft delete
          head :no_content
        end
      end
      
      def profile
        render json: current_user,
               serializer: UserSerializer,
               include: ['organization']
      end
      
      def update_profile
        if current_user.update(profile_params)
          render json: current_user,
                 serializer: UserSerializer
        else
          render_error current_user.errors.full_messages
        end
      end
      
      private
      
      def set_user
        @user = User.find(params[:id])
      end
      
      def user_params
        params.require(:user).permit(
          :email,
          :password,
          :password_confirmation,
          :first_name,
          :last_name,
          :role,
          :status
        )
      end
      
      def profile_params
        params.require(:user).permit(
          :first_name,
          :last_name,
          :email,
          :password,
          :password_confirmation,
          :avatar
        )
      end
      
      def authorize_organization_access
        unless current_user.organization_id == @user&.organization_id
          render_error 'Unauthorized access', :forbidden
        end
      end
      
      def pagination_meta(object)
        {
          current_page: object.current_page,
          next_page: object.next_page,
          prev_page: object.prev_page,
          total_pages: object.total_pages,
          total_count: object.total_count
        }
      end
    end
  end
end