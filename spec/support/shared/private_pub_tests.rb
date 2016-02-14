shared_examples_for "PrivatePub Publishable" do
  it 'should publish resource after create' do
    expect(PrivatePub).to receive(:publish_to).with(path, hash_including(:question, :author))
    subject
  end
end