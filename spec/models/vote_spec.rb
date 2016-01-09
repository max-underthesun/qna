require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject { build(:vote, :question_vote) }

  it { should belong_to :user }
  it { should validate_presence_of :user_id }
  it do
    create :vote, :question_vote
    is_expected.to validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type])
  end
  # describe do
  #   before { create :vote, :question_vote }
  #   it { should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type]) }
  # end

  it { should belong_to :votable }
  it { should validate_presence_of :votable_id }
  it { should validate_presence_of :votable_type }

  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_array([-1, 1]) }

  # it { should validate_inclusion_of(:votable_type).in_array(%w(Question Answer)) }

  # let(:user) { create(:user) }
  # it 'validates inclusion of votable_type in ["Question", "Answer"]' do
  #   expect(build(:vote, :question_vote)).to be_valid
  #   expect(build(:vote, :answer_vote)).to be_valid
  #   expect(build(:vote, votable_type: "User", votable_id: user.id)).to_not be_valid
  # end
end
