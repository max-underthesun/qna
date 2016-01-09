class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: [:update, :destroy, :best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save && flash[:notice] = I18n.t('confirmations.answers.create')

    # respond_to do |format|
    #   format.html { render partial: @answer, layout: false }
    #   format.json { render json: @answer }
    # end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params) && flash[:notice] = I18n.t('confirmations.answers.update')
    else
      flash[:alert] = I18n.t('failure.answers.update')
      render status: :forbidden
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy && flash[:warning] = I18n.t('confirmations.answers.destroy')
    else
      flash[:alert] = I18n.t('failure.answers.destroy')
      render status: :forbidden
    end
  end

  def best
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.choose_best && flash[:notice] = I18n.t('confirmations.answers.best')
    else
      flash[:alert] = I18n.t('failure.answers.best')
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
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
