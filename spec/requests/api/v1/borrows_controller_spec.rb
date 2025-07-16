require 'rails_helper'

RSpec.describe Api::V1::BorrowsController, type: :request do
	describe "POST /create" do
		context 'when user is authenticated' do
			let(:user) { FactoryBot.create(:user) }
			let(:book) { FactoryBot.create(:book, copies_available: 1) }
			let(:headers) { authorization_header(user) }

			it "creates a borrow successfully" do
				post api_v1_borrows_path, params: {
					user_id: user.id,
					book_id: book.id,
					borrow_date: Time.current
				}, headers: headers

				expect(response).to have_http_status(:created)
				expect(JSON.parse(response.body)['user_id']).to eq(user.id)
				expect(JSON.parse(response.body)['book_id']).to eq(book.id)
				expect(JSON.parse(response.body)['returned']).to eq(false)
				expect(JSON.parse(response.body)['borrow_date']).to be_present
			end

			it "returns unprocessable entity when params are invalid" do
				post api_v1_borrows_path, params: {
					user_id: nil,
					book_id: nil,
					borrow_date: Time.current
				}, headers: headers

				expect(response).to have_http_status(:unprocessable_entity)
				expect(JSON.parse(response.body)['user']).to include("must exist")
				expect(JSON.parse(response.body)['book']).to include("must exist")
			end
		end

		context 'when user is not authenticated' do
			it "returns unauthorized" do
				post api_v1_borrows_path, params: {
					user_id: 1,
					book_id: 1,
					borrow_date: Time.current
				}

				expect(response).to have_http_status(:unauthorized)
			end
		end
	end

	describe "PATCH /return_book" do
		context 'when user is authenticated' do
			let(:user) { FactoryBot.create(:user) }
			let(:book) { FactoryBot.create(:book, copies_available: 2) }
			let!(:borrow) { FactoryBot.create(:borrow, user: user, book: book, returned: false) }
			let(:headers) { authorization_header(user) }

			it "marks a borrow as returned successfully" do
				patch api_v1_return_book_path, params: {
					book_id: book.id,
					user_id: user.id
				}, headers: headers

				expect(response).to have_http_status(:ok)
				expect(JSON.parse(response.body)['returned']).to eq(true)
			end

			it "returns unprocessable entity when borrow is not found" do
				patch api_v1_return_book_path, params: {
					book_id: book.id,
					user_id: 9999 # Non-existent user
				}, headers: headers

				expect(response).to have_http_status(:not_found)
				expect(JSON.parse(response.body)['error']).to eq("Borrow record not found")
			end

			it "returns unprocessable entity when borrow is already returned" do
				borrow.update(returned: true)

				patch api_v1_return_book_path, params: {
					book_id: book.id,
					user_id: user.id
				}, headers: headers

				expect(response).to have_http_status(:unprocessable_entity)
				expect(JSON.parse(response.body)['error']).to eq("This book has already been returned")
			end
		end

		context 'when user is not authenticated' do
			it "returns unauthorized" do
				patch api_v1_return_book_path, params: {
					book_id: 1,
					user_id: 1
				}

				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when user has no permission' do
			let(:user) { FactoryBot.create(:member_user) }
			let(:book) { FactoryBot.create(:book, copies_available: 1) }
			let!(:borrow) { FactoryBot.create(:borrow, user: user, book: book, returned: false) }
			let(:headers) { authorization_header(user) }
			it "returns unauthorized" do
				patch api_v1_return_book_path, params: {
					book_id: book.id,
					user_id: user.id
				}, headers: headers

				expect(response).to have_http_status(:forbidden)
				expect(JSON.parse(response.body)['error']).to eq("You're not authorized!")
			end
		end
	end
end
