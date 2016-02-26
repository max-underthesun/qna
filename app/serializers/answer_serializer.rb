# require 'attachment_serializable'

class AnswerSerializer < ActiveModel::Serializer
  # include AttachmentSerializable
  attributes :id, :body, :updated_at, :created_at, :user_id, :comments, :attachments
  # has_many :comments
  # has_many :attachments

  def attachments
    object.attachments.order_by_creation_asc.map { |a| AttachmentSerializer.new(a, root: false) }
  end

  def comments
    object.comments.order_by_creation_asc.map { |a| CommentSerializer.new(a, root: false) }
  end
end
