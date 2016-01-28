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

  describe "#author_of?(object)" do
    it " - should return 'true' if user is the author of the object" do
      expect(answer_author.author_of?(answer)).to eq true
    end

    it " - should return 'false' if user is not the author of the object" do
      expect(user.author_of?(answer)).to eq false
    end
  end

  describe "#can_vote?(object)" do
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

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }

    context "user already has authorization" do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
      it "returns the user" do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "user has no authorization yet" do
      context "user already exists" do
        let(:auth) do
          user_params = { provider: 'facebook', uid: '123456', info: { email: user.email } }
          OmniAuth::AuthHash.new(user_params)
        end

        it "should not create a new user" do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it "creates authorization for user" do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it "creates authorization with provider and uid equal to provided" do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
        end

        it "returns user" do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end
  end
end
