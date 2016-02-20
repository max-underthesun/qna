require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_length_of(:title).is_at_most(150) }
  it { should validate_presence_of :body }

  it { should have_many :answers }

  it { should validate_presence_of :user_id }
  it { should belong_to :user }

  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }

  it_behaves_like "votable"
  it_behaves_like "commentable"

  describe 'reputation' do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it_behaves_like "reputation calculatable"

    # it 'should calculate reputation after creating' do
    #   expect(CalculateReputationJob).to receive(:perform_later).with(subject)
    #   subject.save!
    # end

    # it 'should not calculate reputation after update' do
    #   subject.save!
    #   expect(CalculateReputationJob).to_not receive(:perform_later)
    #   subject.update(title: '123')
    # end

    # it 'should save user reputation' do
    #   allow(Reputation).to receive(:calculate).and_return(5)
    #   expect { subject.save! }.to change(user, :reputation).by(5)
    # end
  end
end
