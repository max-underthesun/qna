class QuestionShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :comments, :attachments
  # has_many :attachments
  # has_many :comments

  def attachments
    object.attachments.order_by_creation_asc.map { |a| AttachmentSerializer.new(a, root: false) }
  end

  def comments
    object.comments.order_by_creation_asc.map { |a| CommentSerializer.new(a, root: false) }
  end
end
