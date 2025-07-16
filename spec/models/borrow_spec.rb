require 'rails_helper'

RSpec.describe Borrow, type: :model do
	let(:borrow) { FactoryBot.build(:borrow) }

	context 'Should validate' do
		it 'with user, book, borrow_date present' do
			expect(borrow).to be_valid
		end
	end

	context 'Should not be valid' do
		it 'when user is not present' do
			borrow.user = nil
			expect(borrow).not_to be_valid
		end

		it 'when book is not present' do
			borrow.book = nil
			expect(borrow).not_to be_valid
		end

		it 'when returned is not a boolean' do
			borrow.returned = nil
			expect(borrow).not_to be_valid
		end
	end

	context 'Uniqueness validation' do
		let(:user) { FactoryBot.create(:user) }
		let(:book) { FactoryBot.create(:book) }

		it 'should not allow the same user to borrow the same book multiple times' do
			FactoryBot.create(:borrow, user: user, book: book)
			duplicate_borrow = FactoryBot.build(:borrow, user: user, book: book)
			expect(duplicate_borrow).not_to be_valid
			expect(duplicate_borrow.errors[:user]).to include("can only borrow the book one time")
		end
	end

	context 'Book availability validation' do
		let(:book) { FactoryBot.create(:book, copies_available: 1) }
		let(:user) { FactoryBot.create(:user) }

		it 'should not allow borrow book without available copies' do
			FactoryBot.create(:borrow, book: book, returned: false)
			borrow = FactoryBot.build(:borrow, user: user, book: book)

			expect(borrow).not_to be_valid
			expect(borrow.errors[:book]).to include("is not available for borrowing")
		end

		it 'should not allow borrow book with zero available copies' do
			book.copies_available = 0
			borrow = FactoryBot.build(:borrow, user: user, book: book)

			expect(borrow).not_to be_valid
			expect(borrow.errors[:book]).to include("is not available for borrowing")
		end

		it 'should allow borrowing if book is available' do
			FactoryBot.create(:borrow, book: book, returned: false)
			book.copies_available = 2
			borrow = FactoryBot.build(:borrow, user: user, book: book)

			expect(borrow).to be_valid
			expect(borrow.errors[:book]).to be_empty
		end
	end
end
