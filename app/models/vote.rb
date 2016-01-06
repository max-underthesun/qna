class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, :user_id, :votable_id, presence: true
  validates :value, inclusion: [-1, 1]
  validates :votable_type, inclusion: %w(Question Answer)
  # validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
end
