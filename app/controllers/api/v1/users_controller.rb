module Api    
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[ show edit update destroy ]

    # GET /users or /users.json
      def index
        @users = User.all
      end

      # PATCH/PUT /users/1 or /users/1.json
      def update
        if @user.update(user_params)
          render json:@user,status: :ok
        else
          render json:updated_user.errors,status: :unprocessable_entity
        end
      end

      # DELETE /users/1 or /users/1.json
      def destroy
        User.find(params[:id]).destroy!
        render head: :no_content
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params.expect(:id))
        end

        # Only allow a list of trusted parameters through.
        def user_params
          params.require(:user).permit(:email,:password,:name,:role,:profile_photo)
        end
      end
  end
end
