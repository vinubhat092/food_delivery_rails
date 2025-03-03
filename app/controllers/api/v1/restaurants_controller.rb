module Api
    module V1
        class RestaurantsController < ApplicationController
            include ActionController::HttpAuthentication::Token
            include TokenAuthentication
            before_action :set_restaurant, only: [:show, :update, :destroy]
            before_action :authenticate_request, only: [:create,:update,:destroy]

            def index
                if params[:menuitem_name].present?
                    puts "params[:menuitem_name]: #{params[:menuitem_name]}"
                    @restaurants = Restaurant.joins(:menuitems).where("menuitems.name ILIKE ?", "%#{params[:menuitem_name]}%").distinct
                    puts "restaurants: #{@restaurants.inspect}"
                else
                    @restaurants = Rails.cache.fetch('restaurants',expires_in:1.minutes) do
                        Restaurant.all.to_a
                    end
                end
                render json:@restaurants.as_json(include: :menuitems),status: :ok
            end

            def create
                @restaurant = Restaurant.new(restaurant_params)
                if params[:restaurant][:menuitem_ids].present?
                    @restaurant.menuitems = Menuitem.where(id: params[:restaurant][:menuitem_ids])
                end
                if @restaurant.save
                    Rails.cache.delete('restaurants')
                    render json:@restaurant.as_json(include: :menuitems),status: :created
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
                if @restaurant.update(restaurant_params.except(:menuitem_ids))
                    if params[:restaurant][:menuitem_ids].present?
                        @restaurant.menuitems = Menuitem.where(id: params[:restaurant][:menuitem_ids])
                    end
                    Rails.cache.delete("restaurant_#{params[:id]}")
                    Rails.cache.delete('restaurants')
                    render json:@restaurant,status: :created
                else
                    render json:@restaurant.errors,status: :unprocessable_entity
                end
            end

            def destroy
                @restaurant.destroy!
                Rails.cache.delete("restaurant_#{params[:id]}")
                Rails.cache.delete('restaurants')
                head :no_content
            rescue ActiveRecord::RecordNotFound
            end

            def search
                restaurants = Restaurant.where(menuitems:{name:params[:name]})
                render json:restaurants,status: :ok
            end

            private

            def set_restaurant
                @restaurant = Restaurant.find(params.expect(:id))
            rescue ActiveRecord::RecordNotFound
                render json:{error: "Restaurant not found"},status: :not_found
            end

            def restaurant_params
                params.require(:restaurant).permit([:name,:address,:description,:email,:phone,:profile_photo,:user_id,:menuitem_ids])
            end

            def allowed_roles
                ['admin']
            end
        end
    end
end


            

            