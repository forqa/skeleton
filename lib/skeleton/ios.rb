class IOS < Base
  ACC_ID = {
    java: :AccessibilityId,
    ruby: :accessibility_id,
    javascript: :id,
    python: :find_element_by_accessibility_id
  }.freeze
  NSPREDICATE = {
    java: :iOSNsPredicateString,
    ruby: :predicate,
    javascript: :predicate,
    python: :find_element_by_ios_predicate
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
    check_bundle
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
    locator = "#{LABEL} LIKE '#{text}'"
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
    if locator.nil?
      ''
    else
      label = locator[1]
      i = 0
      label.each_char do |char|
        if char =~ /(\"|\')/
          new_value = "\\#{char}"
          label[i] = new_value
          i += new_value.length - 1
        end
        i += 1
      end
      label
    end
  end

  def code_generation(method_name:, locator_type:, locator_value:)
    java = @language.java(camel_method_name: camel_style(method_name),
                          locator_type: locator_type,
                          locator_value: locator_value)
    ruby = @language.ruby(snake_method_name: snake_style(method_name),
                          locator_type: locator_type,
                          locator_value: locator_value)
    python = @language.python(snake_method_name: snake_style(method_name),
                              locator_type: locator_type,
                              locator_value: locator_value)
    js = @language.js(camel_method_name: camel_style(method_name),
                      locator_type: locator_type,
                      locator_value: locator_value)
    save(code: java, format: Language::JAVA)
    save(code: ruby, format: Language::RUBY)
    save(code: python, format: Language::PYTHON)
    save(code: js, format: Language::JAVASCRIPT)
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
        log.fatal("Try to sign Skeleton in #{XCODEPROJ_FOLDER}.\n" \
                  'For more info read: https://github.com/forqa/skeleton/' \
                  'blob/master/docs/real-ios-device-config.md')
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

  def check_bundle
    if @simulator
      return if `xcrun simctl appinfo #{@udid} #{@bundle_id}`
                    .include?("CFBundleName")
    else
      return if `ideviceinstaller -u #{@udid} -l`
                    .include?(@bundle_id)
    end
    log.fatal("No such apps with bundle_id: #{@bundle_id}")
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
