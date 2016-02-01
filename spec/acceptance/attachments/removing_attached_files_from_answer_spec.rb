require_relative '../acceptance_helper'

feature 'REMOVE FILES FROM ANSWER', %q(
  author of the answer can remove attached files from it
) do
  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: question_author) }
  given!(:answer) { create(:answer, question: question, user: answer_author) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario "- unauthenticated user do not see 'Remove answer' button" do
    visit question_path(question)
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb' #, href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to_not have_link I18n.t('links.remove_file'),
                                    href: "#{attachment_path(attachment)}"
    end
  end

  scenario "- authenticated but not the question author user do not see 'Remove answer' button" do
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb' #, href: '/uploads/attachment/file/2/spec_helper.rb'
      expect(page).to_not have_link I18n.t('links.remove_file'),
                                    href: "#{attachment_path(attachment)}"
    end
  end

  scenario "- author successfully remove the attached file", js: true do
    sign_in(answer_author)
    visit question_path(question)

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'#, href: '/uploads/attachment/file/3/spec_helper.rb'
      find(
        "a[href='#{attachment_path(attachment)}']", text: /\A#{I18n.t('links.remove_file')}\z/
      ).click
      expect(page).to_not have_link 'spec_helper.rb' #, href: '/uploads/attachment/file/3/spec_helper.rb'
    end
  end
end
