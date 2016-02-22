class Question < ActiveRecord::Base
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :user_id, :title, :body, presence: true
  validates :title, length: { maximum: 150 }

  after_create :update_reputation

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }

  protected

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end
end
