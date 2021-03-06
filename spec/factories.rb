# By using the symbol ':user', we get Factory Girl to simulate the User model.
FactoryGirl.define do
	factory :user do |user|
		user.name					"Ravi Nayak"
		user.email					"ravi@example.com"
		user.password 				"foobar"
		user.password_confirmation	"foobar"
	end

	sequence :email do |n|
		"person-#{n}@example.com"
	end

	factory :micropost do |micropost|
		micropost.content "Foo bar"
		micropost.association :user
	end
end


