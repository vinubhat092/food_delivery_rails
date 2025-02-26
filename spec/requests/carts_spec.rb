require 'rails_helper'

describe "Carts", type: :request do
    let (:user) {FactoryBot.create(:user,name:"test",email:"test@gmail.com",password:"pass",role:0)}
    let (:user2) {FactoryBot.create(:user,name:"test2",email:"test2@gmail.com",password:"pass",role:1)}
    let (:restaurant) {FactoryBot.create(:restaurant,name:"dominose",email:"dominose@example.com",phone:"9090909090",description:"veg & nonveg restaurant",address:"banglore",user_id: user.id)}
    let (:menuitem) {FactoryBot.create(:menuitem,name:"dosa",description:"crispy dosa",category:1)}
    

    it "create a cart" do
        token = AuthenticationTokenService.encode_token(user2.id,user2.role)
        post '/api/v1/carts', params: {
            cart: {
                restaurant_id: restaurant.id,
                cartitems_attributes: [
                    {
                        menuitem_id: menuitem.id,
                        quantity: 1
                    }
                ]
            }
        }, headers: {"Authorization" => "Bearer #{token}"}
        expect(response).to have_http_status(:created)
    end

    it "get all carts" do
        token = AuthenticationTokenService.encode_token(user2.id,user2.role)
        get '/api/v1/carts', headers: {"Authorization" => "Bearer #{token}"}
        expect(response).to have_http_status(:ok)
    end
    
end