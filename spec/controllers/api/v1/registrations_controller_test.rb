require "rails_helper"

RSpec.describe Api::V1::RegistrationsController, type: :request do
	it "should sign up" do
		assert_difference("User.count") do
			post api_v1_sign_up_url, params: { email: "email-user@hey.com", password: "Secret1*3*5*", password_confirmation: "Secret1*3*5*" }
		end

		expect(response).to have_http_status(:created)
	end

	it "should not sign up with invalid credentials" do
		post api_v1_sign_up_url, params: { email: "", password: "" }

		expect(response).to have_http_status(:unprocessable_entity)
		expect(JSON.parse(response.body)['email']).to eq(["can't be blank", "is invalid"])
		expect(JSON.parse(response.body)['password']).to eq(["can't be blank"])
	end
end
