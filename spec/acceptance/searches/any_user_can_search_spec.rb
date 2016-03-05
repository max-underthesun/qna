require_relative '../sphinx_helper'

feature 'CAN SEARCH THROUGH QnA RESOURCES', %q(
  any user can search through the questions, answers, comments and users:
  looking all at once or only through the choosen one
) do
  given!(:questions) { create_list(:question, 5) }
  given!(:answers) { create_list(:answer, 5) }
  given!(:comments) { create_list(:comment, 5, commentable: question) }
  given!(:users) { create_list(:user, 5) }

  given(:question) { questions.sample }
  given(:answer) { answers.sample }
  given(:comment) { comments.sample }
  given(:user) { users.sample }

  before do
    index
    visit questions_path
  end

  %w(question answer comment user).each do |resource|
    scenario "- user can find any #{resource} in all resources", js: true do
      vars = { 'question' => question, 'answer' => answer, 'comment' => comment, 'user' => user }
      query = resource == 'user' ? vars[resource].email : vars[resource].body
      within '.search' do
        # expect(page).to have_css('input[value="Search"]')
        # expect(page).to have_button "Search"
        expect(page).to have_css("input#query")

        fill_in 'query', with: query
        click_button "Search"
      end

      within '.search-result' do
        expect(page).to have_content query
      end
    end
  end

  scenario '- user can find a question in questions', js: true do
    within '.search' do
      expect(page).to have_css("input#query")
      expect(page).to have_css("select#scope")

      fill_in 'query', with: question.body
      select('Questions', from: 'scope')
      click_button "Search"
    end

    within '.search-result' do
      expect(page).to have_content question.body
      expect(page).to have_content question.title
      expect(page).to have_content question.user.email
    end
  end

  scenario '- user can find an answer in answers', js: true do
    within '.search' do
      expect(page).to have_css("input#query")
      expect(page).to have_css("select#scope")

      fill_in 'query', with: answer.body
      select('Answers', from: 'scope')
      click_button "Search"
    end

    within '.search-result' do
      expect(page).to have_content answer.body
      expect(page).to have_content answer.user.email
    end
  end

  scenario '- user can find a comment in comments', js: true do
    within '.search' do
      expect(page).to have_css("input#query")
      expect(page).to have_css("select#scope")

      fill_in 'query', with: comment.body
      select('Comments', from: 'scope')
      click_button "Search"
    end

    within '.search-result' do
      expect(page).to have_content comment.body
      expect(page).to have_content comment.user.email
    end
  end

  scenario '- user can find a user in users', js: true do
    within '.search' do
      expect(page).to have_css("input#query")
      expect(page).to have_css("select#scope")

      fill_in 'query', with: user.email
      select('Users', from: 'scope')
      click_button "Search"
    end

    within '.search-result' do
      expect(page).to have_content user.email
    end
  end
end
