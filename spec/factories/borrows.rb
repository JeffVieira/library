FactoryBot.define do
	factory :borrow do
		user { FactoryBot.create(:user) }
		book { FactoryBot.create(:book) }
		borrow_date { Time.current }
		returned { false }
	end
end
