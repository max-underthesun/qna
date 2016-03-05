FactoryGirl.define do
  factory :search do
    query 'abba'
    scope Question
  end
end
