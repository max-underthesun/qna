class QuestionShowSerializer < ActiveModel::Serializer
  include AttachmentSerializable
  include CommentSerializable

  attributes :id, :title, :body, :created_at, :updated_at, :comments, :attachments
  # has_many :attachments
  # has_many :comments
end
