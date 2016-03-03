class SearchesController < ApplicationController
  skip_authorization_check

  def show
    @search = Search.new(params)
    # @search.search if @search.valid?
    # @search

    # return redirect_to root_path unless @search.valid? # if @query.blank?

    # return render nothing: true unless @search.valid? # if @query.blank?

    # @result = @search.scope.search(Riddle.escape(@search.query), page: params[:page], per_page: 5) if @search.valid?

    @result = @search.search_with(page: params[:page], per_page: 5) if @search.valid?
    # .scope.search(Riddle.escape(@search.query), page: params[:page], per_page: 5) if @search.valid?
    # @search

    # @query = params[:query]
    # return redirect_to root_path if @query.blank?
    # @scope = params[:resource].singularize.constantize
    # @result = @scope.search(Riddle.escape(@query), page: params[:page], per_page: 5)
  end
end
