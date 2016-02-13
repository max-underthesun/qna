class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at, :created_at, :user_id
  has_many :comments
  has_many :attachments
end
