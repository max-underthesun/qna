require "rails_helper"

RSpec.describe NewAnswerNotificationMailer, type: :mailer do
  describe "notify_question_author" do
    let(:mail) { NewAnswerNotificationMailer.notify_question_author }

    it "renders the headers" # do
    #   expect(mail.subject).to eq("Notify question author")
    #   expect(mail.to).to eq(["to@example.org"])
    #   expect(mail.from).to eq(["from@example.com"])
    # end

    it "renders the body" # do
    #   expect(mail.body.encoded).to match("Hi")
    # end
  end

  describe "notify_subscribers" do
    let(:mail) { NewAnswerNotificationMailer.notify_subscribers }

    it "renders the headers" # do
    #   expect(mail.subject).to eq("Notify subscribers")
    #   expect(mail.to).to eq(["to@example.org"])
    #   expect(mail.from).to eq(["from@example.com"])
    # end

    it "renders the body" # do
    #   expect(mail.body.encoded).to match("Hi")
    # end
  end
end
