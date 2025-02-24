module Api    
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:update, :destroy]

      def index
        @users = User.all
        render json:@users, status: :ok
      end

      def update
        if @user.update(user_params)
          render json:@user,status: :ok
        else
          render json:updated_user.errors,status: :unprocessable_entity
        end
      end

      def destroy
        User.find(params[:id]).destroy!
        render head: :no_content
      end

      def show
        render json: @user
      end

      private
        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(:email,:password,:name,:role,:profile_photo)
        end
      end
  end
end
