class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create

  def create
    @comment = @question.comments.new(comment_params)
    @comment.user = current_user
    flash[:notice] = I18n.t('confirmations.comment.create') if @comment.save
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
