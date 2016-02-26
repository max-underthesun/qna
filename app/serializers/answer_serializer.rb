class AnswerSerializer < ActiveModel::Serializer
  include AttachmentSerializable
  include CommentSerializable

  attributes :id, :body, :updated_at, :created_at, :user_id, :comments, :attachments
  # has_many :comments
  # has_many :attachments
end
