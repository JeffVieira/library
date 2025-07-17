class BookSerializer < ActiveModel::Serializer
	attributes :id, :title, :author, :isbn, :copies_available, :genre

	attribute :borrowed_by, if: :include_today_borrows?

	def include_today_borrows?
		instance_options[:include_today_borrows]== true
	end

	def borrowed_by
		object.borrows.due_today.select(:id, :user_id, :due_date)
	end
end
