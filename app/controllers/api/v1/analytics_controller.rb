module Api
    module V1
      class AnalyticsController < ApplicationController
        before_action :set_restaurant, except: [:order_stats]
  
        def order_stats
          if params[:restaurant_id].present?
            analytics = MongoAnalyticsService.new(params[:restaurant_id].to_i)
            
            most_ordered = analytics.most_ordered_items.map do |item|
              {
                menuitem_id: item['_id']['menuitem_id'],
                name: item['_id']['name'],
                total_orders: item['total_orders']
              }
            end

            categories = analytics.category_analytics.map do |cat|
              {
                category: cat['_id'],
                total_orders: cat['total_orders']
              }
            end

            render json: {
              most_ordered_items: most_ordered,
              category_analytics: categories
            }, status: :ok
          else
            render json: { error: 'Restaurant ID is required' }, status: :bad_request
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