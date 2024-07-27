require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post, user: user) }
  let(:valid_attributes) { { comment: "Sample Comment" } }
  let(:invalid_attributes) { { comment: "" } }
  let(:comment) { FactoryBot.create(:comment, user: user, post: post) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    @request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, params: { post_id: post.id, comment: valid_attributes }
        }.to change(Comment, :count).by(1)
      end

      it "renders a JSON response with the new comment" do
        post :create, params: { post_id: post.id, comment: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include("application/json")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new comment" do
        post :create, params: { post_id: post.id, comment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { comment: "Updated Comment" } }

      it "updates the requested comment" do
        put :update, params: { post_id: post.id, id: comment.id, comment: new_attributes }
        comment.reload
        expect(comment.comment).to eq("Updated Comment")
      end

      it "renders a JSON response with the comment" do
        put :update, params: { post_id: post.id, id: comment.id, comment: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include("application/json")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the comment" do
        put :update, params: { post_id: post.id, id: comment.id, comment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include("application/json")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested comment" do
      comment_to_delete = FactoryBot.create(:comment, user: user, post: post)
      expect {
        delete :destroy, params: { post_id: post.id, id: comment_to_delete.id }
      }.to change(Comment, :count).by(-1)
    end

    it "returns no content status" do
      delete :destroy, params: { post_id: post.id, id: comment.id }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "Authorization" do
    let(:other_user) { FactoryBot.create(:user) }
    let(:other_comment) { FactoryBot.create(:comment, user: other_user, post: post) }

    it "prevents unauthorized user from updating the comment" do
      put :update, params: { post_id: post.id, id: other_comment.id, comment: valid_attributes }
      expect(response).to have_http_status(:forbidden)
    end

    it "prevents unauthorized user from destroying the comment" do
      delete :destroy, params: { post_id: post.id, id: other_comment.id }
      expect(response).to have_http_status(:forbidden)
    end
  end
end
