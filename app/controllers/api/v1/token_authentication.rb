module Api
    module V1   
        module TokenAuthentication
            include ActionController::HttpAuthentication::Token
            extend ActiveSupport::Concern
            included do
                before_action :authenticate_request, only: [:create, :update, :destroy]
            end
            private

            def authenticate_request
                if request.headers['Authorization'].present?
                    token,_options = token_and_options(request) 
                    unless token
                        render json:{error: "No token provided"},status: :unauthorized
                    end
                    begin
                        decoded_token = AuthenticationTokenService.decode_token(token)
                        role = decoded_token[:role]
                        unless allowed_roles.include?(role)
                            render json:{error: "Unauthorized"},status: :unauthorized
                        end
                        @current_user = User.find(decoded_token[:user_id])
                    rescue ActiveRecord::RecordNotFound
                        render json:{error: "Invalid token"},status: :unauthorized
                    end
                else
                    render json:{error: "No token provided"},status: :unauthorized
                end
            end

            def allowed_roles
                ['admin']
            end
        end
    end
end
