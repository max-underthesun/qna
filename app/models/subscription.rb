class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :user_id, :question_id, presence: true
  validates :user_id, uniqueness: { scope: [:question_id] }

  # validate :unique_entry

  # def unique_entry
  #   matched_entry = Subscription.where(['user_id = ? AND question_id = ?', self.user_id, self.question_id]).first
  #   errors.add(:base, 'This subscription already exists') if matched_entry && (matched_entry.id != self.id)
  # end
end
