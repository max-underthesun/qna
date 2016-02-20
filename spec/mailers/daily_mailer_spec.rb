require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    # let!(:users) { create_list(:user, 3) }
    # let(:mail) { DailyMailer.digest(user) }
    it "renders the headers"
    it "renders the body"

    # it "renders the headers" do
    #   users.each do |user|
    #     expect(DailyMailer.digest(user).subject).to eq("Digest")
    #     expect(DailyMailer.digest(user).to).to eq(["#{user.email}"])
    #     expect(DailyMailer.digest(user).from).to eq(["from@example.com"])
    #     # expect(mail.subject).to eq("Digest")
    #     # expect(mail.to).to eq(["#{user.email}"])
    #     # expect(mail.from).to eq(["from@example.com"])
    #   end
    # end

    # it "renders the body" do
    #   users.each do |user|
    #     expect(DailyMailer.digest(user).body.encoded).to match("Hi")
    #     # expect(mail.body.encoded).to match("Hi")
    #   end
    # end
  end
end
