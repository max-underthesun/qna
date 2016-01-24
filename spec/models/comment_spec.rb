require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { build(:comment, :question_comment) }

  it { should belong_to :user }
  it { should validate_presence_of :user_id }

  it { should belong_to :commentable }
  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }

  it { should validate_presence_of :body }

  describe "order_by_creation_asc should: " do
    let(:question) { create(:question) }
    let!(:comments) { create_list(:comment, 5, commentable: question) }

    it "- order comments by creation" do
      ordered_comments = question.comments.order_by_creation_asc.to_a

      created = ordered_comments.first.created_at
      ordered_comments.each do |comment|
        expect(comment.created_at).to be >= created
        created = comment.created_at
      end
    end
  end
end
