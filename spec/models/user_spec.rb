require 'rails_helper'

RSpec.describe User do
  let!(:user) { create(:user) }

  it 'validates uniqueness of email' do
    expect(build(:user, email: user.email)).to_not be_valid
    expect(build(:user, email: user.email.upcase)).to_not be_valid
  end

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_length_of(:password).is_at_least(8) }

  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :votes }

  let(:answer_author) { create(:user) }
  let(:answer) { create(:answer, user: answer_author) }

  describe "author_of?(object)" do
    it " - should return 'true' if user is the author of the object" do
      expect(answer_author.author_of?(answer)).to eq true
    end

    it " - should return 'false' if user is not the author of the object" do
      expect(user.author_of?(answer)).to eq false
    end
  end

  describe "can_vote?(object)" do
    it " - return 'true' if user is not the author of the object and did not voted for it yet" do
      expect(user.can_vote?(answer)).to eq true
    end

    it " - return 'false' if user is not the author of the object and already voted for it" do
      create(:vote, votable: answer, user: user)
      expect(user.can_vote?(answer)).to eq false
    end

    it " - return 'false' if user is author of object" do
      expect(answer_author.can_vote?(answer)).to eq false
    end
  end
end
