module Api
    module V1
        class OrdersController < ApplicationController
            include TokenAuthentication
            before_action :authenticate_request, only:[:create]
            before_action :current_user, only:[:index]


            def index
                @orders = Order.where(user_id:current_user.id)
                render json: @orders, status: :ok
            end

            def create
                @cart = current_user.cart
                puts "cart: #{@cart.inspect}"
                puts "current_user: #{current_user.inspect}"
                if @cart.present? && @cart.cartitems.any?
                    @order = Order.new(user_id:current_user.id,restaurant_id:@cart.restaurant_id)
                    @cart.cartitems.each do |item|
                        @order.orderitems.find_or_initialize_by(menuitem_id:item.menuitem_id,quantity:item.quantity)
                    end

                    if @order.save
                        @cart.cartitems.destroy_all
                        render json: @order.as_json(include: :orderitems), status: :created
                    else
                        render json: @order.errors, status: :unprocessable_entity
                    end
                else
                    render json: {error: 'cart is empty or does not exist'}, status: :unprocessable_entity
                end
            end

            
            private

            def current_user
                token,_options = token_and_options(request)
                unless token.present?
                    render json: {error: 'No token provided'}, status: :unauthorized
                    return
                end
                @current_user = User.find_by(id:AuthenticationTokenService.decode_token(token)[:user_id])
            end

            def order_params
                params.require(:order).permit(:user_id,:restaurant_id)
            end

            def allowed_roles
                ['foodie']
            end
        end
    end
end