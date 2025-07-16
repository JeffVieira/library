FactoryBot.define do
	factory :user do
		email { Faker::Internet.email }
		password { 'password123456' }
		password_confirmation { 'password123456' }
		role { 'admin' }
	end

	factory :member_user, class: User do
		email { Faker::Internet.email }
		password { 'password123456' }
		password_confirmation { 'password123456' }
		role { 'member' }
	end
end
