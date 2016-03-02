class Search < ActiveRecord::Base
  RESOURCES = [
    %w(Everywhere ThinkingSphinx),
    %w(Questions Question),
    %w(Answers Answer),
    %w(Comments Comment),
    %w(Users User)
  ]
end
