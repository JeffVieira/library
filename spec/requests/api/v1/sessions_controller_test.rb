require "rails_helper"

RSpec.describe Api::V1::SessionsController, type: :request do
		let(:headers) {  authorization_header() }

		it "should sign in" do
			@user = FactoryBot.create(:user)

			post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }
			assert_response :created
		end

		it "should not sign in with wrong credentials" do
			post api_v1_sign_in_url, params: { email: "anymail@mail.com", password: "SecretWrong1*3" }
			assert_response :unauthorized
		end

		it "should sign out" do
			delete api_v1_sign_out_url, headers: headers
			assert_response :no_content
		end
	end
