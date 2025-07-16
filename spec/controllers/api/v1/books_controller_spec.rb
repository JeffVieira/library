require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :request do
	describe "PATCH update" do
		let(:book) { FactoryBot.create(:book) }

		context 'when user is authenticated' do
			let(:headers) {  authorization_header() }

			it "update book successfully" do
				patch api_v1_book_path(book), params: {
					title: "new book",
					author: "Test Author",
					genre: "Test Genre",
					isbn: "1234567890",
					copies_available: 5
				}, headers: headers

				expect(response).to have_http_status(:ok)
				expect(JSON.parse(response.body)['title']).to eq("new book")
			end

			it "return unprocessable entity when params are invalid" do
				patch api_v1_book_path(book), params: {
					title: "",
					isbn: "",
					author: "",
					genre: ""
				}, headers: headers

				expect(response).to have_http_status(:unprocessable_entity)

				expect(JSON.parse(response.body)['title']).to eq(["can't be blank", "is too short (minimum is 3 characters)"])
				expect(JSON.parse(response.body)['isbn']).to eq(["can't be blank"])
				expect(JSON.parse(response.body)['author']).to eq(["can't be blank", "is too short (minimum is 3 characters)"])
				expect(JSON.parse(response.body)['genre']).to eq(["can't be blank", "is too short (minimum is 3 characters)"])
			end
		end

		context 'when user is not authenticated' do
			it "return unathorized" do
				patch api_v1_book_path(book), params: {
					title: "new book",
					author: "Test Author",
					genre: "Test Genre",
					isbn: "1234567890",
					copies_available: 5
				}

				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when user has not permission' do
			let(:user) { FactoryBot.create(:member_user) }
			let(:headers) {  authorization_header(user) }

			it "return unathorized" do
				patch api_v1_book_path(book), params: {
					title: "new book",
					author: "Test Author",
					genre: "Test Genre",
					isbn: "1234567890",
					copies_available: 5
				}, headers: headers

				expect(response).to have_http_status(:forbidden)
				expect(JSON.parse(response.body)['error']).to eq("You're not authorized!")
			end
		end
	end

	describe "POST create" do
		context 'when user is authenticated' do
			let(:headers) {  authorization_header() }
			it "create book successfully" do
				post api_v1_books_path, params: {
					title: "new book",
					author: "Test Author",
					genre: "Test Genre",
					isbn: "1234567890",
					copies_available: 5
				}, headers: headers

				expect(response).to have_http_status(:created)
				expect(JSON.parse(response.body)['title']).to eq("new book")
			end

			it "return unprocessable entity when params are invalid" do
				post api_v1_books_path, params: {}, headers: headers

				expect(response).to have_http_status(:unprocessable_entity)

				expect(JSON.parse(response.body)['title']).to eq(["can't be blank", "is too short (minimum is 3 characters)"])
				expect(JSON.parse(response.body)['isbn']).to eq(["can't be blank"])
				expect(JSON.parse(response.body)['author']).to eq(["can't be blank", "is too short (minimum is 3 characters)"])
				expect(JSON.parse(response.body)['genre']).to eq(["can't be blank", "is too short (minimum is 3 characters)"])
			end
		end

		context 'when user is not authenticated' do
			it "return unathorized" do
				post api_v1_books_path, params: {
					title: "new book",
					author: "Test Author",
					genre: "Test Genre",
					isbn: "1234567890",
					copies_available: 5
				}

				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when user has not permission' do
			let(:user) { FactoryBot.create(:member_user) }
			let(:headers) {  authorization_header(user) }

			it "return unathorized" do
				post api_v1_books_path, params: {
					title: "new book",
					author: "Test Author",
					genre: "Test Genre",
					isbn: "1234567890",
					copies_available: 5
				}, headers: headers

				expect(response).to have_http_status(:forbidden)
				expect(JSON.parse(response.body)['error']).to eq("You're not authorized!")
			end
		end
	end

	describe "DELETE destroy" do
		let(:book) { FactoryBot.create(:book) }

		context 'when user is authenticated' do
			let(:headers) {  authorization_header() }
			it "delete book successfully" do
				delete api_v1_book_path(book), headers: headers

				expect(response).to have_http_status(:no_content)
			end

			it "return not found entity when book does not exist" do
				delete api_v1_book_path(id: 9999), headers: headers

				expect(response).to have_http_status(:not_found)
			end
		end

		context 'when user is not authenticated' do
			it "return unathorized" do
				delete api_v1_book_path(book)

				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when user has not permission' do
			let(:user) { FactoryBot.create(:member_user) }
			let(:headers) {  authorization_header(user) }

			it "return unathorized" do
				delete api_v1_book_path(book), headers: headers

				expect(response).to have_http_status(:forbidden)
				expect(JSON.parse(response.body)['error']).to eq("You're not authorized!")
			end
		end
	end

	describe "GET index" do
		context 'when user is authenticated' do
			let(:headers) {  authorization_header() }

			it "returns a list of books" do
				book1 = FactoryBot.create(:book, title: "Book 1", author: "Author 1", genre: "Genre 1", isbn: "1234567890")
				book2 = FactoryBot.create(:book, title: "Book 2", author: "Author 2", genre: "Genre 2", isbn: "0987654321")

				get api_v1_books_path, headers: headers

				expect(response).to have_http_status(:ok)
				response_json = JSON.parse(response.body)

				expect(response_json.length).to eq(2)
				expect(response_json[0]['title']).to eq(book1.title)
				expect(response_json[1]['title']).to eq(book2.title)
			end

			it "returns an empty list when no books exist" do
				get api_v1_books_path, headers: headers

				expect(response).to have_http_status(:ok)
				response_json = JSON.parse(response.body)

				expect(response_json.length).to eq(0)
			end
		end

		context 'when user is not authenticated' do
			it "returns unauthorized" do
				get api_v1_books_path

				expect(response).to have_http_status(:unauthorized)
			end
		end
	end
end
