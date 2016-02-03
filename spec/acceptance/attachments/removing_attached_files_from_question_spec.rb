require_relative '../acceptance_helper'

feature 'REMOVE FILES FROM QUESTION', %q(
  author of the question can remove attached files from the question
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario "- unauthenticated user do not see 'Remove answer' button" do
    visit question_path(question)
    within '.question' do
      expect(page).to have_link 'spec_helper.rb',
                                href: /\A#{"/uploads/attachment/file/"}\d+#{"/spec_helper.rb"}\z/
      expect(page).to_not have_link I18n.t('links.remove_file'),
                                    href: "#{attachment_path(attachment)}"
    end
  end

  scenario "- authenticated but not the question author user do not see 'Remove answer' button" do
    sign_in(other_user)
    visit question_path(question)

    within '.question' do
      expect(page).to have_link 'spec_helper.rb',
                                href: /\A#{"/uploads/attachment/file/"}\d+#{"/spec_helper.rb"}\z/
      expect(page).to_not have_link I18n.t('links.remove_file'),
                                    href: "#{attachment_path(attachment)}"
    end
  end

  scenario "- author successfully remove the attached file", js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      expect(page).to have_link 'spec_helper.rb',
                                href: /\A#{"/uploads/attachment/file/"}\d+#{"/spec_helper.rb"}\z/
      find(
        "a[href='#{attachment_path(attachment)}']", text: /\A#{I18n.t('links.remove_file')}\z/
      ).click
      expect(page).to_not have_link(
        'spec_helper.rb',
        href: /\A#{"/uploads/attachment/file/"}\d+#{"/spec_helper.rb"}\z/
      )
    end
  end
end
