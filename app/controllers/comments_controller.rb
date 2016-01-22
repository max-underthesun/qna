class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    flash[:notice] = I18n.t('confirmations.comment.create') if @comment.save
  end

  private

  # def load_commentable
  #   @commentable = Question.find(params[:question_id])
  # end

  def load_commentable
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
