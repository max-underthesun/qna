class AnswersController < ApplicationController
  include VotableController

  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: [:update, :destroy, :best]

  respond_to :js # , only: [:create, :update, :destroy]

  authorize_resource

  def create
    respond_with(
      @answer = @question.answers.create(answer_params.merge!(user_id: current_user.id)))
    publish

    # @answer = @question.answers.new(answer_params)
    # @answer.user = current_user
    # publish && flash[:notice] = I18n.t('confirmations.answers.create') if @answer.save
  end

  def update
    @answer.update(answer_params) # if current_user.author_of?(@answer)
    respond_with(@answer)

    # @answer.update(answer_params.merge!(user_id: current_user.id))

    # if current_user.author_of?(@answer)
    #   @answer.update(answer_params) && flash[:notice] = I18n.t('confirmations.answers.update')
    # else
    #   flash[:alert] = I18n.t('failure.answers.update')
    #   render status: :forbidden
    # end
  end

  def destroy
    respond_with(@answer.destroy) # if current_user.author_of?(@answer)

    # if current_user.author_of?(@answer)
    #   @answer.destroy && flash[:warning] = I18n.t('confirmations.answers.destroy')
    # else
    #   flash[:alert] = I18n.t('failure.answers.destroy')
    #   render status: :forbidden
    # end
  end

  def best
    @question = @answer.question
    respond_with @answer.choose_best

    # @question = @answer.question
    # if current_user.author_of?(@question)
    #   @answer.choose_best && flash[:notice] = I18n.t('confirmations.answers.best')
    # else
    #   flash[:alert] = I18n.t('failure.answers.best')
    #   render status: :forbidden
    # end
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

  def publish
    return if @answer.errors.any?
    PrivatePub.publish_to "/questions/#{@question.id}/answers",
                          answer: @answer.to_json,
                          rating: @answer.rating.to_json,
                          author: @answer.user.email.to_json,
                          attachments: @answer.attachments_info.to_json
  end
end
