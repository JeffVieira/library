FactoryBot.define do
	factory :borrow do
		user { FactoryBot.create(:user) }
		book { FactoryBot.create(:book) }
		due_date { Time.current  + Constants::BORROW_DURATION.days }
		returned { false }
	end
end
