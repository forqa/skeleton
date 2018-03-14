class IOS
  @@IOS_ELEMENT_TYPES = [
    'Other', 'Button', 'StaticText', 'Switch', 'TextView', 'TextField', 'Image'
  ]

  attr_accessor :platform, :udid, :bundle_id, :ios_sim, :dir

  def initialize(options)
    self.platform = options[:platform]
    self.udid = options[:udid]
    self.ios_sim = options[:ios_sim]
    self.bundle_id = options[:bundle_id]
    self.dir = options[:dir]
  end

  def skeletoner
    locators = {}
    i = 0
    get_page_source.each_line do |line|
      element_type = get_element_type(line)
      if @dir.include?(element_type)
        locator = get_element_locator(line)
        locators[locator] = element_type if not locator.empty?
      end
    end

    locators.each do |el, type|
      create_page_objects(el.strip, 'AccessibilityId', el)
    end
  end

  private

  def get_page_source
    ios_arch = @ios_sim ? 'iOS Simulator' : 'iOS'
    %x(xcodebuild test \
      -project Skeleton.xcodeproj \
      -scheme Skeleton \
      -destination 'platform=#{ios_arch},id=#{@udid}' \
      bundle_id="#{@bundle_id}" | \
      awk '/start_grep_tag/,/end_grep_tag/')
  end

  def get_element_type(line)
    line_first_word = line.split.first
    line_first_word.nil? ? '' : line_first_word.chomp(',')
  end

  def get_element_locator(line)
    if line.include?('identifier')
      /identifier: '(.*?)'/.match(line)[1]
    elsif line.include?('label')
      /label: '(.*?)'/.match(line)[1]
    else
      ''
    end
  end

  def get_java_method(name, locator_type, value)
    "By #{name}() {\n\treturn MobileBy.#{locator_type}(\"#{value}\");\n}\n\n"
  end

  def create_page_objects(name, locator_type, value)
    timestamp = (Time.now.to_f * 1000).to_i
    File.open("#{@dir}/#{@platform}_#{timestamp}.java", 'a') do |f|
      f.write(get_java_method(name, locator_type, value))
    end
  end
end