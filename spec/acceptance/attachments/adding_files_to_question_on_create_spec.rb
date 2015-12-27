require_relative '../acceptance_helper'

feature 'ADD FILE TO QUESTION ON CREATE', %q(
  author of the question can add files to the questions to illustrate it
) do
  given(:user) { create(:user) }
  given(:question) { build(:question) }
  given(:invalid_question) { build(:invalid_question) }

  before do
    sign_in(user)
    visit new_question_path
  end

  describe '- with valid attributes' do
    scenario '-- authenticated user creates a question without attachment', js: true do
      click_on I18n.t('links.add_file')
      fill_in I18n.t('activerecord.attributes.question.title'), with: question.title
      fill_in I18n.t('activerecord.attributes.question.body'), with: question.body
      click_on I18n.t('questions.form.submit')

      expect(page).to_not have_selector 'input#question_title'
      expect(page).to_not have_selector 'textarea#question_body'
      expect(page).to_not have_content(
        "#{I18n.t('activerecord.models.attachment')}s "\
        "#{I18n.t('activerecord.attributes.attachment.file')} "\
        "#{I18n.t('activerecord.errors.messages.blank')}"
      )
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content I18n.t('confirmations.questions.create')
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

  scenario '- with invalid attributes can not create question and gets error message', js: true do
    fill_in I18n.t('activerecord.attributes.question.title'), with: invalid_question.title
    fill_in I18n.t('activerecord.attributes.question.body'), with: invalid_question.body
    click_on I18n.t('links.add_file')
    attach_file I18n.t('activerecord.attributes.attachment.file'),
                "#{Rails.root}/spec/spec_helper.rb"
    click_on I18n.t('questions.form.submit')

    expect(page).to have_selector 'input#question_title'
    expect(page).to have_selector 'textarea#question_body'
    expect(page).to have_content(
      "#{I18n.t('activerecord.attributes.question.title')} "\
      "#{I18n.t('activerecord.errors.messages.blank')}"
    )
    expect(page).to have_content(
      "#{I18n.t('activerecord.attributes.question.body')} "\
      "#{I18n.t('activerecord.errors.messages.blank')}"
    )
    expect(page).to_not have_content I18n.t('confirmations.questions.create')
  end
end
