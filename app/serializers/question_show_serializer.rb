class QuestionShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  has_many :attachments
  has_many :comments
  # has_many :answers

  # def short_title
  #   object.title.truncate(10)
  # end
end
