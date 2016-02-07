class QuestionsController < ApplicationController
  include VotableController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]

  respond_to :js, only: :update

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answer = @question.answers.new
    gon.current_user_id = current_user.id if current_user
    gon.question_user_id = @question.user.id

    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
    publish
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def question_params
    params.require(:question)
      .permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def publish
    return if @question.errors.any?
    PrivatePub.publish_to "/questions",
                          question: @question.to_json,
                          author: @question.user.email.to_json
  end
end
