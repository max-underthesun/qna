FactoryGirl.define do
  sequence :title do |n|
    "question title #{n}"
  end

  sequence :body do |n|
    "question body #{n}"
  end

  factory :question do
    title
    body
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
