require_relative '../acceptance_helper'

feature 'EDIT ANSWER', %q(
  only signed in author should have abiliti to edit his answer
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:other_answer) { create(:answer, question: question, user: other_user) }
  given(:updated_answer) { build(:answer) }
  given(:invalid_answer) { build(:invalid_answer) }

  scenario '- unauthenticated user do not see edit answer link' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link(I18n.t('links.edit'))
    end
  end

  describe '- authenticated user could not edit question of other user' do
    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario '-- can see edit link for own answer' do
      within "#answer_#{other_answer.id}" do
        expect(page).to have_link(I18n.t('links.edit'))
      end
    end

    scenario '-- do not see edit link for other user answer' do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_link(I18n.t('links.edit'))
      end
    end
  end

  describe '- author can edit his question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario '-- author see the edit link' do
      within "#answer_#{answer.id}" do
        expect(page).to have_link(I18n.t('links.edit'))
      end
    end

    scenario '-- author successfully updated the answer with valid attributes', js: true do
      within "#answer_#{answer.id}" do
        click_on I18n.t('links.edit')
        fill_in I18n.t('activerecord.attributes.answer.body'), with: updated_answer.body
        click_on I18n.t('answers.form.update_answer')

        expect(page).to have_content updated_answer.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario '-- author could not updated the answer with invalid attributes', js: true do
      within "#answer_#{answer.id}" do
        click_on I18n.t('links.edit')
        fill_in I18n.t('activerecord.attributes.answer.body'), with: invalid_answer.body
        click_on I18n.t('answers.form.update_answer')

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
    end
  end
end
