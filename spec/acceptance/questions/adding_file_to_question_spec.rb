require_relative '../acceptance_helper'

feature 'ADD FILE TO QUESTION', %q(
  author of the question can add files to the questions to illustrate it
) do
  given(:user) { create(:user) }
  given(:question) { build(:question) }

  before do
    sign_in(user)
    visit new_question_path
  end

 scenario '- authenticated user creates a question' do
    fill_in I18n.t('activerecord.attributes.question.title'), with: question.title
    fill_in I18n.t('activerecord.attributes.question.body'), with: question.body
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on I18n.t('questions.form.submit')

    # expect(page).to have_content I18n.t('confirmations.attachment.create')
    expect(page).to have_content 'spec_helper.rb'#, href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end
