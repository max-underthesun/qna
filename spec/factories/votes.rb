FactoryGirl.define do
  factory :vote do
    # association :votable, factory: :question
    value 1
    votable { |a| a.association(:question) }
    user
  end
end
