FactoryBot.define do
	factory :user do
		email { 'user@example.com' }
		password { 'password123456' }
		password_confirmation { 'password123456' }
		role { 'admin' }
	end

	factory :member_user, class: User do
		email { 'user@example.com' }
		password { 'password123456' }
		password_confirmation { 'password123456' }
		role { 'member' }
	end
end
