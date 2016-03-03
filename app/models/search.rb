class Search
  include ActiveModel::Validations

  RESOURCES = {
    'Everywhere' => ThinkingSphinx,
    'Questions' => Question,
    'Answers' => Answer,
    'Comments' => Comment,
    'Users' => User
  }

  attr_accessor :query, :scope

  validates :query, :scope, presence: true
  validates :scope, inclusion: RESOURCES.values

  def initialize(params)
    @query = params[:query]
    @scope = RESOURCES[params[:scope]]
  end

  def search_with(params)
    @scope.search(Riddle.escape(@query), params)
  end
end
