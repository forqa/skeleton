class IOS < Base
  ACC_ID = {
    java: :AccessibilityId,
    ruby: :accessibility_id
  }.freeze
  NSPREDICATE = {
    java: :iOSNsPredicateString,
    ruby: :predicate
  }.freeze
  IDENTIFIER = 'identifier'.freeze
  LABEL = 'label'.freeze
  XCRESULTS_FOLDER = "#{ROOT_DIR}/XCResults".freeze
  XCODEPROJ_FOLDER = "#{ROOT_DIR}/xcodeproj".freeze

  attr_accessor :platform, :udid, :bundle_id

  def initialize(options)
    self.platform = options.platform
    self.udid = options.udid
    self.bundle_id = options.bundle
    @language = Language.new
  end

  def skeletoner
    log.info('We starting to skeleton your screen 🚀')
    check_udid
    page_source
    create_page_objects
    save_screenshot
    save(code: page_source)
    log.info('We successfully skeletoned your screen 👻')
  end

  private

  def create_locator(line)
    locator_by_id = locator_by_id(line)
    locator_by_label = locator_by_label(line)
    if !locator_by_id.empty?
      create_locator_by_id(locator_by_id)
    elsif !locator_by_label.empty?
      type = element_type(line)
      create_locator_by_label(locator_by_label, type)
    end
  end

  def create_locator_by_id(locator)
    method_name = locator.strip
    code_generation(method_name: method_name,
                    locator_type: ACC_ID,
                    locator_value: locator)
  end

  def create_locator_by_label(text, type)
    method_name = "#{type}#{increment_locator_id}"
    locator = "#{LABEL} like '#{text}'"
    code_generation(method_name: method_name,
                    locator_type: NSPREDICATE,
                    locator_value: locator)
  end

  def create_page_objects
    log.info('Generation page objects for your awesome language 💪')
    page_source.each_line do |line|
      break if line.include?(' StatusBar, ')
      next  if line.include?('Application, ')
      create_locator(line)
    end
  end

  def element_type(line)
    line_first_word = line.split.first
    line_first_word.nil? ? '' : line_first_word.chomp(',')
  end

  def locator_by_id(line)
    locator = /#{IDENTIFIER}: '(.*?)'/.match(line)
    locator.nil? ? '' : locator[1]
  end

  def locator_by_label(line)
    locator = /#{LABEL}: '(.*?)'/.match(line)
    locator.nil? ? '' : locator[1]
  end

  def code_generation(method_name:, locator_type:, locator_value:)
    java = @language.java(camel_method_name: camel_style(method_name),
                          locator_type: locator_type,
                          locator_value: locator_value)
    ruby = @language.ruby(snake_method_name: snake_style(method_name),
                          locator_type: locator_type,
                          locator_value: locator_value)
    save(code: java, format: Language::JAVA)
    save(code: ruby, format: Language::RUBY)
  end

  def page_source
    if @page_source.nil?
      log.info('Getting screen source tree ⚒')
      FileUtils.rm_rf(XCRESULTS_FOLDER)
      start_grep = 'start_grep_tag'
      end_grep = 'end_grep_tag'
      ios_arch = @simulator ? 'iOS Simulator' : 'iOS'
      @page_source = `xcodebuild test \
          -project #{XCODEPROJ_FOLDER}/Skeleton.xcodeproj \
          -scheme Skeleton \
          -destination 'platform=#{ios_arch},id=#{@udid}' \
          -resultBundlePath #{XCRESULTS_FOLDER} \
          bundle_id="#{@bundle_id}" | \
          awk '/#{start_grep}/,/#{end_grep}/'`
      @page_source.slice!(start_grep)
      @page_source.slice!(end_grep)
      if @page_source.empty?
        log.fatal("Something went wrong.\n" \
            "1. Try to sign Skeleton in #{XCODEPROJ_FOLDER}\n" \
            "2. Check in the iOS settings that Skeleton is trust developer.\n" \
            '3. Check your app bundle_id')
        raise
      end
      log.info('Successfully getting Screen Source Tree 🔥')
    end
    @page_source
  end

  def check_udid
    return unless @simulator.nil?
    log.info('Checking iOS UDID 👨‍💻')
    simulators = `xcrun simctl list`
    @simulator = simulators.include?(@udid)
    return if @simulator || `instruments -s devices`.include?(@udid)
    log.fatal("No such devices with UDID: #{@udid}")
    raise
  end

  def save_screenshot
    log.info('Saving screenshot 📷')
    png_path = "#{XCRESULTS_FOLDER}/Attachments/*.png"
    new_path = "#{ATTACHMENTS_FOLDER}/#{@platform}_#{TIMESTAMP}.png"
    screenshots = Dir[png_path].collect { |png| File.expand_path(png) }
    FileUtils.cp(screenshots[0], new_path)
    FileUtils.rm_rf(XCRESULTS_FOLDER)
  end
end
