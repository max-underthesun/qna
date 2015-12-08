require_relative '../acceptance_helper'

feature 'EDIT QUESTION', %q(
  only signed in author should have abiliti to edit his question
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:updated_question) { build(:question) }
  given(:invalid_question) { build(:invalid_question) }

  scenario '- unauthenticated user could not edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link(I18n.t('links.edit'))
    end
  end

  scenario '- authenticated user could not edit question of other user' do
    sign_in(other_user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link(I18n.t('links.edit'))
    end
  end

  describe '- author edit his question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario '-- author see the edit link' do
      within '.question' do
        expect(page).to have_link(I18n.t('links.edit'))
      end
    end

    scenario '-- author successfully updated the question with valid attributes', js: true do
      within '.question' do
        click_on I18n.t('links.edit')
        fill_in I18n.t('activerecord.attributes.question.title'), with: updated_question.title
        fill_in I18n.t('activerecord.attributes.question.body'), with: updated_question.body
        click_on I18n.t('questions.form.submit')

        expect(page).to have_content updated_question.title
        expect(page).to have_content updated_question.body
        expect(page).to_not have_selector 'input'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario '-- author could not update question with invalid attributes', js: true do
      within '.question' do
        click_on I18n.t('links.edit')
        fill_in I18n.t('activerecord.attributes.question.title'), with: invalid_question.title
        fill_in I18n.t('activerecord.attributes.question.body'), with: invalid_question.body
        click_on I18n.t('questions.form.submit')

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'input'
        expect(page).to have_selector 'textarea'
      end
    end
  end
end
