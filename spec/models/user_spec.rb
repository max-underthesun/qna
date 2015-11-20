require 'rails_helper'

RSpec.describe User do
  let!(:user) { create(:user) }

  it 'validates uniqueness of email' do
    expect(build(:user, email: user.email)).to_not be_valid
    expect(build(:user, email: user.email.upcase)).to_not be_valid
  end

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_length_of(:password).is_at_least(8) }
end
