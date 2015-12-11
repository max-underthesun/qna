class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  def self.ordered_answers_for(question)
    where(question: question).order(best: :desc).order(created_at: :asc)
  end

  def choose_best
    previous_best_answer = question.answers.find_by(best: true)
    update(best: true)
    return unless previous_best_answer && previous_best_answer != self
    previous_best_answer.update(best: false)
  end
end
