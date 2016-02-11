class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :user

  def user
    object.user.email
  end
end
