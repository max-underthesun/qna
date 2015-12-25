require_relative '../acceptance_helper'

feature 'ADD FILES TO ANSWER ON CREATE', %q(
  author of the answer can add files to the answer to illustrate it
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { build(:answer) }
  given(:invalid_answer) { build(:invalid_answer) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  describe '- with valid attributes' do
    scenario '- authenticated user creates an answer with file attached', js: true do
      within '.new-answer-form' do
        fill_in I18n.t('activerecord.attributes.answer.body'), with: answer.body
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/spec/spec_helper.rb"
        click_on I18n.t('questions.show.submit_answer')
      end

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb',
                                  href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end

    scenario '- authenticated user creates an answer with several files attached', js: true do
      within '.new-answer-form' do
        fill_in I18n.t('activerecord.attributes.answer.body'), with: answer.body
        click_on I18n.t('links.add_file')
        all('input[type="file"]')[0].set "#{Rails.root}/spec/spec_helper.rb"
        click_on I18n.t('links.add_file')
        all('input[type="file"]')[1].set "#{Rails.root}/spec/rails_helper.rb"

        click_on I18n.t('questions.show.submit_answer')
      end

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb',
                                  href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb',
                                  href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end
  end

  scenario '- with invalid attributes can not create answer and gets error message', js: true do
    within '.new-answer-form' do
      fill_in I18n.t('activerecord.attributes.answer.body'), with: invalid_answer.body
      click_on I18n.t('links.add_file')
      attach_file I18n.t('activerecord.attributes.attachment.file'),
                  "#{Rails.root}/spec/spec_helper.rb"
      click_on I18n.t('questions.show.submit_answer')

      expect(page).to have_content(
        "#{I18n.t('activerecord.attributes.answer.body')} "\
        "#{I18n.t('activerecord.errors.messages.blank')}"
      )
    end
  end
end
