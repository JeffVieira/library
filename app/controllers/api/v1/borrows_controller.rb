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

		private
			def borrow_params
				params.permit(:user_id, :book_id, :returned, :borrow_date)
			end
	end
end
