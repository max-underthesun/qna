class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  def choose_best
    previous_best_answer = question.answers.find_by(best: true)
    previous_best_answer.update(best: false) if previous_best_answer
    update(best: true)
  end
end
