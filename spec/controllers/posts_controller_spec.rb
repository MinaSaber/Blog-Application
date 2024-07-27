require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:valid_attributes) {
    { title: "Sample Post Title", body: "Sample Post Body", tags_attributes: [] }
  }

  let(:invalid_attributes) {
    { title: "", body: "Sample Post Body", tags_attributes: [] }
  }

  let(:post) { FactoryBot.create(:post, user: user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Post" do
        expect {
          post :create, params: { post: valid_attributes }
        }.to change(Post, :count).by(1)
      end

      it "renders a JSON response with the new post" do
        post :create, params: { post: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include("application/json")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new post" do
        post :create, params: { post: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")
      end
    end
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
      expect(response.content_type).to include("application/json")
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: post.to_param }
      expect(response).to be_successful
      expect(response.content_type).to include("application/json")
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { title: "Updated Post Title", body: "Updated Post Body" }
      }

      it "updates the requested post" do
        put :update, params: { id: post.to_param, post: new_attributes }
        post.reload
        expect(post.title).to eq("Updated Post Title")
        expect(post.body).to eq("Updated Post Body")
      end

      it "renders a JSON response with the post" do
        put :update, params: { id: post.to_param, post: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include("application/json")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the post" do
        put :update, params: { id: post.to_param, post: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested post" do
      post = FactoryBot.create(:post, user: user)
      expect {
        delete :destroy, params: { id: post.to_param }
      }.to change(Post, :count).by(-1)
    end
  end

  describe "Authorization" do
    let(:other_user) { FactoryBot.create(:user) }
    let(:other_post) { FactoryBot.create(:post, user: other_user) }

    it "prevents unauthorized user from updating the post" do
      put :update, params: { id: other_post.to_param, post: valid_attributes }
      expect(response).to have_http_status(:forbidden)
    end

    it "prevents unauthorized user from destroying the post" do
      delete :destroy, params: { id: other_post.to_param }
      expect(response).to have_http_status(:forbidden)
    end
  end
end
