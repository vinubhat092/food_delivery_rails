module Api
    module V1
        class LogoutController < ApplicationController
            HMAC_SECRET = 'my$ecretK3y'
            ALGORITHM_TYPE = 'HS256'
            EXPIRATION_TIME = 24.hours.from_now.to_i
            def create
                token_info = extract_token_info
                @logout = BlacklistedToken.new(token: token_info[:token],expiry: token_info[:expires_at])
                if @logout.save
                    render json:@logout, status: :created
                else
                    render json:@logout.errors, status: :unprocessable_entity
                end
            end

            private

            def extract_token_info
                auth_header = request.headers['Authorization']
                return { token: nil, expires_at: nil } unless auth_header
                token = auth_header.split(' ').last
                begin
                decoded_token = JWT.decode(token,HMAC_SECRET,true,algorithm:ALGORITHM_TYPE).first
                {
                    token: token,
                    expires_at: Time.at(decoded_token['exp']).utc
                }
                rescue JWT::DecodeError => e
                { token: token, expires_at: 24.hours.from_now }
                end
            end
        end
    end
end


