module Api
    module V1
      class AnalyticsController < ApplicationController
        before_action :set_restaurant, except: [:order_stats]
  
        def order_stats
          if params[:restaurant_id].present?
            restaurant = Restaurant.find(params[:restaurant_id])
            analytics = RestaurantAnalyticsService.new(restaurant)

            render json: {
              most_ordered_items: analytics.most_ordered_items,
              most_ordered_category: analytics.most_ordered_category,
            }, status: :ok
          else
            analytics = GeneralAnalyticsService.new
            render json: {
              most_ordered_restaurant: analytics.most_ordered_restaurant,
              most_ordered_user: analytics.most_ordered_user
            }, status: :ok
          end
        end
  
        private
  
        def set_restaurant
          @restaurant = Restaurant.find(params[:restaurant_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Restaurant not found' }, status: :not_found
        end
      end
    end
  end