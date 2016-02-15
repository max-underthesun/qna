class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at, :created_at, :user_id, :attachments, :comments
  # has_many :comments
  # has_many :attachments

  def attachments
    object.attachments.order_by_creation_asc.map {|att| AttachmentSerializer.new(att, root: false)}
  end

  def comments
    object.comments.order_by_creation_asc.map {|att| CommentSerializer.new(att, root: false)}
  end
end
