FactoryBot.define do
	factory :book do
		title { 'Harry potter' }
		author { 'J K Rowling' }
		genre { 'Fantasy' }
		isbn { '1' }
		copies_available { 1 }
	end
end