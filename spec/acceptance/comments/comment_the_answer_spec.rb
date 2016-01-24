require_relative '../acceptance_helper'

feature 'COMMENT THE ANSWER', %q(
  authenticated user can make a comment to the question to specifiy details
) do
  comments_number = 5

  given(:user) { create(:user) }
  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given!(:question) { create(:question, user: question_author) }
  given!(:answer) { create(:answer, question: question, user: answer_author) }
  given!(:comments) { create_list(:comment, comments_number, commentable: answer) }
  given(:comment) { build(:comment, commentable: answer) }

  describe "- unauthorized user" do
    before { visit question_path(question) }

    scenario "-- see all the comments for the answer" do
      within ".answers .answer #comments-for-answer-#{answer.id}" do
        comments.each do |comment|
          expect(page).to have_content comment.body
          expect(page).to have_content comment.user.email
        end
      end
    end

    scenario "-- unable to comment a question (don't have a form)", js: true do
      within ".answers .answer #new-comment-for-answer-#{answer.id}" do
        find("a[href='']", text: I18n.t('comments.new_comment')).click

        expect(page).to_not have_css('textarea#comment_body')
      end

      expect(page).to have_content('You have to sign in for comment the answer')
    end
  end

  describe "- signed in user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "-- see all the comments for the answer" do
      within ".answers .answer #comments-for-answer-#{answer.id}" do
        comments.each do |comment|
          expect(page).to have_content comment.body
          expect(page).to have_content comment.user.email
        end
      end
    end

    scenario "-- see the form for a new comment", js: true do
      within ".answers .answer #new-comment-for-answer-#{answer.id}" do
        find("a[href='']", text: I18n.t('comments.new_comment')).click
        expect(page).to have_css('textarea#comment_body')
      end
    end

    scenario "-- able to add a new comment", js: true do
      within ".answers .answer #new-comment-for-answer-#{answer.id}" do
        find("a[href='']", text: I18n.t('comments.new_comment')).click
        fill_in I18n.t('activerecord.attributes.comment.body'), with: comment.body
        click_on I18n.t('comments.submit_comment')
      end

      within(".comments#comments-for-answer-#{answer.id}") do
        expect(page).to have_content comment.body
      end

      expect(page).to have_content I18n.t('confirmations.comment.create')
      expect(current_path).to eq question_path(question)
    end
  end
end
