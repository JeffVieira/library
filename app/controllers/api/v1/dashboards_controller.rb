module Api::V1
	class DashboardsController < ApplicationController
		before_action :authenticate

		def index
			if current_user.admin?
				render json: admin_dashboard_data, status: :ok
			else
				render json: member_dashboard_data, status: :ok
			end
		end

		private

			def admin_dashboard_data
				{
					books: Book.all,
					books_count: Book.count,
					books_borrowed_count: Book.borrowed.count,
					books_due_today: Book.due_today,
					users_with_overdue: User.with_overdue_books
				}
			end

			def member_dashboard_data
				{
					books_borrowed: current_user.books.borrowed,
					books_overdue: current_user.books.overdue
				}
			end
	end
end
