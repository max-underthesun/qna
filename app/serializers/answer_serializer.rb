class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at, :created_at, :user_id, :attachments, :comments
  # has_many :comments
  # has_many :attachments

  def attachments
    object.attachments.order_by_creation_asc.map { |a| AttachmentSerializer.new(a, root: false) }
  end

  def comments
    object.comments.order_by_creation_asc.map { |a| CommentSerializer.new(a, root: false) }
  end
end
