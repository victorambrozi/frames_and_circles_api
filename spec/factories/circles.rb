FactoryBot.define do
  factory :circle do
    association :frame
    x { 50 }
    y { 50 }
    diameter { 20 }
  end
end