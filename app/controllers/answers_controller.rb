class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: [:update, :destroy, :best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      flash[:alert] = I18n.t('failure.answers.update')
      # @answer.errors.add(:base, I18n.t('failure.answers.update'))
      render status: :forbidden
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      @answer.errors.add(:base, I18n.t('failure.answers.destroy'))
      render status: :forbidden
    end
  end

  def best
    @question = @answer.question
    if current_user.author_of?(@answer.question)
      @answer.choose_best
    else
      @answer.errors.add(:base, I18n.t('failure.answers.best'))
      render status: :forbidden
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
