module Api
    module V1
        class RegistrationController < ApplicationController
            def create
                @user = User.new(user_params)
                if @user.save
                    token = AuthenticationTokenService.encode_token(@user.id,@user.role)
                    render json:{token:token},status: :created
                else
                    render json:{error:@user.errors.full_messages},status: :unprocessable_entity
                end 
            end

            private
            def user_params
                params.require(:user).permit(:email,:password,:name,:role,:profile_photo)
            end
        end
    end
end

