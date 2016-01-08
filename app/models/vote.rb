class Vote < ActiveRecord::Base
  # attr_accessor :votable_klass
  # before_validation :set_votable_klass

  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, :user_id, :votable_id, :votable_type, presence: true
  validates :value, inclusion: [-1, 1]
  validates :votable_type, inclusion: %w(Question Answer)
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  validate :current_user_is_not_a_votable_author

  # def forbid_voting
  #   errors.add(:user_id, "You can't vote for yourself")
  # end

  def current_user_is_not_a_votable_author
    errors.add(:user_id, "You can't vote for yourself") if votable && votable.user_id == user_id
  end

  # def current_user_is_not_a_votable_author
  #   # if votable #votable_id && votable_type
  #     if votable && votable_klass.find(votable_id).user_id == user_id
  #       self.errors.add(:user_id, "You can't vote for yourself")
  #       # false
  #     end
  #   # end
  # end

  # def votable_klass # set_votable_klass
  #   # self.votable_klass = 
  #   votable_type.constantize
  # end
end
