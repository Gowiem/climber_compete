FactoryGirl.define do
  factory :competition do
    sequence :name do |n|
      "comp #{n}"
    end
    start_date { DateTime.yesterday }
    end_date { DateTime.tomorrow }
  end
end
