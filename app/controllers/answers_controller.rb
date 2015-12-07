class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: [:update, :destroy]
  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      render status: :unauthorized
      flash[:alert] = I18n.t('failure.answers.update')
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      flash[:warning] = I18n.t('confirmations.answers.destroy')
      @answer.destroy
    else
      flash[:alert] = I18n.t('failure.answers.destroy')
    end
    redirect_to @answer.question
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
