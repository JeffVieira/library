module Api::V1
	class SessionsController < ApplicationController
		skip_before_action :authenticate, only: :create

		def create
			if user = User.authenticate_by(email: params[:email], password: params[:password])
				@session = user.sessions.create!
				response.set_header "X-Session-Token", @session.signed_id

				render json: @session, status: :created
			else
				render json: { error: "That email or password is incorrect" }, status: :unauthorized
			end
		end

		def destroy
			# ver aqui para ver se é necessário o reset do pundit
			pundit_reset!
			Current.session.destroy

			render json: { message: "Logout successful." }, status: :ok
		end
	end
end
