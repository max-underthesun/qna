class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    return unless @answer.save
    @success = true
    flash[:notice] = I18n.t('confirmations.answers.create')
  end

  def destroy
    @answer = Answer.find(params[:id])
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

  def answer_params
    params.require(:answer).permit(:body)
  end
end
