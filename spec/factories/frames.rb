FactoryBot.define do
  factory :frame do
    sequence(:x) { |n| n * 20 }
    sequence(:y) { |n| n * 20 }
    width { 100 }
    height { 100 }
  end
end