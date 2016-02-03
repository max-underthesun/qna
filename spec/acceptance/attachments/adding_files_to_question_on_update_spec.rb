require_relative '../acceptance_helper'

feature 'ADD FILES TO QUESTION ON UPDATE', %q(
  author of the question can add files to the questions on the question update
  (second update after first file adding is to check if pack
  'AJAX + remotipart + j-helper + cocoon' works well with rendering)
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }
  given(:updated_question) { build(:question) }
  given(:invalid_question) { build(:invalid_question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  describe '- with valid attributes on existed question' do
    scenario '-- update with adding file, then update attributes', js: true do
      within ".question" do
        expect(page).to have_content question.body
        expect(page).to have_link 'spec_helper.rb',
                                  href: '/uploads/attachment/file/1/spec_helper.rb'

        click_on I18n.t('links.edit')
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/spec/rails_helper.rb"
        click_on I18n.t('questions.form.submit')

        expect(page).to_not have_css('input#question_title')
        expect(page).to_not have_css('textarea#question_body')
        expect(page).to have_link 'rails_helper.rb',
                                  href: '/uploads/attachment/file/2/rails_helper.rb'

        click_on I18n.t('links.edit')
        fill_in I18n.t('activerecord.attributes.question.title'), with: updated_question.title
        fill_in I18n.t('activerecord.attributes.question.body'), with: updated_question.body
        click_on I18n.t('questions.form.submit')

        expect(page).to_not have_css('input#question_title')
        expect(page).to_not have_css('textarea#question_body')
        expect(page).to have_content updated_question.title
        expect(page).to have_content updated_question.body
      end
    end

    scenario '-- update with adding file, then update with adding another file', js: true do
      within ".question" do
        expect(page).to have_content question.body
        expect(page).to have_link 'spec_helper.rb',
                                  href: '/uploads/attachment/file/1/spec_helper.rb'

        click_on I18n.t('links.edit')
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/spec/rails_helper.rb"
        click_on I18n.t('questions.form.submit')

        expect(page).to_not have_css('input#question_title')
        expect(page).to_not have_css('textarea#question_body')
        expect(page).to have_link 'rails_helper.rb',
                                  href: '/uploads/attachment/file/2/rails_helper.rb'

        click_on I18n.t('links.edit')
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/README.rdoc"
        click_on I18n.t('questions.form.submit')

        expect(page).to_not have_css('input#question_title')
        expect(page).to_not have_css('textarea#question_body')
        expect(page).to have_link 'README.rdoc',
                                  href: '/uploads/attachment/file/3/README.rdoc'
      end
    end
  end

  describe '- could not update with invalid attributes and got errors' do
    scenario '-- add file on update, try invalid update and see the errors message', js: true do
      within ".question" do
        expect(page).to have_content question.body
        expect(page).to have_link 'spec_helper.rb',
                                  href: /\A#{"/uploads/attachment/file/"}\d+#{"/spec_helper.rb"}\z/
        # expect(page).to have_link 'spec_helper.rb',
        #                           href: '/uploads/attachment/file/1/spec_helper.rb'

        click_on I18n.t('links.edit')
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/spec/rails_helper.rb"
        click_on I18n.t('questions.form.submit')

        click_on I18n.t('links.edit')
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/README.rdoc"
        fill_in I18n.t('activerecord.attributes.question.body'), with: invalid_question.body
        click_on I18n.t('questions.form.submit')

        expect(page).to have_css('textarea#question_body')
        expect(page).to have_content(
          "#{I18n.t('activerecord.attributes.question.body')} "\
          "#{I18n.t('activerecord.errors.messages.blank')}"
        )
      end
    end
  end
end
