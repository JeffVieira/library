require 'rails_helper'

RSpec.describe BookPolicy do
	subject { BookPolicy.new(user, book) }

	let(:book) { FactoryBot.create(:book) }

	context "for a member" do
		let(:user) { FactoryBot.create(:member_user) }

		it { should permit(:index) }
		it { should permit(:show) }
		it { should_not permit(:create) }
		it { should_not permit(:update) }
		it { should_not permit(:destroy) }
	end

	context "for a admin" do
		let(:user) { FactoryBot.create(:user) }

		it { should permit(:index) }
		it { should permit(:show) }
		it { should permit(:create) }
		it { should permit(:update) }
		it { should permit(:destroy) }
	end
end
