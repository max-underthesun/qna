FactoryGirl.define do
  factory :vote do
    trait :question_vote do
      association :votable, factory: :question
    end
    trait :answer_vote do
      association :votable, factory: :answer
    end

    value 1
    user
    # votable { |a| a.association(:question) }
  end
end
