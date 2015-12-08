require_relative '../acceptance_helper'

feature 'DESTROY ANSWER', %q(
  an author has to be able to destroy his answers,
  but to not be able to destroy others answers
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario '- author destroying his answer successfully', js: true do
    sign_in(user)
    visit question_path(question)

    within ".answer#answer_#{answer.id}" do
      expect(page).to have_content answer.body
      find("a[href='#{answer_path(answer)}']", text: /\A#{I18n.t('links.destroy')}\z/).click
    end

    expect(page).to_not have_content answer.body
    expect(page).to have_content I18n.t('confirmations.answers.destroy')
  end

  scenario '- user trying to destroy answer of other user with no success' do
    sign_in(other_user)

    visit questions_path
    click_on I18n.t('links.show')
    expect(page).to_not have_link(I18n.t('links.destroy'), href: answer_path(answer))
  end
end
