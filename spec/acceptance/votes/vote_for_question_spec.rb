require_relative '../acceptance_helper'

feature 'VOTE FOR THE QUESTION', %q(
  authenticated user, but not the author of the question can vote for the
  question to increase or decrease question rating
) do
  votes_number = 5

  given(:user) { create(:user) }
  given(:question_author) { create(:user) }
  given!(:question) { create(:question, user: question_author) }
  given!(:votes) { create_list(:vote, votes_number, votable: question) }

  describe "- unauthorized user" do
    scenario "-- see the rating of the question in the question show view" do
      visit question_path(question)

      within ".question-rating#question_#{question.id}" do
        expect(page).to have_content I18n.t('common.rating')
        expect(page).to have_content "#{question.rating}"
      end
    end

    # scenario "-- unable to vote"
  end

  # describe "- author of the question" do
  #   scenario "-- see the rating"
  #   scenario "-- unable to vote"
  # end

  describe "- non-author of the question" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    # scenario "-- see the '+' and '-' buttons for vote"
    scenario "-- able to vote_up", js: true do
      within ".question-rating#question_#{question.id}" do
        expect(find(".rating-value")).to have_content "#{votes_number}"
        find("a[href='#{vote_up_question_path(question)}']").click

        expect(find(".rating-value")).to have_content "#{votes_number + 1}"
      end
    end
    # scenario "-- can vote '-'"
    # scenario "-- unable to vote twice for the question (don't see buttons)"
    # scenario "-- can cancel his vote (have a button and it works properly)"
    # scenario "-- can cancel existent vote and make a new vote"
  end
end
