FactoryGirl.define do
  factory :comment do
    trait :question_comment do
      association :commentable, factory: :question
    end
    trait :answer_vote do
      association :commentable, factory: :answer
    end

    sequence(:body) { |n| "comment body #{n}" }
    user
  end
end
