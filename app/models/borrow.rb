class Borrow < ApplicationRecord
	belongs_to :user
	belongs_to :book

	validates :user, presence: true, uniqueness: { scope: :book, message: "can only borrow the book one time" }
	validates :book, presence: true
	validates :borrow_date, presence: true
	validates :returned, inclusion: { in: [true, false] }

	validate :validate_book_availability

	before_validation :set_borrow_date, on: :create

	def validate_book_availability
		return if book.nil?

		if Borrow.where(book: book, returned: false).count === book.copies_available || book.copies_available <= 0
			errors.add(:book, "is not available for borrowing")
		end
	end

	private

		def set_borrow_date
			self.borrow_date ||= Time.current
		end
end
