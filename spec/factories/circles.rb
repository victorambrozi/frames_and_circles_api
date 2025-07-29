FactoryBot.define do
  factory :circle do
    x { 100 }
    y { 100 }
    diameter { 20 }
    association :frame
  end
end