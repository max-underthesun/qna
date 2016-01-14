class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, :user_id, :votable_id, :votable_type, presence: true
  validates :value, inclusion: [-1, 1]
  validates :votable_type, inclusion: %w(Question Answer)
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  validate :current_user_is_not_a_votable_author

  private

  def current_user_is_not_a_votable_author
    errors.add(:user_id, I18n.t('errors.votes.self_vote')) if votable && votable.user_id == user_id
  end

  # def current_user_is_not_a_votable_author
  #   if votable && votable_klass.find(votable_id).user_id == user_id
  #     self.errors.add(:user_id, "You can't vote for yourself")
  #   end
  # end

  # def votable_klass
  #   votable_type.constantize
  # end
end
