module Api::V1
	class BooksController < ApplicationController
		before_action :authenticate

		def index
			@books = Book.all
			render json: @books, status: :ok
		end

		def show
			@book = Book.find(params[:id])
			render json: @book, status: :ok
		end

		def create
			@book = Book.new(book_params)
			authorize @book

			if @book.save
				render json: @book, status: :created
			else
				render json: @book.errors, status: :unprocessable_entity
			end
		end

		def update
			@book = Book.find(params[:id])
			authorize @book
			if @book.update(book_params)
				render json: @book, status: :ok
			else
				render json: @book.errors, status: :unprocessable_entity
			end
		end

		def destroy
			@book = Book.find(params[:id])
			authorize @book
			if @book.destroy
				head :no_content
			else
				render json: @book.errors, status: :unprocessable_entity
			end
		end

		private
			def book_params
				params.permit(:title, :author, :isbn, :copies_available, :genre)
			end
	end
end
