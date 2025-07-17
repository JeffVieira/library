class MemberDashboardSerializer < ActiveModel::Serializer
	attributes :borrowed_books, :overdue_books

	def borrowed_books
		borrows = object.borrows.borrowed.includes(:book)
		ActiveModelSerializers::SerializableResource.new(borrows, each_serializer: BorrowSerializer, fields: [:due_date])
	end

	def overdue_books
		borrows = object.borrows.overdue.includes(:book)
		ActiveModelSerializers::SerializableResource.new(borrows, each_serializer: BorrowSerializer, fields: [:due_date])
	end
end
