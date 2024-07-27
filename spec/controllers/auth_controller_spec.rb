require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  let(:user) { FactoryBot.create(:user, password: 'password') }
  let(:valid_attributes) {
    { email: user.email, password: 'password' }
  }
  let(:invalid_password) {
    { email: user.email, password: 'wrongpassword' }
  }
  let(:nonexistent_user) {
    { email: 'nonexistent@example.com', password: 'password' }
  }

  describe "POST #login" do
    context "with valid credentials" do
      it "returns a JWT token" do
        post :login, params: { user: valid_attributes }
        expect(response).to have_http_status(:accepted)
        expect(response.content_type).to include("application/json")
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context "with invalid password" do
      it "returns an unauthorized status" do
        post :login, params: { user: invalid_password }
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to include("application/json")
        expect(JSON.parse(response.body)['message']).to eq('Incorrect password')
      end
    end

    context "with non-existent user" do
      it "returns an unauthorized status" do
        post :login, params: { user: nonexistent_user }
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to include("application/json")
        expect(JSON.parse(response.body)['message']).to eq("User doesn't exist")
      end
    end
  end
end
