module Api
    module V1
        class CartsController < ApplicationController
            include ActionController::HttpAuthentication::Token
            include TokenAuthentication
            before_action :authenticate_request,only:[:create,:update,:destroy]

            def index
                @cart = current_user.cart
                render json:@cart.as_json(include: :cartitems),status: :ok
            end

            def create
                @cart = current_user.cart
                unless @cart
                    @cart = current_user.create_cart(restaurant_id:params[:cart][:restaurant_id])
                end
                cart_items_attributes = cart_params[:cartitems_attributes]
                cart_items_attributes.each do |item_attr|
                    cart_item = @cart.cartitems.find_or_initialize_by(menuitem_id: item_attr[:menuitem_id])
                    cart_item.quantity = item_attr[:quantity]
                    cart_item.save
                end
                @cart.user_id = current_user.id
                if @cart.save
                    render json:@cart.as_json(include: :cartitems),status: :created
                else
                    render json:@cart.errors,status: :unprocessable_entity
                end
            end

            def update
                @cart = Cart.find(params[:id])
                if @cart.update(cart_params)
                    render json:@cart,status: :ok
                else
                    render json:@cart.errors,status: :unprocessable_entity
                end
            end

            def destroy
                @cart = Cart.find(params[:id])
                @cart.destroy
                head :no_content
            end

            private

            def current_user
                token,_options = token_and_options(request)
                @current_user = User.find_by(id:AuthenticationTokenService.decode_token(token)[:user_id])
            end

            def cart_params
                params.require(:cart).permit(:user_id,:restaurant_id,:cartitems_attributes=>[:menuitem_id, :quantity])
            end

            def allowed_roles
                ['foodie']
            end
            
        end
    end
end