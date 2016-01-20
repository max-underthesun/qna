class QuestionsController < ApplicationController
  include VotableController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    # gon.watch.current_user_id = current_user.id if current_user
    gon.current_user_id = current_user.id if current_user
    gon.question_user_id = @question.user.id
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = I18n.t('confirmations.questions.create')
      publish
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params) &&
        flash[:notice] = I18n.t('confirmations.questions.update')
    else
      flash[:alert] = I18n.t('failure.questions.update')
      render status: :forbidden
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:warning] = I18n.t('confirmations.questions.destroy')
    else
      flash[:alert] = I18n.t('failure.questions.destroy')
    end
    redirect_to questions_path
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
    PrivatePub.publish_to "/questions",
                          question: @question.to_json,
                          author: @question.user.email.to_json
  end
end
