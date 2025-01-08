module Api
  module V1
    class SubscriptionsController < BaseController
      before_action :set_subscription, only: [:show, :update, :cancel]
      before_action :authorize_organization_access
      
      def index
        @subscriptions = current_user.organization.subscriptions
                                   .includes(:billing_plan)
                                   .order(created_at: :desc)
        
        render json: @subscriptions,
               each_serializer: SubscriptionSerializer,
               include: ['billing_plan']
      end
      
      def show
        render json: @subscription,
               serializer: SubscriptionSerializer,
               include: ['billing_plan']
      end
      
      def create
        @subscription = current_user.organization.subscriptions.build(subscription_params)
        
        ActiveRecord::Base.transaction do
          if @subscription.save
            # Initialize payment with payment processor
            payment_result = PaymentService.new(@subscription).process_payment
            
            if payment_result.success?
              SubscriptionMailer.confirmation(@subscription).deliver_later
              render json: @subscription,
                     serializer: SubscriptionSerializer,
                     status: :created
            else
              raise ActiveRecord::Rollback
              render_error payment_result.error_message
            end
          else
            render_error @subscription.errors.full_messages
          end
        end
      end
      
      def update
        if @subscription.update(subscription_params)
          # Handle plan changes if necessary
          if subscription_params[:billing_plan_id].present?
            SubscriptionService.new(@subscription).handle_plan_change
          end
          
          render json: @subscription,
                 serializer: SubscriptionSerializer
        else
          render_error @subscription.errors.full_messages
        end
      end
      
      def cancel
        cancellation_service = SubscriptionCancellationService.new(@subscription)
        result = cancellation_service.process
        
        if result.success?
          render json: @subscription,
                 serializer: SubscriptionSerializer
        else
          render_error result.error_message
        end
      end
      
      private
      
      def set_subscription
        @subscription = Subscription.find(params[:id])
      end
      
      def subscription_params
        params.require(:subscription).permit(
          :billing_plan_id,
          :start_date,
          :payment_method_id
        )
      end
      
      def authorize_organization_access
        unless current_user.organization_id == @subscription&.organization_id
          render_error 'Unauthorized access', :forbidden
        end
      end
    end
  end
end
