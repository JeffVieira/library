class Book < ApplicationRecord
	has_many :borrows, dependent: :destroy
	has_many :users, through: :borrows

	validates :isbn, presence: true, uniqueness: true
	validates :title, presence: true, uniqueness: true, length: { minimum: 3 }
	validates :author, presence: true, length: { minimum: 3 }
	validates :copies_available, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
	validates :genre, presence: true, length: { minimum: 3 }

	scope :due_today, -> { joins(:borrows).where("DATE(borrows.borrow_date, '+#{Constants::OVERDUE_DAYS} days') = ?", Date.current) }

	scope :overdue, -> {
		joins(:borrows)
		.where("DATE(borrows.borrow_date, '+#{Constants::OVERDUE_DAYS} days') < ?", Date.current)
		.where("borrows.returned = ?", false)
	}

	scope :borrowed, -> {
		joins(:borrows)
		.where("borrows.returned = ?", false)
	}

	scope :search, ->(query) {
		if query.present?
			where("title LIKE ? OR author LIKE ? OR genre LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
		else
			all
		end
	}
end
