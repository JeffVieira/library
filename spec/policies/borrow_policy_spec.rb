require 'rails_helper'

RSpec.describe BorrowPolicy do
	subject { BorrowPolicy.new(user, borrow) }

	let(:borrow) { FactoryBot.create(:borrow) }

	context "for a member" do
		let(:user) { FactoryBot.create(:member_user) }

		it { should permit(:create) }
		it { should_not permit(:update) }
	end

	context "for a admin" do
		let(:user) { FactoryBot.create(:user) }

		it { should permit(:create) }
		it { should permit(:update) }
	end
end
