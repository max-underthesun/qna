class SearchesController < ApplicationController
  skip_authorization_check

  def show
    @search = Search.new(params)
    @result = @search.search_with(page: params[:page], per_page: 5) if @search.valid?
  end
end
