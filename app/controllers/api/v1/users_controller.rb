module Api::V1
	class UsersController < ApplicationController
		before_action :authenticate

		def index
			@users = User.all
			render json: @users, status: :ok
		end

		def show
			@user = User.find(params[:id])
			render json: @user, status: :ok
		end

		private

		def user_params
			params.require(:user).permit(:email, :password, :password_confirmation)
		end
	end
end