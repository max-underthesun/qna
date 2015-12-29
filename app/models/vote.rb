class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, :user_id, presence: true
  validates :value, inclusion: [-1, 1]
  validates :votable_type, inclusion: %w(Question Answer)
end
