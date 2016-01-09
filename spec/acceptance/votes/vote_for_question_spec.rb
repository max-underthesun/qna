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
    before { visit question_path(question) }

    scenario "-- see the rating of the question in the question show view" do
      within ".question-rating#question_#{question.id}" do
        expect(page).to have_content I18n.t('common.rating')
        expect(page).to have_content "#{question.rating}"
      end
    end

    scenario "-- unable to vote_up", js: true do
      within ".question-rating#question_#{question.id}" do
        expect(find(".rating-value")).to have_content "#{votes_number}"
        find("a[href='#{vote_up_question_path(question)}']").click

        expect(find(".rating-value")).to have_content "#{votes_number}"
      end

      expect(page).to have_content I18n.t('devise.failure.unauthenticated')
    end

    # scenario "-- unable to vote_down", js: true do
    # end
  end

  describe "- author of the question" do
    before do
      sign_in(question_author)
      visit question_path(question)
    end

    scenario "-- see the rating of the question in the question show view" do
      within ".question-rating#question_#{question.id}" do
        expect(page).to have_content I18n.t('common.rating')
        expect(page).to have_content "#{question.rating}"
      end
    end

    scenario "-- unable to vote_up (do not see the button)", js: true do
      within ".question-rating#question_#{question.id}" do
        expect(page).to_not have_css "a[href='#{vote_up_question_path(question)}']"
      end
    end

    # scenario "-- unable to vote_down (do not see the button)"
  end

  describe "- non-author of the question" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "-- see the rating of the question in the question show view" do
      within ".question-rating#question_#{question.id}" do
        expect(page).to have_content I18n.t('common.rating')
        expect(page).to have_content "#{question.rating}"
      end
    end

    scenario "-- able to vote_up", js: true do
      within ".question-rating#question_#{question.id}" do
        expect(find(".rating-value")).to have_content "#{votes_number}"
        find("a[href='#{vote_up_question_path(question)}']").click

        expect(find(".rating-value")).to have_content "#{votes_number + 1}"
      end
    end

    scenario "-- unable to vote_up second time (don't see the button)", js: true do
      create(:vote, votable: question, user: user)
      visit question_path(question)

      within ".question-rating#question_#{question.id}" do
        expect(page).to_not have_css "a[href='#{vote_up_question_path(question)}']"
      end
    end

    scenario "-- unable to vote_up twice in a row", js: true do
      within ".question-rating#question_#{question.id}" do
        find("a[href='#{vote_up_question_path(question)}']").click
        sleep(1)
        # expect(page).to_not have_css "a[href='#{vote_up_question_path(question)}']"
        find("a[href='#{vote_up_question_path(question)}']").click
      end
      expect(page).to have_content I18n.t('activerecord.errors.models.vote.taken')
    end

    scenario "-- able to vote_down", js: true do
      within ".question-rating#question_#{question.id}" do
        expect(find(".rating-value")).to have_content "#{votes_number}"
        find("a[href='#{vote_down_question_path(question)}']").click

        expect(find(".rating-value")).to have_content "#{votes_number - 1}"
      end
    end

    scenario "-- unable to vote_down second time (don't see the button)", js: true do
      create(:vote, votable: question, user: user)
      visit question_path(question)

      within ".question-rating#question_#{question.id}" do
        expect(page).to_not have_css "a[href='#{vote_down_question_path(question)}']"
      end
    end

    scenario "-- unable to vote_down twice in a row", js: true do
      within ".question-rating#question_#{question.id}" do
        find("a[href='#{vote_down_question_path(question)}']").click
        sleep(1)
        # expect(page).to_not have_css "a[href='#{vote_up_question_path(question)}']"
        find("a[href='#{vote_down_question_path(question)}']").click
      end
      expect(page).to have_content I18n.t('activerecord.errors.models.vote.taken')
    end

    # scenario "-- can cancel his vote (have a button and it works properly)"

    # scenario "-- can cancel existent vote and make a new vote"
  end
end
