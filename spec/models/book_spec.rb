require 'rails_helper'

RSpec.describe Book, type: :model do
	let(:book) { FactoryBot.build(:book) }

	context 'Should validate' do
		it 'with name, description, book type and size present' do
			expect(book).to be_valid
		end
	end

	context 'Should not be valid' do
		it 'when isbn is not present' do
			book.isbn = nil
			expect(book).not_to be_valid
		end

		it 'when title is not present' do
			book.title = nil
			expect(book).not_to be_valid
		end

		it 'when author is not present' do
			book.author = nil
			expect(book).not_to be_valid
		end

		it 'when genre is not present' do
			book.genre = nil
			expect(book).not_to be_valid
		end

		it 'when copies_available is last than zero' do
			book.copies_available = -1
			expect(book).not_to be_valid
		end

		it 'when title is not unique' do
			FactoryBot.create(:book, title: book.title)
			expect(book).not_to be_valid
		end

		it 'when isbn is not unique' do
			FactoryBot.create(:book, isbn: book.isbn)
			expect(book).not_to be_valid
		end

		it 'when author is less than 3 characters' do
			book.author = 'ab'
			expect(book).not_to be_valid
		end

		it 'when title is less than 3 characters' do
			book.title = 'ab'
			expect(book).not_to be_valid
		end

		it 'when genre is less than 3 characters' do
			book.genre = 'ab'
			expect(book).not_to be_valid
		end
	end

	context 'Scopes' do
		let!(:book1) { FactoryBot.create(:book, title: 'Book One', author: 'Author A', genre: 'Genre A', copies_available: 2) }
		let!(:book2) { FactoryBot.create(:book, title: 'Book Two', author: 'Author B', genre: 'Genre B') }
		let!(:book3) { FactoryBot.create(:book, title: 'Book Three', author: 'Author C', genre: 'Genre C') }

		it 'returns all books when no query is provided' do
			expect(Book.search(nil)).to match_array([book1, book2, book3])
		end

		it 'searches by title' do
			expect(Book.search('Book One')).to include(book1)
			expect(Book.search('Book One')).not_to include(book2, book3)
		end

		it 'searches by author' do
			expect(Book.search('Author A')).to include(book1)
			expect(Book.search('Author A')).not_to include(book2, book3)
		end

		it 'searches by genre' do
			expect(Book.search('Genre A')).to include(book1)
			expect(Book.search('Genre A')).not_to include(book2, book3)
		end

		it 'returns books due today' do
			FactoryBot.create(:borrow, book: book1, borrow_date: Date.current - 14.days)
			FactoryBot.create(:borrow, book: book2, borrow_date: Date.current - 13.days)
			FactoryBot.create(:borrow, book: book3, borrow_date: Date.current)

			expect(Book.due_today).to include(book1)
			expect(Book.due_today).not_to include(book2, book3)
		end

		it 'returns borrowed books' do
			FactoryBot.create(:borrow, book: book1, returned: false)
			FactoryBot.create(:borrow, book: book1, returned: false)
			FactoryBot.create(:borrow, book: book2, returned: true)

			expect(Book.borrowed.length).to eq(2)
			expect(Book.borrowed).to include(book1)
			expect(Book.borrowed).not_to include(book2)
		end

		it 'returns overdue books' do
			FactoryBot.create(:borrow, book: book1, borrow_date: Date.current - 15.days, returned: false)
			FactoryBot.create(:borrow, book: book2, borrow_date: Date.current - 10.days, returned: false)

			expect(Book.overdue).to include(book1)
			expect(Book.overdue).not_to include(book2)
		end
	end
end
