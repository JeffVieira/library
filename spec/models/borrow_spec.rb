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

	context 'Scope' do
		it 'returns borrows with returned false' do
			borrow1 = FactoryBot.create(:borrow, returned: false)
			borrow2 = FactoryBot.create(:borrow, returned: false)
			borrow3 = FactoryBot.create(:borrow, returned: true)

			expect(Borrow.borrowed.length).to eq(2)
			expect(Borrow.borrowed).to include(borrow1, borrow2)
			expect(Borrow.borrowed).not_to include(borrow3)
		end

		it 'returns borrows with due_date equals today' do
			borrow1 = FactoryBot.create(:borrow, returned: false, due_date: Date.today)
			borrow2 = FactoryBot.create(:borrow, returned: false, due_date: 5.days.ago)
			borrow3 = FactoryBot.create(:borrow, returned: true, due_date: Date.today)

			expect(Borrow.due_today.length).to eq(1)
			expect(Borrow.due_today).to include(borrow1)
			expect(Borrow.due_today).not_to include(borrow2, borrow3)
		end

		it 'returns overdues borrows' do
			borrow1 = FactoryBot.create(:borrow, returned: false, due_date: Date.today + 5.days)
			borrow2 = FactoryBot.create(:borrow, returned: false, due_date: 5.days.ago)
			borrow3 = FactoryBot.create(:borrow, returned: true, due_date: Date.today + 5.days)
			borrow4 = FactoryBot.create(:borrow, returned: true, due_date: 5.days.ago)

			expect(Borrow.overdue.length).to eq(1)
			expect(Borrow.overdue).to include(borrow2)
			expect(Borrow.overdue).not_to include(borrow1, borrow3, borrow4)
		end
	end
end
