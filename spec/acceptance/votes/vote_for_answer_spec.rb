require_relative '../acceptance_helper'

feature 'VOTE FOR THE ANSWER', %q(
  authenticated user, but not the author of the answer can vote for the
  answer to increase or decrease answer rating
) do
  votes_number = 5

  given(:user) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:question_author) { create(:user) }
  given!(:question) { create(:question, user: question_author) }
  given!(:answer) { create(:answer, user: answer_author, question: question) }
  given!(:votes) { create_list(:vote, votes_number, votable: answer) }

  describe "- unauthorized user" do
    before { visit question_path(question) }

    scenario "-- see the rating of the answer in the answer show view" do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(page).to have_content I18n.t('common.rating')
        expect(page).to have_content "#{answer.rating}"
      end
    end

    scenario "-- unable to vote_up", js: true do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(find(".rating-value")).to have_content "#{votes_number}"
        find("a[href='#{vote_up_answer_path(answer)}']").click

        expect(find(".rating-value")).to have_content "#{votes_number}"
      end

      expect(page).to have_content I18n.t('devise.failure.unauthenticated')
    end

    scenario "-- unable to vote_down", js: true do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(find(".rating-value")).to have_content "#{votes_number}"
        find("a[href='#{vote_down_answer_path(answer)}']").click

        expect(find(".rating-value")).to have_content "#{votes_number}"
      end

      expect(page).to have_content I18n.t('devise.failure.unauthenticated')
    end

    scenario "-- unable to cancel any vote: do not see the button", js: true do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(page).to_not have_css "a[href='#{vote_destroy_answer_path(answer)}']"
      end
    end
  end

  describe "- author of the answer" do
    before do
      sign_in(answer_author)
      visit question_path(question)
    end

    scenario "-- see the rating of the answer in the answer show view" do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(page).to have_content I18n.t('common.rating')
        expect(page).to have_content "#{answer.rating}"
      end
    end

    scenario "-- unable to vote_up or vote_down (do not see the buttons)", js: true do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(page).to_not have_css "a[href='#{vote_up_answer_path(answer)}']"
        expect(page).to_not have_css "a[href='#{vote_down_answer_path(answer)}']"
      end
    end

    scenario "-- unable to cancel any vote - do not see the button", js: true do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(page).to_not have_css "a[href='#{vote_destroy_answer_path(answer)}']"
      end
    end
  end

  describe "- non-author of the answer" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "-- see the rating of the answer in the answer show view" do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(page).to have_content I18n.t('common.rating')
        expect(page).to have_content "#{answer.rating}"
      end
    end

    scenario "-- able to vote_up", js: true do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(find(".rating-value")).to have_content "#{votes_number}"
        find("a[href='#{vote_up_answer_path(answer)}']").click

        expect(find(".rating-value")).to have_content "#{votes_number + 1}"
      end
    end

    scenario "-- unable to vote_up second time (don't see the button)", js: true do
      create(:vote, votable: answer, user: user)
      visit question_path(question)

      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(page).to_not have_css "a[href='#{vote_up_answer_path(answer)}']"
      end
    end

    scenario "-- unable to vote_up twice in a row (button will hide)", js: true do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        find("a[href='#{vote_up_answer_path(answer)}']").click
        sleep(1)
        expect(page).to_not have_css "a[href='#{vote_up_answer_path(answer)}']"
      end
    end

    scenario "-- able to vote_down", js: true do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(find(".rating-value")).to have_content "#{votes_number}"
        find("a[href='#{vote_down_answer_path(answer)}']").click

        expect(find(".rating-value")).to have_content "#{votes_number - 1}"
      end
    end

    scenario "-- unable to vote_down second time (don't see the button)", js: true do
      create(:vote, votable: answer, user: user)
      visit question_path(question)

      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(page).to_not have_css "a[href='#{vote_down_answer_path(answer)}']"
      end
    end

    scenario "-- unable to vote_down twice in a row (button will hide)", js: true do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        find("a[href='#{vote_down_answer_path(answer)}']").click
        sleep(1)
        expect(page).to_not have_css "a[href='#{vote_down_answer_path(answer)}']"
      end
    end

    scenario "-- if voted have a button to cancel vote" do
      create(:vote, votable: answer, user: user)
      visit question_path(question)

      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(page).to have_css "a[href='#{vote_destroy_answer_path(answer)}']"
      end
    end

    scenario "-- if voted can cancel vote", js: true do
      create(:vote, votable: answer, user: user)
      visit question_path(question)

      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(find(".rating-value")).to have_content "#{votes_number + 1}"
        find("a[href='#{vote_destroy_answer_path(answer)}']").click
        expect(find(".rating-value")).to have_content "#{votes_number}"
      end
    end

    scenario "-- unable to cancel vote if not voted (don't see the button)", js: true do
      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(page).to_not have_css "a[href='#{vote_destroy_answer_path(answer)}']"
      end
    end

    scenario "-- unable to cancel vote twice in a row (button will hide)", js: true do
      create(:vote, votable: answer, user: user)
      visit question_path(question)

      within ".answer-rating#rating_for-answer_#{answer.id}" do
        expect(find(".rating-value")).to have_content "#{votes_number + 1}"
        find("a[href='#{vote_destroy_answer_path(answer)}']").click
        expect(find(".rating-value")).to have_content "#{votes_number}"
        sleep(1)
        expect(page).to_not have_css "a[href='#{vote_destroy_answer_path(answer)}']"
      end
    end
  end
end
