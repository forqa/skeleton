describe Base do
  before :all do
    @base = Base.new
  end

  xit "should snake incoming string" do
    expect(@base.send(:snake_style, 'TEST')).to eq('test')
    expect(@base.send(:snake_style, 'te_st')).to eq('te_st')
    expect(@base.send(:snake_style, 'Te_St')).to eq('te_st')
    expect(@base.send(:snake_style, 'TeSt')).to eq('te_st')
    expect(@base.send(:snake_style, 'tESt')).to eq('t_e_st')
    expect(@base.send(:snake_style, 'te  st')).to eq('te_st')
    expect(@base.send(:snake_style, 't*!@(){}e:;#$^s[].,\'"t')).to eq('test')
  end

  it "should camel incoming string" do
    expect(@base.send(:camel_style, 'teSt')).to eq('teSt')
    expect(@base.send(:camel_style, 'te_st')).to eq('teSt')
    expect(@base.send(:camel_style, 'TeSt')).to eq('teSt')
    expect(@base.send(:camel_style, 'te  st')).to eq('teSt')
    expect(@base.send(:camel_style, 't*!@(){}e:;#$^s[].,\'"t')).to eq('tEST')
  end

  it "should create logger" do
    expect(@base.log).not_to eq(nil)
  end

  it "should create base folders" do
    @base.precondition
    expect(File.directory?(Base::PAGE_OBJECTS_FOLDER)).to be true
    expect(File.directory?(Base::ATTACHMENTS_FOLDER)).to be true
  end

  it "should increment locator id" do
    expect(@base.send(:increment_locator_id)).to eq(1)
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

  it "should have correct root_dir" do
    expect(Base::ROOT_DIR).to include(`gem environment gemdir`.strip)
  end
end