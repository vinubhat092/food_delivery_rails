require 'rails_helper'

describe 'Authenticate', type: :request do
    describe 'POST /login' do
        let (:user) {FactoryBot.create(:user,name:"test",email:"test@gmail.com",password:"pass",role:1)}
        it 'register the user' do
            post '/api/v1/login' ,params:{name:user.name,email:user.email,password:user.password,role:user.role}
            expect(response).to have_http_status(:created)
        end
    end
end



