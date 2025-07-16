require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) { FactoryBot.build(:user) }

	context 'validations' do
		it 'is valid with valid attributes' do
			expect(user).to be_valid
		end

		it 'is not valid without an email' do
			user.email = nil
			expect(user).not_to be_valid
		end

		it 'is not valid with a duplicate email' do
			FactoryBot.create(:user, email: user.email)
			expect(user).not_to be_valid
		end

		it 'is not valid without a password' do
			user.password = nil
			expect(user).not_to be_valid
		end

		it 'is not valid if password confirmation does not match' do
			user.password_confirmation = 'different_password'
			expect(user).not_to be_valid
		end
	end

	context 'scopes' do
		describe 'with_overdue_books' do
			let(:user) { FactoryBot.create(:user) }
			let(:book) { FactoryBot.create(:book, copies_available: 1) }

			it 'returns users with overdue books' do
				FactoryBot.create(:borrow, user: user, book: book, borrow_date: 15.days.ago, returned: false)

				expect(User.with_overdue_books).to include(user)
			end

			it 'does not return users without overdue books' do
				FactoryBot.create(:borrow, user: user, book: book, borrow_date: 5.days.ago, returned: false)

				expect(User.with_overdue_books).not_to include(user)
			end
		end
	end
end
