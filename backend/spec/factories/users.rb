def x_many_climbs_user(x)
  factory "user_with_#{x}_climbs_today" do
    after(:create) do |user|
      x.times { create(:climb, climb_date: DateTime.now, user: user) }
    end
  end
end

FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "email#{n}@example.com"
    end
    password '123456789'
    password_confirmation '123456789'

    x_many_climbs_user(1)
    x_many_climbs_user(2)
    x_many_climbs_user(3)
  end
end
