class Android < Base
  RESOURCE_ID = 'resource-id'
  CONTENT_DESC = 'content-desc'
  TEXT = 'text'
  ID = { java: :id }
  XPATH = { java: :xpath }
  CLASS = 'class'

  attr_accessor :platform, :udid, :bundle_id, :ios_sim

  def initialize(options)
    self.platform = options[:platform]
    self.udid = options[:udid]
  end

  def skeletoner
    log.info('We starting to skeleton your screen 🚀')
    create_page_objects
    save_screenshot
    save(page_source)
    log.info('We successfully skeletoned your screen 👻')
  end

  private

  def create_locator_by_resouce_id(line)
    method_name = line[RESOURCE_ID]
    method_name.slice!(/.*id\//)
    code_generation(method_name, ID, line[RESOURCE_ID])
  end

  def create_locator_by_content_desc(line)
    method_name = "#{line[CLASS]}#{increment_locator_id}"
    method_name.slice!(/.*\./)
    locator = "//#{line[CLASS]}[@#{CONTENT_DESC}='#{line[CONTENT_DESC]}']"
    code_generation(method_name, XPATH, locator)
  end

  def create_locator_by_text(line)
    method_name = "#{line[CLASS]}#{increment_locator_id}"
    method_name.slice!(/.*\./)
    locator = "//#{line[CLASS]}[@#{TEXT}='#{line[TEXT]}'"
    code_generation(method_name, XPATH, locator)
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

  def code_generation(method_name, locator_type, value)
    java = java(method_name, locator_type, value)
    save(java, format: Language::JAVA)
  end

  def save(code, format: 'xml')
    file_path = "#{PAGE_OBJECTS_FOLDER}/#{@platform}_#{TIMESTAMP}.#{format}"
    File.open(file_path, 'a') { |f| f.write(code) }
  end

  def page_source
    unless @page_source
      log.info('Getting screen source tree ⚒')
      dump = `adb -s #{@udid} shell uiautomator dump | egrep -o '/.*?xml'`
      @page_source = `adb -s #{@udid} shell cat #{dump}`
      if @page_source.empty?
        log.fatal('Something went wrong.') # FIXME
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
