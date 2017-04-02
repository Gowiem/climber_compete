FactoryGirl.define do
  factory :climb do
    sequence :name do |n|
      "climb #{n}"
    end
    sequence :route_id do |n|
      "route_#{n}"
    end
    climb_type { "Trad" }
    climb_date { DateTime.now }
    rating { '5.11b' }
    pitches { 1 }
  end
end
