module Api
  module V1
    class FeaturesController < BaseController
      before_action :set_feature, only: [:show, :update, :destroy]
      
      def index
        @features = Feature.all
        render json: @features,
               each_serializer: FeatureSerializer
      end
      
      def show
        render json: @feature,
               serializer: FeatureSerializer
      end
      
      def create
        authorize! :create, Feature
        @feature = Feature.new(feature_params)
        
        if @feature.save
          render json: @feature,
                 serializer: FeatureSerializer,
                 status: :created
        else
          render_error @feature.errors.full_messages
        end
      end
      
      def update
        authorize! :update, @feature
        
        if @feature.update(feature_params)
          render json: @feature,
                 serializer: FeatureSerializer
        else
          render_error @feature.errors.full_messages
        end
      end
      
      def destroy
        authorize! :destroy, @feature
        @feature.update(status: 'archived')
        head :no_content
      end
      
      private
      
      def set_feature
        @feature = Feature.find(params[:id])
      end
      
      def feature_params
        params.require(:feature).permit(:name, :code, :description, :status)
      end
    end
  end
end
