class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  # before_action :load_subscription, only: :destroy

  respond_to :js

  # authorize_resource

  def create
    authorize! :create, Subscription

    @question = Question.find(params[:question_id])
    respond_with(@subscription = @question.subscriptions.create(user: current_user))
    # @subscription = @question.subscriptions.new(user: current_user)
    # @subscription.save
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize! :destroy, @subscription

    respond_with(@subscription.destroy)
  end

  # private

  # def load_subscription
  #   @subscription = Subscription.find(params[:id])
  #   # @question = Question.find(:id)
  # end

  # def load_question
  #   # @question = Question.find(:id)
  # end

  # def comment_params
  #   params.require(:comment).permit(:body)
  # end
end
