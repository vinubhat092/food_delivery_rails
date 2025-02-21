module Api
    module V1
        class RestaurantsController < ApplicationController
            include ActionController::HttpAuthentication::Token
            include TokenAuthentication
            before_action :set_restaurant, only: [:show, :update, :destroy]
            before_action :authenticate_request, only: [:create,:update,:destroy]

            def index
                @restaurants = Rails.cache.fetch('restaurants',expires_in:1.minutes) do
                    Restaurant.all.to_a
                end
                render json:@restaurants,status: :ok
            end

            def create
                @restaurant = Restaurant.new(restaurant_params)
                if @restaurant.save
                    Rails.cache.delete('restaurants')
                    render json:@restaurant,status: :created
                else
                    render json:@restaurant.errors,status: :unprocessable_entity
                end
            end

            def show
                @restaurant = Rails.cache.fetch("restaurant_#{params[:id]}",expires_in:1.minutes) do
                    Restaurant.find(params[:id])
                end
                render json:@restaurant,status: :ok
            rescue ActiveRecord::RecordNotFound
                render json:{error: "Restaurant not found"},status: :not_found
            end

            def update
                if @restaurant.update!(restaurant_params)
                    Rails.cache.delete("restaurant_#{params[:id]}")
                    Rails.cache.delete('restaurants')
                    render json:@restaurant,status: :ok
                else
                    render json:@restaurant.errors,status: :unprocessable_entity
                end
            end

            def destroy
                @restaurant.destroy!
                Rails.cache.delete("restaurant_#{params[:id]}")
                Rails.cache.delete('restaurants')
                head :no_content
            end

            private

            def set_restaurant
                @restaurant = Restaurant.find(params.expect(:id))
            rescue ActiveRecord::RecordNotFound
                render json:{error: "Restaurant not found"},status: :not_found
            end

            def restaurant_params
                params.require(:restaurant).permit([:name,:address,:description,:email,:phone,:profile_photo,:user_id])
            end

            def allowed_roles
                ['admin']
            end
        end
    end
end


            

            