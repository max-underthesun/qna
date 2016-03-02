class Search < ActiveRecord::Base
  # RESOURCES = [['Everywhere'], ['Questions'], ['Answers'], ['Comments'], ['Users']]
  # RESOURCES = [['Everywhere', 'ThinkingSphinx'], ['Questions', 'Question'], ['Answers', 'Answer'], ['Comments', 'Comment'], ['Users', 'User']]

  RESOURCES = [
    %w(Everywhere ThinkingSphinx),
    %w(Questions Question),
    %w(Answers Answer),
    %w(Comments Comment),
    %w(Users User)
  ]

  # attr_accessor :query
end
