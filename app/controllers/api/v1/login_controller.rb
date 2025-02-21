module Api
    module V1
        class LoginController < ApplicationController
            def create
                if user&.authenticate(params[:password])
                    token = AuthenticationTokenService.encode_token(user.id,user.role)
                    render json:{token:token},status: :created
                else
                    render json:{error:"Invalid email or password"},status: :unauthorized
                end
            end

            private

            def user
                @user ||=User.find_by(email:params[:email])
            end

            def user_params
                params.require(:user).permit(:email,:password)
            end
            
        end
    end
end