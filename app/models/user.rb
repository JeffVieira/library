class User < ApplicationRecord
	enum :role, { admin: "admin", member: "member" }, suffix: false

	has_secure_password

	generates_token_for :password_reset, expires_in: 20.minutes do
		password_salt.last(10)
	end

	has_many :sessions, dependent: :destroy
	has_many :borrows, dependent: :destroy
	has_many :books, through: :borrows

	validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
	validates :password, allow_nil: true, length: { minimum: 12 }

	normalizes :email, with: -> { _1.strip.downcase }

	after_update if: :password_digest_previously_changed? do
		sessions.where.not(id: Current.session).delete_all
	end

	scope :with_overdue_books, -> {
		joins(:borrows)
		.where("borrows.due_date <= ?", Date.current)
		.where("borrows.returned = ?", false).distinct
	}
end
