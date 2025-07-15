module AuthenticationHelper
	def authorization_header(user = FactoryBot.create(:user))
		{ "Authorization" => "Bearer #{login_user(user).last}" }
	end

	def login_user(user = FactoryBot.create(:user))
		post(api_v1_sign_in_path, params: { email: user.email, password: user.password })

		[ user, response.headers["X-Session-Token"] ]
	end
end
