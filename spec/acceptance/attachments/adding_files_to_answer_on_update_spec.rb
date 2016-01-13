require_relative '../acceptance_helper'

feature 'ADD FILES TO ANSWER ON UPDATE', %q{
  author of the answer can add files to the answer on the answer update
  (second update after first file adding is to check if pack
  'AJAX + remotipart + j-helper + cocoon' works well with rendering)
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:updated_answer) { build(:answer) }

  before { sign_in(user) }

  describe '- with valid attributes add file on update after creation' do
    given(:answer) { build(:answer) }

    before { visit question_path(question) }

    scenario '-- creates an answer with file attached and then update it', js: true do
      within '.new-answer-form' do
        fill_in I18n.t('activerecord.attributes.answer.body'), with: answer.body
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/spec/spec_helper.rb"
        click_on I18n.t('questions.show.submit_answer')
      end

      within '.answers' do
        expect(page).to have_content answer.body
        expect(page).to have_link 'spec_helper.rb',
                                  href: '/uploads/attachment/file/1/spec_helper.rb'

        click_on I18n.t('links.edit')
        fill_in I18n.t('activerecord.attributes.answer.body'), with: updated_answer.body
        click_on I18n.t('answers.form.update_answer')

        expect(page).to have_content updated_answer.body
        expect(page).to_not have_css('textarea#answer_body')
      end
    end

    scenario '-- creates an answer with file and then attach new file on update', js: true do
      within '.new-answer-form' do
        fill_in I18n.t('activerecord.attributes.answer.body'), with: answer.body
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/spec/spec_helper.rb"
        click_on I18n.t('questions.show.submit_answer')
      end

      within '.answers' do
        expect(page).to have_content answer.body
        expect(page).to have_link 'spec_helper.rb',
                                  href: '/uploads/attachment/file/1/spec_helper.rb'

        click_on I18n.t('links.edit')
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/spec/rails_helper.rb"
        click_on I18n.t('answers.form.update_answer')

        expect(page).to_not have_css('textarea#answer_body')
        expect(page).to have_link 'rails_helper.rb',
                                  href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end
  end

  describe '- with valid attributes add file to the existing answer, then update again' do
    given!(:answer) { create(:answer, question: question, user: user) }
    given!(:attachment) { create(:attachment, attachable: answer) }

    before { visit question_path(question) }

    scenario '-- upate with adding file, then update the body', js: true do
      within "#answer_#{answer.id}" do
        expect(page).to have_content answer.body
        expect(page).to have_link 'spec_helper.rb',
                                  href: '/uploads/attachment/file/1/spec_helper.rb'

        click_on I18n.t('links.edit')
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/spec/rails_helper.rb"
        click_on I18n.t('answers.form.update_answer')

        click_on I18n.t('links.edit')
        fill_in I18n.t('activerecord.attributes.answer.body'), with: updated_answer.body
        click_on I18n.t('answers.form.update_answer')

        expect(page).to have_content updated_answer.body
        expect(page).to_not have_css('textarea#answer_body')
      end
    end

    scenario '-- update with adding file, then update with adding another file', js: true do
      within "#answer_#{answer.id}" do
        expect(page).to have_content answer.body
        expect(page).to have_link 'spec_helper.rb',
                                  href: '/uploads/attachment/file/1/spec_helper.rb'

        click_on I18n.t('links.edit')
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/spec/rails_helper.rb"
        click_on I18n.t('answers.form.update_answer')

        expect(page).to_not have_selector 'textarea'
        expect(page).to have_link 'rails_helper.rb',
                                  href: '/uploads/attachment/file/2/rails_helper.rb'

        click_on I18n.t('links.edit')
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/README.rdoc"
        click_on I18n.t('answers.form.update_answer')

        expect(page).to_not have_css('textarea#answer_body')
        expect(page).to have_link 'README.rdoc',
                                  href: '/uploads/attachment/file/3/README.rdoc'
      end
    end
  end

  describe '- could not update with invalid attributes and got errors' do
    given!(:answer) { create(:answer, question: question, user: user) }
    given!(:attachment) { create(:attachment, attachable: answer) }
    given(:invalid_answer) { build(:invalid_answer) }

    before { visit question_path(question) }

    scenario '-- add file on update, try invalid update and see the errors message', js: true do
      within "#answer_#{answer.id}" do
        expect(page).to have_content answer.body
        expect(page).to have_link 'spec_helper.rb',
                                  href: '/uploads/attachment/file/1/spec_helper.rb'

        click_on I18n.t('links.edit')
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/spec/rails_helper.rb"
        click_on I18n.t('answers.form.update_answer')

        click_on I18n.t('links.edit')
        click_on I18n.t('links.add_file')
        attach_file I18n.t('activerecord.attributes.attachment.file'),
                    "#{Rails.root}/README.rdoc"
        fill_in I18n.t('activerecord.attributes.answer.body'), with: invalid_answer.body
        click_on I18n.t('answers.form.update_answer')

        expect(page).to have_css('textarea#answer_body')
        expect(page).to have_content(
          "#{I18n.t('activerecord.attributes.answer.body')} "\
          "#{I18n.t('activerecord.errors.messages.blank')}"
        )
      end
    end
  end
end
