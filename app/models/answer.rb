class Answer < ActiveRecord::Base
  include Votable
  include Commentable

  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  after_create :update_reputation, :notify_question_author, :notify_subscribers
  # after_commit :notify_question_author

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :best_first, -> { order(best: :desc, created_at: :asc) }

  def choose_best
    ActiveRecord::Base.transaction do
      old_best_answer = question.answers.find_by(best: true)
      old_best_answer.update!(best: false) if old_best_answer && old_best_answer != self
      update!(best: true)
    end
  end

  def attachments_info
    attachments_info = []
    attachments.each do |a|
      attachments_info << { id: a.id, name: a.file.filename, url: a.file.url }
    end
    attachments_info
  end

  protected

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end

  def notify_question_author
    NewAnswerNotificationMailer.notify_question_author(self).deliver_later
  end

  def notify_subscribers
    question.subscribers.find_each do |subscriber|
      NewAnswerNotificationMailer.notify_subscribers(self, subscriber).deliver_later
    end
  end
end
