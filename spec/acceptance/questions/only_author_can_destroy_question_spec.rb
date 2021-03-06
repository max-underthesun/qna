require_relative '../acceptance_helper'

feature 'DESTROY QUESTION', %q(
  an author has to be able to destroy his questions,
  but to not be able to destroy others questions
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario '- author destroying his question' do
    sign_in(user)

    visit questions_path
    expect(page).to have_content question.title
    click_on I18n.t('links.show')

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    click_on I18n.t('links.destroy')

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
    expect(page).to have_content I18n.t('confirmations.questions.destroy')
  end

  scenario '- user can not destroy question of other user (have no link)' do
    sign_in(other_user)

    visit questions_path
    click_on I18n.t('links.show')
    expect(page).to_not have_link(I18n.t('links.destroy'), href: question_path(question))
  end
end
