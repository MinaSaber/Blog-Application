require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) {
    { name: "username", email: "user@gmail.com", password: "password", image: "image_url" }
  }

  let(:invalid_attributes) {
    { name: "", email: "user@gmail.com", password: "password", image: "image_url" }
  }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include("application/json")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new user" do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")
      end
    end
  end

  describe "GET #me" do
    let(:user) { FactoryBot.create(:user) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    it "returns the current user" do
      get :me
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/json")
      expect(response.body).to eq(user.custom_user_parameters.to_json)
    end
  end
end
