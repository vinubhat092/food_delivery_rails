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
                    token, _options = token_and_options(request) 
                    
                    unless token
                        render json: { error: "No token provided" }, status: :unauthorized
                        return
                    end

                    if BlacklistedToken.invalid?(token)
                        render json: { error: "Token has been invalidated" }, status: :unauthorized
                        return
                    end

                    begin
                        decoded_token = AuthenticationTokenService.decode_token(token)
                        
                        unless decoded_token
                            render json: { error: "Invalid or expired token" }, status: :unauthorized
                            return
                        end

                        role = decoded_token[:role]
                        unless allowed_roles.include?(role)
                            render json: { error: "Unauthorized role" }, status: :unauthorized
                            return
                        end

                        @current_user = User.find(decoded_token[:user_id])
                    rescue ActiveRecord::RecordNotFound
                        render json: { error: "User not found" }, status: :unauthorized
                    end
                else
                    render json: { error: "No token provided" }, status: :unauthorized
                end
            end

            def allowed_roles
                ['admin']
            end

            def current_user
                @current_user
            end
        end
    end
end
