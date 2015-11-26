class AnswersController < ApplicationController
  before_action :authenticate_user! # , except: [:index, :show]
  before_action :set_question, only: :create # [:new, :create]

  # def new
  #   @answer = Answer.new
  # end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = I18n.t('confirmations.answers.create')
      redirect_to @question
    else
      render 'questions/show'
    end
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
