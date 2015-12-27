require_relative '../acceptance_helper'

feature 'VOTE FOR THE QUESTION', %q(
  authenticated user, but not the author of the question can vote for the
  question to increase or decrease question rating
) do
  given(:user) { create(:user) }
  given(:question_author) { create(:user) }
  given!(:question) { create(:question, user: question_author) }

  scenario "- anauthorized user can see the rating of the question in the question show view"

  describe "- author unable to vote for his question" do
    scenario "-- author see the rating"
    scenario "-- author don't see the buttons"
  end

  describe "- non-author able to vote for the question" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "-- see the '+' and '-' buttons for vote"
    scenario "-- can vote '+'"
    scenario "-- can vote '-'"
    scenario "-- unable to vote twice for the question (don't see buttons)"
    scenario "-- can cancel his vote (have a button and it works properly)"
    scenario "-- can cancel existent vote and make a new vote"
  end
end
