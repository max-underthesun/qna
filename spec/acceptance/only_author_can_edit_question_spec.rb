require_relative 'acceptance_helper'

feature 'EDIT QUESTION', %q(
  author should have abiliti to edit his question
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario '- unauthenticated user could not edit question' do
    visit question_path(question)
    expect(page).to_not have_link(I18n.t('links.edit'), href: edit_question_path(question))
  end

  scenario '- authenticated user could not edit question of other user' do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_link(I18n.t('links.edit'), href: edit_question_path(question))
  end

  describe '- author successfully edit his question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario '-- author see the edit link' do
      expect(page).to have_link(I18n.t('links.edit'))
    end

    scenario '-- author fill and submit the form' do
      click_on I18n.t('links.edit')
      fill_in I18n.t('activerecord.attributes.question.title'), with: question.title
      fill_in I18n.t('activerecord.attributes.question.body'), with: question.body
      click_on I18n.t('questions.form.submit')
    end
  end
end
