FactoryBot.define do
	factory :book do
		title { Faker::Book.title }
		author { Faker::Book.author }
		genre { Faker::Book.genre }
		isbn { Faker::Code.isbn }
		copies_available { 1 }
	end
end
