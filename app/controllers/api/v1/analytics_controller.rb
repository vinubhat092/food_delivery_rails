module Api
    module V1
      class AnalyticsController < ApplicationController
        before_action :set_restaurant, except: [:order_stats]
  
        def order_stats
          if params[:restaurant_id].present?
            restaurant = Restaurant.find(params[:restaurant_id])
  
            most_ordered_items = restaurant.menuitems
              .joins(:orderitems)
              .group("menuitems.id, menuitems.name")
              .order("COUNT(orderitems.id) DESC")
              .limit(5)
              .pluck("menuitems.name, COUNT(orderitems.id)")
  
            most_ordered_category = restaurant.menuitems
              .joins(:orderitems)
              .group("menuitems.category")
              .select("menuitems.category, COUNT(orderitems.id) as order_count")
              .limit(5)
  
            render json: {
              most_ordered_items: most_ordered_items,
              most_ordered_category: most_ordered_category,
            }, status: :ok
          else
            most_ordered_restaurant = Order.joins(:restaurant)
              .group("restaurants.id, restaurants.name")
              .order("COUNT(orders.id) DESC")
              .select("restaurants.name, COUNT(orders.id) as order_count")
              .limit(2)
  
            render json: {
              most_ordered_restaurant: most_ordered_restaurant
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