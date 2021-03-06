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

  it { should have_many :subscriptions }

  it { should have_many :subscribers }

  describe 'reputation' do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it_behaves_like "reputation calculatable"
  end
end
