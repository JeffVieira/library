require "test_helper"

module Api::V1
	class BooksControllerTest < ActionDispatch::IntegrationTest
		setup do
			@user, @token = sign_in_as(users(:admin_user))
		end

		def default_headers
			{ "Authorization" => "Bearer #{@token}" }
		end

		test "should return an empty list" do
			get api_v1_books_url, headers: default_headers

			expect(response).to have_http_status(:ok)
			response_json = JSON.parse(response.body)
			expect(response_json["books"].length).to eq(0)
		end

		test "should list all books" do
			book1 = create(:book, title: "Book 1", author: "Author 1", genre: "genre 1", price: 100)
			book2 = create(:book, title: "Book 2", author: "Author 2", genre: "genre 2", price: 100)

			get api_v1_books_url, headers: default_headers

			expect(response).to have_http_status(:ok)
			response_json = JSON.parse(response.body)
			expect(response_json["books"].length).to eq(0)
		end

		test "should list a book" do
			get api_v1_book_url(@user.sessions.last), headers: default_headers
			assert_response :success
		end

		test "create a book" do
			post api_v1_book_url, params: {
				title: "New Book",
				author: "Author Name",
				isbn: "1234567890",
				copies_available: 5,
				genre: "Fiction"
			}, headers: default_headers

			assert_response :created
		end

		test "update a book" do
			patch api_v1_book_url, params: {
				title: "Updated Book",
				author: "Updated Author",
				isbn: "0987654321",
				copies_available: 10,
				genre: "Non-Fiction"
			}, headers: default_headers

			assert_response :ok
			assert_response :unauthorized
		end

		test "delete a book" do
			post api_v1_book_url(book.id), headers: default_headers

			assert_response :no_content
		end
	end
end
