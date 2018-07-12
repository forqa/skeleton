describe IOS do
  before :all do
    options = nil
    udid = `xcrun simctl list | grep "iPhone X"`.split('(')[2].sub(') ', '')
    options.define_singleton_method(:udid) { udid }
    options.define_singleton_method(:platform) { 'ios' }
    options.define_singleton_method(:bundle) { 'com.apple.mobilesafari' }
    @ios = IOS.new(options)
  end

  it "should find locator by label" do
    locator = 'awesome locator'
    line = "start of line: #{IOS::LABEL}: '#{locator}' end of line"
    expect(@ios.send(:locator_by_label, line)).to eq(locator)
  end

  it "should not find locator by label" do
    locator = 'awesome locator'
    line = "start of line: #{IOS::LABEL}: \"#{locator}\" end of line"
    expect(@ios.send(:locator_by_label, line)).to be_empty
  end

  it "should find locator by id" do
    locator = 'awesome locator'
    line = "start of line: #{IOS::IDENTIFIER}: '#{locator}' end of line"
    expect(@ios.send(:locator_by_id, line)).to eq(locator)
  end

  it "should not find locator by id" do
    locator = 'awesome locator'
    line = "start of line: #{IOS::IDENTIFIER}: \"#{locator}\" end of line"
    expect(@ios.send(:locator_by_id, line)).to be_empty
  end

  it "should get element type" do
    type = 'Label'
    line = "#{type}, end of line"
    expect(@ios.send(:element_type, line)).to eq(type)
  end

  it "should check udid" do
    expect(@ios.send(:check_udid)).to be_nil
  end

  it "should get page source" do
    expect(@ios.send(:page_source)).not_to be_nil
  end

  it "should check code_generation method" do
    expect(@ios.send(:code_generation,
                      method_name: 'name',
                      locator_type: IOS::ACC_ID,
                      locator_value: "value")).not_to be_nil
  end

  it "should create locator by id" do
    expect(@ios.send(:create_locator_by_id, 'awesome locator')).not_to be_nil
  end

  it "should create locator by label" do
    expect(@ios.send(:create_locator_by_label, 'test', 'label')).not_to be_nil
  end

  it "should skeleton the screen" do
    expect(@ios.skeletoner).to be_truthy
  end
end