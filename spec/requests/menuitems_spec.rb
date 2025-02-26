require 'rails_helper'

describe "MenuItems", type: :request do
    let (:user) {FactoryBot.create(:user,name:"test",email:"test@gmail.com",password:"pass",role:0)}

    it "create a menu item" do
        token = AuthenticationTokenService.encode_token(user.id,user.role)
        post '/api/v1/menuitems', params: {
            menuitem: {
                "name": "dosa",
                "description": "crispy dosa",
                "category": "main_course"
            }
        }, headers: {"Authorization" => "Bearer #{token}"}
        expect(response).to have_http_status(:created)
    end

    it "get all menu items" do
        get '/api/v1/menuitems'
        expect(response).to have_http_status(:ok)
    end
    
end
