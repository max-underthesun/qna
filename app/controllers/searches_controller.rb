class SearchesController < ApplicationController
  skip_authorization_check

  def show
    @query = params[:query]
    return redirect_to root_path if @query.blank?

    @scope = params[:resource].constantize
    @result = @scope.search(Riddle.escape(@query), page: params[:page], per_page: 5)
  end
end
