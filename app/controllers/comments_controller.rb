class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :commentable_class
  before_action :load_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    publish && flash[:notice] = I18n.t('confirmations.comment.create') if @comment.save
  end

  private

  def commentable_class
    @commentable_class = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"] }
  end

  def load_commentable
    @commentable = @commentable_class.find(params["#{@commentable_class.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish
    PrivatePub.publish_to comment_channel,
                          comment: @comment.to_json,
                          author: @comment.user.email.to_json
  end

  def comment_channel
    case @commentable_class.name
    when 'Question'
      "/questions/#{@commentable.id}/comments"
      # "/questions/#{@question.id}/answers/comments"
    end
  end
end
