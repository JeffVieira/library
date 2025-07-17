class UserSerializer < ActiveModel::Serializer
	attributes :id, :email, :overdue_books

	def overdue_books
		borrows = object.borrows.overdue.includes(:book)
		ActiveModelSerializers::SerializableResource.new(borrows, each_serializer: BorrowSerializer, fields: [:due_date])
	end
end
