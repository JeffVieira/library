module Api::V1
	class BorrowsController < ApplicationController
		before_action :authenticate

		def create
			@borrow = Borrow.new(borrow_params)
			authorize @borrow

			if @borrow.save
				render json: @borrow, status: :created
			else
				render json: @borrow.errors, status: :unprocessable_entity
			end
		end

		def update
			@borrow = Borrow.where(book_id: params[:book_id], user_id: params[:user_id]).first

			if @borrow.nil?
				render json: { error: "Borrow record not found" }, status: :not_found
				return
			end

			if @borrow.returned?
				# mudar para o modelo?
				render json: { error: "This book has already been returned" }, status: :unprocessable_entity
				return
			end

			authorize @borrow
			if @borrow.update({ returned: true })
				render json: @borrow, status: :ok
			else
				render json: @borrow.errors, status: :unprocessable_entity
			end
		end

		private
			def borrow_params
				params.permit(:user_id, :book_id, :returned, :borrow_date)
			end
	end
end
