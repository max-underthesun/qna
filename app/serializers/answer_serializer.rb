class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at, :created_at, :user
  has_many :comments
  has_many :attachments

  def user
    object.user.email
  end
end
