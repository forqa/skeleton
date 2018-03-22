class IOS < Base
  ACC_ID = {
             java: :AccessibilityId,
             ruby: :accessibility_id
           }
  NSPREDICATE = {
                  java: :iOSNsPredicateString,
                  ruby: :predicate
                }
  IDENTIFIER = 'identifier'
  LABEL = 'label'
  XCRESULTS_FOLDER = 'XCResults'

  attr_accessor :platform, :udid, :bundle_id

  def initialize(options)
    self.platform = options[:platform]
    self.udid = options[:udid]
    self.bundle_id = options[:bundle_id]
  end

  def skeletoner
    log.info('We starting to skeleton your screen 🚀')
    simulator?
    page_source
    create_page_objects
    save_screenshot
    save(page_source)
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
    code_generation(method_name, ACC_ID, locator)
  end

  def create_locator_by_label(locator, type)
    method_name = "#{type}#{increment_locator_id}"
    locator = "#{LABEL} like '#{locator}'"
    code_generation(method_name, NSPREDICATE, locator)
  end

  def create_page_objects
    log.info("Generation page objects for your awesome language 💪")
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

  def code_generation(method_name, locator_type, value)
    java = java(method_name, locator_type, value)
    ruby = ruby(method_name, locator_type, value)

    save(java, format: Language::JAVA)
    save(ruby, format: Language::RUBY)

    # ADD OTHER LANGUAGES HERE
  end

  def page_source
    if @page_source.nil?
      log.info("Getting screen source tree ⚒")
      FileUtils.rm_rf(XCRESULTS_FOLDER)
      start_grep, end_grep = 'start_grep_tag', 'end_grep_tag'
      ios_arch = simulator? ? 'iOS Simulator' : 'iOS'
      @page_source = `xcodebuild test \
                        -project Skeleton.xcodeproj \
                        -scheme Skeleton \
                        -destination 'platform=#{ios_arch},id=#{@udid}' \
                        -resultBundlePath #{XCRESULTS_FOLDER} \
                        bundle_id="#{@bundle_id}" | \
                        awk '/#{start_grep}/,/#{end_grep}/'`
      @page_source.slice!(start_grep)
      @page_source.slice!(end_grep)
      if @page_source.empty?
        log.fatal("Something went wrong. " +
                   "Try to sign Skeleton and trust him in the iOS setting.")
        Process.exit(1)
      end
      log.info("Successfully getting Screen Source Tree 🎩")
    end
    @page_source
  end

  def simulator?
    if @simulator.nil?
      log.info("Checking iOS UDID 👨‍💻")
      simulators = `xcrun simctl list`
      @simulator = simulators.include?(@udid)
    end
    @simulator
  end

  def save(code, format: 'xml')
    file_path = "#{PAGE_OBJECTS_FOLDER}/#{@platform}_#{TIMESTAMP}.#{format}"
    File.open(file_path, 'a') { |f| f.write(code) }
  end

  def save_screenshot
    log.info("Saving screenshot 🎥")
    xc_attachments_folder = 'Attachments'
    png_path = "#{XCRESULTS_FOLDER}/#{xc_attachments_folder}/*.png"
    new_path = "#{Dir.pwd}/#{ATTACHMENTS_FOLDER}/#{@platform}_#{TIMESTAMP}.png"
    screenshots = Dir[png_path].collect { |png| File.expand_path(png) }
    FileUtils.cp(screenshots[0], new_path)
    FileUtils.rm_rf(XCRESULTS_FOLDER)
  end
end
