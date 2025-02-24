module Api
    module V1
        class MenuitemsController < ApplicationController
            include TokenAuthentication
            before_action :set_menuitem,only:[:show,:update,:destroy]
            before_action :authenticate_request,only:[:create,:update,:destroy]
            def index
                @menuitems = Rails.cache.fetch('menuitems',expires_in:1.minutes) do
                    Menuitem.all.to_a
                end
                render json:@menuitems,status: :ok
            end

            def create
                @menuitem = Menuitem.new(menuitem_params)
                if @menuitem.save
                    Rails.cache.delete('menuitems')
                    render json:@menuitem,status: :created
                else
                    render json:@menuitem.errors,status: :unprocessable_entity
                end
            end

            def show
                @menuitem = Rails.cache.fetch("menuitem_#{params[:id]}",expires_in:1.minutes) do
                    Menuitem.find(params[:id])
                end
                render json:@menuitem,status: :ok
            rescue ActiveRecord::RecordNotFound
                render json:{error: "Menuitem not found"},status: :not_found
            end

            def update
                if @menuitem.update(menuitem_params)
                    Rails.cache.delete("menuitem_#{params[:id]}")
                    Rails.cache.delete('menuitems')
                    render json:@menuitem,status: :ok
                else
                    render json:@menuitem.errors,status: :unprocessable_entity
                end
            end

            def destroy
                @menuitem.destroy!
                Rails.cache.delete("menuitem_#{params[:id]}")
                Rails.cache.delete('menuitems')
                head :no_content
            end

            private

            def set_menuitem
                @menuitem = Menuitem.find(params[:id])
            rescue ActiveRecord::RecordNotFound
                render json:{error:"Menuitem not found"},status: :not_found
            end

            def menuitem_params
                params.require(:menuitem).permit([:name,:category,:description,:image])
            end

            def allowed_roles
                ['admin']
            end 
            
            
            
        end
    end
end