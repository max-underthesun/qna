require_relative '../acceptance_helper'

feature 'ADD FILE TO ANSWER', %q(
  author of the answer can add files to the answer to illustrate it
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { build(:answer) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario '- authenticated user creates a question' do
    within '.new-answer-form' do
      fill_in I18n.t('activerecord.attributes.answer.body'), with: answer.body
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on I18n.t('questions.show.submit_answer')
    end

    # expect(page).to have_content I18n.t('confirmations.attachment.create')
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
