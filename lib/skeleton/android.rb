class Android < Base
  RESOURCE_ID = 'resource-id'.freeze
  CONTENT_DESC = 'content-desc'.freeze
  TEXT = 'text'.freeze
  CLASS = 'class'.freeze
  ID = {
    java: :id,
    ruby: :id,
    javascript: :id,
    python: :find_element_by_id
  }.freeze
  XPATH = {
    java: :xpath,
    ruby: :xpath,
    javascript: :xpath,
    python: :find_element_by_xpath
  }.freeze

  attr_accessor :platform, :udid

  def initialize(options)
    self.platform = options.platform
    self.udid = options.udid
    @language = Language.new
  end

  def skeletoner
    log.info('We starting to skeleton your screen 🚀')
    create_page_objects
    save_screenshot
    save(code: page_source)
    log.info('We successfully skeletoned your screen 👻')
  end

  private

  def create_locator_by_resouce_id(line)
    method_name = line[RESOURCE_ID]
    method_name.slice!(/.*id\//)
    code_generation(method_name: method_name,
                    locator_type: ID,
                    locator_value: line[RESOURCE_ID])
  end

  def create_locator_by_content_desc(line)
    method_name = "#{line[CLASS]}#{increment_locator_id}"
    method_name.slice!(/.*\./)
    locator = "//#{line[CLASS]}[@#{CONTENT_DESC}='#{line[CONTENT_DESC]}']"
    code_generation(method_name: method_name,
                    locator_type: XPATH,
                    locator_value: locator)
  end

  def create_locator_by_text(line)
    method_name = "#{line[CLASS]}#{increment_locator_id}"
    method_name.slice!(/.*\./)
    locator = "//#{line[CLASS]}[@#{TEXT}='#{line[TEXT]}'"
    code_generation(method_name: method_name,
                    locator_type: XPATH,
                    locator_value: locator)
  end

  def create_locator(line)
    if !line[RESOURCE_ID].empty?
      create_locator_by_resouce_id(line)
    elsif !line[CONTENT_DESC].empty?
      create_locator_by_content_desc(line)
    elsif !line[TEXT].empty?
      create_locator_by_text(line)
    end
  end

  def create_page_objects
    log.info('Generation page objects for your awesome language 💪')
    page_source_html = Nokogiri::HTML.parse(page_source)
    page_source_html.css('node').each { |line| create_locator(line) }
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
    unless @page_source
      log.info('Getting screen source tree ⚒')
      dump = `adb -s #{@udid} shell uiautomator dump | egrep -o '/.*?xml'`
      @page_source = `adb -s #{@udid} shell cat #{dump}`
      if @page_source.empty?
        log.fatal('Something went wrong. Check your device')
        Process.exit(1)
      end
      log.info('Successfully getting Screen Source Tree 🔥')
    end
    @page_source
  end

  def save_screenshot
    log.info('Saving screenshot 📷')
    file_name = "#{@platform}_#{TIMESTAMP}.png"
    `adb -s #{@udid} shell screencap -p /sdcard/#{file_name}`
    `adb -s #{@udid} pull /sdcard/#{file_name} #{ATTACHMENTS_FOLDER}/`
    `adb -s #{@udid} shell rm /sdcard/#{file_name}`
  end
end
