class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  # before_action :load_subscription, only: :destroy
  # before_action :load_question, only: :create
  # authorize_resource
  # load_and_authorize_resource #:through => :question

  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    authorize! :create, Subscription

    respond_with(@subscription = @question.subscriptions.create(user: current_user))

    # @subscription = Subscription.new(question: @question, user: current_user)
    # authorize! :create, @subscription

    # @subscription.save
    # respond_with @subscription
    # @subscription = @question.subscriptions.new(user: current_user)
    # @subscription.save
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize! :destroy, @subscription

    @question = @subscription.question
    respond_with(@subscription.destroy)
  end

  # private

  # def load_subscription
  #   @subscription = Subscription.find(params[:id])
  #   # @question = Question.find(:id)
  # end

  # def load_question
  #   @question = Question.find(params[:question_id])
  # end

  # def comment_params
  #   params.require(:comment).permit(:body)
  # end
end
