require 'rails_helper'


describe "Restaurant" do
    let (:user) {FactoryBot.create(:user,name:"test2",email:"test2@gmail.com",password:"pass",role:0)}
    let (:menuitem) {FactoryBot.create(:menuitem, name: "dosa",description: "crispy dosa",category: 1)}
    
    describe "post /restaurant", type: :request do
        it "create a restaurant" do
            token = AuthenticationTokenService.encode_token(user.id,user.role)
            post '/api/v1/restaurants', params: {
                restaurant: {
                    user_id: user.id,
                    name: "dominose",
                    email: "dominose@example.com",
                    phone: "9090909090",
                    description: "veg & nonveg restaurant",
                    address: "banglore",
                    menuitem_ids: [menuitem.id]
                }
            }, headers: {"Authorization" => "Bearer #{token}"}
            expect(response).to have_http_status(:created)
            expect(User.count).to eq(1)
        end

        it "get all restaurants" do
            get '/api/v1/restaurants'
            expect(response).to have_http_status(:ok)
        end

        
    end
end

        
