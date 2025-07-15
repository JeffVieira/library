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
end
