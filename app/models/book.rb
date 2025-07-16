class Book < ApplicationRecord
	has_many :borrows, dependent: :destroy
	has_many :users, through: :borrows

	validates :isbn, presence: true, uniqueness: true
	validates :title, presence: true, uniqueness: true, length: { minimum: 3 }
	validates :author, presence: true, length: { minimum: 3 }
	validates :copies_available, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
	validates :genre, presence: true, length: { minimum: 3 }
end
