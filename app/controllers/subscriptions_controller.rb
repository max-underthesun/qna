class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    authorize! :create, Subscription

    respond_with(@subscription = @question.subscriptions.create(user: current_user))
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize! :destroy, @subscription

    @question = @subscription.question
    respond_with(@subscription.destroy)
  end
end
