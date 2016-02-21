class Question < ActiveRecord::Base
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :user_id, :title, :body, presence: true
  validates :title, length: { maximum: 150 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :update_reputation

  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }

  protected

  def update_reputation
    CalculateReputationJob.perform_later(self)
    # delay.calculate_reputation
    # calculate_reputation
  end

  # def calculate_reputation
  #   reputation = Reputation.calculate(self)
  #   user.update(reputation: reputation)
  # end
end
