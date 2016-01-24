class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, :user_id, :commentable_id, :commentable_type, presence: true

  scope :order_by_creation_asc, -> { order(created_at: :asc) }
end
