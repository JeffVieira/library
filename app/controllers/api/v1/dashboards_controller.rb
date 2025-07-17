module Api::V1
	class DashboardsController < ApplicationController
		before_action :authenticate

		def index
			if current_user.admin?
				render json: current_user, serializer: AdminDashboardSerializer, status: :ok
			else
				render json: current_user, serializer: MemberDashboardSerializer, status: :ok
			end
		end
	end
end
