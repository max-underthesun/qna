require_relative '../acceptance_helper'

feature 'SUBSCRIBE FOR THE QUESTION', %q(
  authenticated user, but not the author of the question, can subscribe for the
  question to receive notifications about new answers
) do
  given(:user) { create(:user) }
  given(:question_author) { create(:user) }
  given!(:question) { create(:question, user: question_author) }

  describe '- unauthorized user' do
    before { visit question_path(question) }

    scenario '-- can not subscribe  (have no link)' do
      within ".question" do
        # expect(page).to_not have_content 'subscribe'
        # expect(page).to_not have_css "a[href='#{question_subscriptions_path(question)}']"
        expect(page).to_not have_link 'subscribe', href: "#{question_subscriptions_path(question)}"
      end
    end

    scenario '-- can not unsubscribe (have no link)' do
      within ".question" do
        expect(page).to_not have_link 'unsubscribe', href: /\A#{"/subscriptions/"}\d+\z/
      end
    end
  end

  describe "- author of the question" do
    before do
      sign_in(question_author)
      visit question_path(question)
    end

    scenario '-- can not subscribe (have no link)', js: true do
      within ".question" do
        # expect(page).to_not have_content 'subscribe'
        # expect(page).to_not have_css "a[href='#{question_subscriptions_path(question)}']"
        expect(page).to_not have_link 'subscribe', href: "#{question_subscriptions_path(question)}"
      end
    end

    scenario '-- can not unsubscribe (have no link)' do
      within ".question" do
        expect(page).to_not have_link 'unsubscribe', href: /\A#{"/subscriptions/"}\d+\z/
      end
    end
  end

  describe "- non-author of the question" do
    describe "-- if not subscribed" do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '--- can subscribe for the question (have a link)', js: true do
        within ".question" do
          # expect(page).to have_link 'subscribe', href: "#{question_subscriptions_path(question)}"
          find("a[href='#{question_subscriptions_path(question)}']", text: 'subscribe').click

          expect(page).to have_link 'unsubscribe', href: /\A#{"/subscriptions/"}\d+\z/
        end
      end
    end

    describe "--  if subscribed" do
      given!(:subscription) { create(:subscription, user: user, question: question) }

      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '--- can unsubscribe from the question (have a link)', js: true do
        within ".question" do
          # expect(page).to have_content 'unsubscribe'
          # expect(page).to have_css "a[href='#{subscription_path(subscription)}']"
          # expect(page).to have_link 'unsubscribe', href: "#{subscription_path(subscription)}"
          # expect(page).to have_link 'unsubscribe', href: /\A#{"/subscriptions/"}\d+\z/
          find("a[href='#{subscription_path(subscription)}']", text: 'unsubscribe').click

          # expect(page).to have_content 'subscribe'
          # expect(page).to have_css "a[href='#{question_subscriptions_path(question)}']"
          expect(page).to have_link 'subscribe', href: "#{question_subscriptions_path(question)}"
        end
      end
    end
  end
end
