require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # Assuming you have a fixture or a factory for users
    @valid_attributes = { name: "John Doe", email: "john.doe@example.com", password: "password", image: "image_url" }
    @invalid_attributes = { name: "", email: "invalid_email", password: "short", image: "image_url" }
  end

  test "should create user with valid attributes" do
    assert_difference("User.count", 1) do
      post "/users", params: { user: @valid_attributes }, as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert json_response.key?("custom_user_parameters")
  end

  test "should not create user with invalid attributes" do
    assert_no_difference("User.count") do
      post "/users", params: { user: @invalid_attributes }, as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response.key?("errors")
  end

  test "should get current user (me)" do
    # Simulate authentication
    @request.headers["Authorization"] = "Bearer #{encode_token(user_id: @user.id)}"

    get "/users/me", as: :json

    assert_response :ok
    json_response = JSON.parse(response.body)
    assert json_response.key?("custom_user_parameters")
  end

  private

  # Helper method to encode token (use the same secret as in your ApplicationController)
  def encode_token(payload)
    JWT.encode(payload, "blogwebops")
  end
end
