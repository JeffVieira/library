require 'rails_helper'

RSpec.describe Api::V1::DashboardsController, type: :request do
	describe "GET index" do
		context 'when user is authenticated' do
			let(:headers) { authorization_header() }
			let(:overdue_user) { FactoryBot.create(:user) }

			it "returns payload for admin user" do
				book = FactoryBot.create(:book, copies_available: 1)
				FactoryBot.create(:borrow, book: book, borrow_date: 50.days.ago, returned: true)
				FactoryBot.create(:borrow, book: book, borrow_date: 10.days.ago, returned: true)

				other_book = FactoryBot.create(:book, copies_available: 2)
				FactoryBot.create(:borrow, book: other_book, borrow_date: 10.days.ago, returned: true)
				FactoryBot.create(:borrow, book: other_book, borrow_date: 10.days.ago, returned: false)
				FactoryBot.create(:borrow, book: other_book, borrow_date: 11.days.ago, returned: false)

				overdue_book= FactoryBot.create(:book, copies_available: 1)
				FactoryBot.create(:borrow, user: overdue_user, book: overdue_book, borrow_date: 15.days.ago, returned: false)

				due_today_book= FactoryBot.create(:book, copies_available: 1)
				FactoryBot.create(:borrow, user: overdue_user, book: due_today_book, borrow_date: 14.days.ago, returned: false)

				get api_v1_dashboards_path, headers: headers

				expect(response).to have_http_status(:ok)
				expect(JSON.parse(response.body)).to have_key("books")
				expect(JSON.parse(response.body)).to have_key("books_count")
				expect(JSON.parse(response.body)).to have_key("books_borrowed_count")
				expect(JSON.parse(response.body)).to have_key("books_due_today")
				expect(JSON.parse(response.body)).to have_key("users_with_overdue")
				expect(JSON.parse(response.body)["books"][0]["id"]).to eq(book.id)
				expect(JSON.parse(response.body)["books"][1]["id"]).to eq(other_book.id)
				expect(JSON.parse(response.body)["books"][2]["id"]).to eq(overdue_book.id)
				expect(JSON.parse(response.body)["books"][3]["id"]).to eq(due_today_book.id)
				expect(JSON.parse(response.body)["books_count"]).to eq(4)
				expect(JSON.parse(response.body)["books_borrowed_count"]).to eq(4)
				expect(JSON.parse(response.body)["books_due_today"].count).to eq(1)
				expect(JSON.parse(response.body)["users_with_overdue"].count).to eq(1)
				expect(JSON.parse(response.body)["users_with_overdue"][0]["id"]).to eq(overdue_user.id)
			end

			it "returns payload for member user" do
				user = FactoryBot.create(:user, role: 'member')
				book = FactoryBot.create(:book, copies_available: 1)
				FactoryBot.create(:borrow, user: user, book: book, borrow_date: 10.days.ago, returned: false)

				get api_v1_dashboards_path, headers: authorization_header(user)

				expect(response).to have_http_status(:ok)
				expect(JSON.parse(response.body)).to have_key("books_borrowed")
				expect(JSON.parse(response.body)).to have_key("books_overdue")
				expect(JSON.parse(response.body)["books_borrowed"].count).to eq(1)
				expect(JSON.parse(response.body)["books_overdue"].count).to eq(0)
			end
		end

		context 'when user is not authenticated' do
			it "returns unauthorized" do
				get api_v1_dashboards_path

				expect(response).to have_http_status(:unauthorized)
			end
		end
	end
end
