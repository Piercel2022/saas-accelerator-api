module Api
  module V1
    class NotificationsController < BaseController
      before_action :set_notification, only: [:show, :update, :destroy]
      
      def index
        @notifications = current_user.notifications
                                   .order(created_at: :desc)
                                   .page(params[:page])
                                   .per(20)
        
        render json: @notifications,
               each_serializer: NotificationSerializer,
               meta: pagination_meta(@notifications)
      end
      
      def show
        render json: @notification,
               serializer: NotificationSerializer
      end
      
      def update
        if @notification.update(notification_params)
          if params[:mark_as_read].present?
            @notification.update(read_at: Time.current)
          end
          
          render json: @notification,
                 serializer: NotificationSerializer
        else
          render_error @notification.errors.full_messages
        end
      end
      
      def mark_all_read
        current_user.notifications
                   .unread
                   .update_all(read_at: Time.current)
        
        head :no_content
      end
      
      def destroy
        @notification.destroy
        head :no_content
      end
      
      private
      
      def set_notification
        @notification = current_user.notifications.find(params[:id])
      end
      
      def notification_params
        params.require(:notification).permit(:status)
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
