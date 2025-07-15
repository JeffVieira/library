require "test_helper"

module Api::V1
  class RegistrationsControllerTest < ActionDispatch::IntegrationTest
    test "should sign up" do
      assert_difference("User.count") do
        post api_v1_sign_up_url, params: { email: "email-user@hey.com", password: "Secret1*3*5*", password_confirmation: "Secret1*3*5*" }
      end

      assert_response :created
    end

    test "should not sign up with invalid credentials" do
      post api_v1_sign_up_url, params: { email: "", password: "" }
      
      assert_response :unprocessable_entity
      assert_equal ["can't be blank", "is invalid"], response.parsed_body["email"]
      assert_equal ["can't be blank"], response.parsed_body["password"]
    end
  end
end