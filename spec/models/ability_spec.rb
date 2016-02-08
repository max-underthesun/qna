require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe "for guest" do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe "for user" do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question_of_user) { create :question, user: user }
    let(:question_of_other_user) { create :question, user: other_user }
    let(:answer_of_user) { create :answer, question: question_of_other_user, user: user }
    let(:answer_of_other_user) { create :answer, question: question_of_user, user: other_user }
    let!(:vote) { create :vote, votable: question_of_other_user, user: user }
    let!(:question_of_user_attachment) { create :attachment, attachable: question_of_user }
    let!(:answer_of_user_attachment) { create :attachment, attachable: answer_of_user }
    let!(:question_of_other_user_attachment) { create :attachment, attachable: question_of_other_user }
    let!(:answer_of_other_user_attachment) { create :attachment, attachable: answer_of_other_user }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question_of_user, user: user }
    it { should_not be_able_to :update, question_of_other_user, user: user }
    it { should be_able_to :update, answer_of_user, user: user }
    it { should_not be_able_to :update, answer_of_other_user, user: user }

    it { should be_able_to :destroy, question_of_user, user: user }
    it { should_not be_able_to :destroy, question_of_other_user, user: user }
    it { should be_able_to :destroy, answer_of_user, user: user }
    it { should_not be_able_to :destroy, answer_of_other_user, user: user }

    it { should be_able_to :vote_up, question_of_other_user, user: user }
    it { should_not be_able_to :vote_up, question_of_user, user: user }
    it { should be_able_to :vote_down, question_of_other_user, user: user }
    it { should_not be_able_to :vote_down, question_of_user, user: user }

    it { should be_able_to :vote_destroy, question_of_other_user, user: user }

    it { should be_able_to :best, answer_of_other_user, user: user }

    it { should be_able_to :destroy, question_of_user_attachment, user: user }
    it { should be_able_to :destroy, answer_of_user_attachment, user: user }
    it { should_not be_able_to :destroy, question_of_other_user_attachment, user: user }
    it { should_not be_able_to :destroy, answer_of_other_user_attachment, user: user }

    it { should be_able_to :me, user, user: user }
    it { should_not be_able_to :me, other_user, user: user }

    it { should be_able_to :all_except_current, user, user: user }
    it { should_not be_able_to :all_except_current, other_user, user: user }
  end
end
