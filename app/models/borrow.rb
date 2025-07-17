class Borrow < ApplicationRecord
	belongs_to :user
	belongs_to :book

	validates :user, presence: true, uniqueness: { scope: :book, message: "can only borrow the book one time" }
	validates :book, presence: true
	validates :due_date, presence: true
	validates :returned, inclusion: { in: [true, false] }

	validate :validate_book_availability

	before_validation :set_due_date, on: :create


	scope :borrowed, -> { where(returned: false) }
	scope :due_today, -> { borrowed.where("DATE(borrows.due_date) = ?", Date.current) }
	scope :overdue, -> { borrowed.where("DATE(due_date) < ?", Date.today) }

	def validate_book_availability
		return if book.nil?

		if Borrow.where(book: book, returned: false).count === book.copies_available || book.copies_available <= 0
			errors.add(:book, "is not available for borrowing")
		end
	end

	private

		def set_due_date
			self.due_date ||= Time.current + Constants::BORROW_DURATION.days
		end
end
