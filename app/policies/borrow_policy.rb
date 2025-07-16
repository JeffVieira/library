class BorrowPolicy < ApplicationPolicy
	def create?
		true
	end

	def update?
		user.admin?
	end
end
