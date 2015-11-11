require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }

  it 'validates presence of body' do
    expect(build(:question, body: nil)).to_not be_valid
  end
end
