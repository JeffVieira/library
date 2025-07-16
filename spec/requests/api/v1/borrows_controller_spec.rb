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
end
