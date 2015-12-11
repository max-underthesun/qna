require_relative '../acceptance_helper'

feature 'BEST ANSWER', %q(
  only signed in author of question should have abiliti to choose the best answer
  for his question, best answer marked and positioned first in the list of answers
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:other_answer) { create(:answer, question: question, user: other_user) }
  # given(:updated_answer) { build(:answer) }
  # given(:invalid_answer) { build(:invalid_answer) }

  scenario "- unauthenticated user do not see 'Best answer' button" do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_button(I18n.t('buttons.best_answer'))
    end
  end

  scenario "- authenticated but not the question author user do not see 'Best answer' button" do
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_button(I18n.t('buttons.best_answer'))
    end
  end

  describe "- question author can choose the best answer" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "-- author see the 'Best answer' buttons for each answer" do
      answers.each do |answer|
        within ".answer#answer_#{answer.id}" do
          expect(page).to have_button(I18n.t('buttons.best_answer'))
        end
      end
    end

    scenario "-- author can choose any answer as best answer", js: true do
      answers.each do |answer|
        within ".answer#answer_#{answer.id}" do
          click_on I18n.t('buttons.best_answer')
        end
        # sleep(1)
        # save_and_open_page
        expect(page).to have_css('.best-answer')
        within ".best-answer" do
          expect(page).to have_content answer.body
        end
      end
    end

    scenario "-- best answer positioned first in the list of answers", js: true do
      answers.each do |answer|
        within ".answer#answer_#{answer.id}" do
          click_on I18n.t('buttons.best_answer')
        end

        # save_and_open_page
        # expect(page).to have_content answer.body
        # page.should have_selector(".answers:nth-child(1)", text: answer.body)
        # page.find('.answer:nth-of-type(1)', text: answer.body).text

        # expect(page.find('.answer:nth-of-type(1)')).to have_css('.best-answer')
        expect(page.find('.answer:nth-of-type(1)')).to have_content answer.body
      end
    end
  end
end
