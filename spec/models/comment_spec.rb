require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { build(:comment, :question_comment) }

  it { should belong_to :user }
  it { should validate_presence_of :user_id }

  it { should belong_to :commentable }
  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }

  it { should validate_presence_of :body }
end
