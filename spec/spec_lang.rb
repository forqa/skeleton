describe Base do
  before :all do
    @base = Base.new
  end

  it "should generate java code for ios" do
    expect(@base.send(:java, 'name', IOS::ACC_ID, 'value')).not_to be_nil
  end

  it "should generate ruby code for ios" do
    expect(@base.send(:ruby, 'name', IOS::ACC_ID, 'value')).not_to be_nil
  end

  it "should generate java code for android" do
    expect(@base.send(:java, 'name', Android::ID, 'value')).not_to be_nil
  end
end