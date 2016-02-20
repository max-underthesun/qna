require 'rails_helper'

RSpec.describe CalculateReputationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  subject { CalculateReputationJob.perform_now(question) }

  it 'should calculate reputation after creating' do
    # expect { CalculateReputationJob.perform_now(question) }.to change(user, :reputation).by(5)

    expect(Reputation).to receive(:calculate).with(question)
    subject
  end

  it 'should save user reputation' do
    # expect(Reputation).to receive(:calculate).with(question).and_return(5)
    allow(Reputation).to receive(:calculate).with(question).and_return(5)
    # expect { CalculateReputationJob.perform_now(question) }.to change(user, :reputation).by(5)
    expect { subject }.to change(user, :reputation).by(5)
  end
end
