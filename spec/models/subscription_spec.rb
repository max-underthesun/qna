require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should validate_presence_of :user_id }
  it { should belong_to :user }

  it { should validate_presence_of :question_id }
  it { should belong_to :question }

  it do
    create :subscription
    is_expected.to validate_uniqueness_of(:user_id).scoped_to(:question_id)
  end
end
