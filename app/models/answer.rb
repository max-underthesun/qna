class Answer < ActiveRecord::Base
  include Votable
  include Commentable

  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  validate :if_updating_by_author, on: :update

  scope :best_first, -> { order(best: :desc, created_at: :asc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

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

  private

  def if_updating_by_author
    errors.add(:base, 'Only author can update') if Answer.find(id).user_id != user_id
  end
end
