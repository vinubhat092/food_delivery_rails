class AuthenticationTokenService
    HMAC_SECRET = 'my$ecretK3y'
    ALGORITHM_TYPE = 'HS256'
    def self.encode_token(user_id,role)
        payload ={user_id:user_id,role:role}
        JWT.encode(payload, HMAC_SECRET, ALGORITHM_TYPE)
    end

    def self.decode_token(token)
        decoded_token = JWT.decode(token,HMAC_SECRET,true,algorithm:ALGORITHM_TYPE)
        {user_id:decoded_token[0]['user_id'],role:decoded_token[0]['role']}
    rescue JWT::DecodeError
        nil
    end
end

