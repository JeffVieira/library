class BorrowSerializer < ActiveModel::Serializer
	attributes :id, :due_date, :returned, :user_id, :book_id

	belongs_to :book, serializer: BookSerializer
end
