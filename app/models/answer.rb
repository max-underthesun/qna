class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable
  accepts_nested_attributes_for :attachments

  validates :body, :question_id, :user_id, presence: true

  scope :best_first, -> { order(best: :desc, created_at: :asc) }

  def choose_best
    ActiveRecord::Base.transaction do
      old_best_answer = question.answers.find_by(best: true)
      old_best_answer.update!(best: false) if old_best_answer && old_best_answer != self
      update!(best: true)
    end
  end
end
