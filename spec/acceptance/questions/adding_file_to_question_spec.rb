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

  describe '- with valid attributes' do
    scenario '-- authenticated user creates a question with attachment' do
      fill_in I18n.t('activerecord.attributes.question.title'), with: question.title
      fill_in I18n.t('activerecord.attributes.question.body'), with: question.body
      click_on I18n.t('links.add_file')
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on I18n.t('questions.form.submit')

      expect(page).to have_link 'spec_helper.rb',
                                href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    scenario '-- authenticated user creates a question with several files attached', js: true do
      fill_in I18n.t('activerecord.attributes.question.title'), with: question.title
      fill_in I18n.t('activerecord.attributes.question.body'), with: question.body
      click_on I18n.t('links.add_file')
      all('input[type="file"]')[0].set "#{Rails.root}/spec/spec_helper.rb"
      click_on I18n.t('links.add_file')
      all('input[type="file"]')[1].set "#{Rails.root}/spec/rails_helper.rb"
      click_on I18n.t('questions.form.submit')

      expect(page).to have_link 'spec_helper.rb',
                                href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb',
                                href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end
