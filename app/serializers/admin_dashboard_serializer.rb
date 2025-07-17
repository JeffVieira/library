class AdminDashboardSerializer < ActiveModel::Serializer
	attributes :total_books, :total_borrowed_books, :books_due_today, :users_with_overdue

	def total_books
		Book.count
	end

	def total_borrowed_books
		Book.borrowed.count
	end

	def books_due_today
		ActiveModelSerializers::SerializableResource.new(
			Book.due_today,
			each_serializer: BookSerializer,
			include_today_borrows: true
		)
	end

	def users_with_overdue
		ActiveModelSerializers::SerializableResource.new(
			User.with_overdue_books,
			each_serializer: UserSerializer,
		)
	end
end
