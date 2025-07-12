FactoryBot.define do
  factory :location do
    sequence(:external_id) { |n| "ext_chicago_#{n}" }
    city { "Chicago" }
    state { "Illinois" }
    country { "United States" }
    zipcode { "60622" }
    lat { 41.8755616 }
    lon { -87.6244212 }
    utc_offset { -21600 }
  end
end
