describe Skeleton do
  it "should include VERSION const" do
    expect(Skeleton::VERSION).not_to be_nil
  end

  it "should include GEM_NAME const" do
    expect(Skeleton::GEM_NAME).not_to be_nil
  end
end