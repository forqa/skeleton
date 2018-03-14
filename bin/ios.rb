class IOS
  @@TIMESTAMP = (Time.now.to_f * 1000).to_i
  @@ID = 'AccessibilityId'
  @@LABEL = 'label'
  @@NSPREDICATE = 'iOSNsPredicateString'
  @@IOS_ELEMENT_TYPES = [
    'Other', 'Button', 'Switch', 'TextView', 'TextField', 'Table',
    'Image', 'SecureTextField', 'StaticText', 'NavigationBar', 'Cell'
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
    id_locators = {}
    nspredicate_locators = {}
    get_page_source.each_line do |line|
      break if line.include?(' StatusBar, ')
      element_type = get_element_type(line)
      if @@IOS_ELEMENT_TYPES.include?(element_type)
        locator = get_locator_via_id(line)
        locator.empty? || id_locators[locator] = element_type
        locator = get_locator_via_label(line)
        locator.empty? || nspredicate_locators[locator] = element_type
      end
    end

    id_locators.each_key do |locator|
      method_name = camel_style(locator.strip)
      puts method_name
      create_page_objects(method_name, @@ID, locator)
    end

    i = 0
    nspredicate_locators.each do |locator, type|
      i += 1
      method_name = type + i.to_s
      method_name[0] = method_name[0].downcase
      create_page_objects(method_name, @@NSPREDICATE, locator)
    end
  end

  private

  def snake_style(method_name) #: FIXME
    method_name[0] = method_name[0].downcase
    method_name.each_char.with_index do |char, char_i|
      if char == ' '
        method_name[char_i] = '_'
      elsif /[A-Z]/.match(method_name[char_i + 1])
        method_name[char_i + 2] = method_name[char_i + 1].downcase
        method_name[char_i + 1] = '_'
      end
    end
  end

  def camel_style(method_name)
    space_i = 0
    method_name[0] = method_name[0].downcase
    method_name.each_char.with_index do |char, char_i|
      if char == ' '
        method_name[char_i - space_i] = ''
        method_name[char_i - space_i] =
          method_name[char_i - space_i].capitalize
        space_i += 1
      end
    end
  end

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

  def get_locator_via_id(line)
    locator = /identifier: '(.*?)'/.match(line)
    locator.nil? ? '' : locator[1]
  end

  def get_locator_via_label(line)
    locator = /label: '(.*?)'/.match(line)
    locator.nil? ? '' : locator[1]
  end

  def get_java_method(name, locator_type, value)
    if locator_type == @@ID
      "By #{name}() {\n\treturn " +
        "MobileBy.#{locator_type}(\"#{value}\");\n}\n\n"
    else
      "By #{name}() {\n\treturn " +
        "MobileBy.#{locator_type}(\"label like \'#{value}\'\");\n}\n\n"
    end
  end

  def create_page_objects(name, locator_type, value)
    File.open("#{@dir}/#{@platform}_#{@@TIMESTAMP}.java", 'a') do |f|
      f.write(get_java_method(name, locator_type, value))
    end
  end
end