class AnswersController < ApplicationController
  include VotableController

  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: [:update, :destroy, :best]

  respond_to :js

  authorize_resource

  def create
    respond_with(
      @answer = @question.answers.create(answer_params.merge!(user_id: current_user.id)))
    publish
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def best
    @question = @answer.question
    respond_with @answer.choose_best
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
