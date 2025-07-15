class ApplicationController < ActionController::API
	include ActionController::HttpAuthentication::Token::ControllerMethods
	include Pundit::Authorization

	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	before_action :set_current_request_details
	before_action :authenticate

	private
		def authenticate
			if session_record = authenticate_with_http_token { |token, _| Session.find_signed(token) }
				Current.session = session_record
			else
				request_http_token_authentication
			end
		end

		def set_current_request_details
			Current.user_agent = request.user_agent
			Current.ip_address = request.ip
		end

		def user_not_authorized
			redirect_to root_path, alert: "You're not authorized!"
		end
end
