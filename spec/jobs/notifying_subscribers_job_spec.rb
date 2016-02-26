require 'rails_helper'

RSpec.describe NotifyingSubscribersJob, type: :job do
  describe "#notify_subscribers" do
    let(:question_author) { create(:user) }
    let(:question) { create(:question, user: question_author) }
    let(:subscriptions) { create_list(:subscription, 3, question: question) }
    let(:answer) { create(:answer, question: question) }

    subject { NotifyingSubscribersJob.perform_now(answer) }

    it "should send an email to every user subscribed to the question after answer create" do
      subscriptions.each do |subscription|
        subscriber = subscription.user
        expect(NewAnswerNotificationMailer)
          .to receive(:notify_subscribers).with(answer, subscriber).and_call_original
      end
      subject
    end
  end
end
