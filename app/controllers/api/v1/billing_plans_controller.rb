module Api
  module V1
    class BillingPlansController < BaseController
      before_action :set_billing_plan, only: [:show, :update, :destroy]
      
      def index
        @billing_plans = BillingPlan.includes(:features)
                                  .where(status: 'active')
                                  .order(price: :asc)
        
        render json: @billing_plans,
               each_serializer: BillingPlanSerializer,
               include: ['features']
      end
      
      def show
        render json: @billing_plan,
               serializer: BillingPlanSerializer,
               include: ['features']
      end
      
      def create
        authorize! :create, BillingPlan
        @billing_plan = BillingPlan.new(billing_plan_params)
        
        if @billing_plan.save
          render json: @billing_plan,
                 serializer: BillingPlanSerializer,
                 status: :created
        else
          render_error @billing_plan.errors.full_messages
        end
      end
      
      def update
        authorize! :update, @billing_plan
        
        if @billing_plan.update(billing_plan_params)
          render json: @billing_plan,
                 serializer: BillingPlanSerializer
        else
          render_error @billing_plan.errors.full_messages
        end
      end
      
      def destroy
        authorize! :destroy, @billing_plan
        @billing_plan.update(status: 'archived')
        head :no_content
      end
      
      private
      
      def set_billing_plan
        @billing_plan = BillingPlan.find(params[:id])
      end
      
      def billing_plan_params
        params.require(:billing_plan).permit(
          :name, :price, :interval, :status,
          feature_ids: [],
          features_attributes: [:id, :value]
        )
      end
    end
  end
end