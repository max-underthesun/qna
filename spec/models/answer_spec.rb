require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }

  it { should validate_presence_of :question_id }
  it { should belong_to :question }

  it { should validate_presence_of :user_id }
  it { should belong_to :user }

  describe "choose_best should update 'best' attribute" do
    let(:answers) { create_list(:answer, 5) }

    it "updates answer best status to true" do
      answer = answers.first
      answer.choose_best

      expect(answer.best).to eq true
    end

    it "updates previous best answer status to false" do
      best_answer = answers.sample
      best_answer.choose_best
      answers.delete(best_answer)

      answers.each do |answer|
        expect(answer.best).to eq false
      end
    end
  end

  describe "ordered_answers_for should order question answers" do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 5, question: question) }

    it "should put 'best answer' first in the list" do
      best_answer = question.answers.sample
      best_answer.choose_best

      expect(Answer.ordered_answers_for(question).first).to eq best_answer
    end

    it "should order answers by creatiton" do
      best_answer = question.answers.sample
      best_answer.choose_best
      all_answers = Answer.ordered_answers_for(question).to_a
      all_answers.delete(best_answer)
      # all_answers.shuffle!
      created = all_answers.first.created_at

      all_answers.each do |answer|
        expect(answer.created_at).to be >= created
        created = answer.created_at
      end
    end
  end
end
