class Search
  include ActiveModel::Validations
  # extend ActiveModel::Callbacks

  # RESOURCES = [
  #   %w(Everywhere ThinkingSphinx),
  #   %w(Questions Question),
  #   %w(Answers Answer),
  #   %w(Comments Comment),
  #   %w(Users User)
  # ]

  # RESOURCES = %w(Everywhere Questions Answers Comments Users)

  RESOURCES = {
    'Everywhere' => ThinkingSphinx,
    'Questions' => Question,
    'Answers' => Answer,
    'Comments' => Comment,
    'Users' => User
  }

  attr_accessor :query, :scope #, :result

  validates :query, :scope, presence: true
  validates :scope, inclusion: RESOURCES.values

  def initialize(params)
    @query = params[:query]
    @scope = RESOURCES[params[:scope]]
    # valid?
  end

  def search_with(params)
    @scope.search(Riddle.escape(@query), params)
  end
end
