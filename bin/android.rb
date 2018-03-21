class Android < Base
  RESOURCE_ID = {
                  java: 'resource-id',
                  ruby: 'resource-id'
                }
  CONTENT_DESC = {
                    java: 'content-desc',
                    ruby: 'content-desc'
                 }
  TEXT = "text"
  ID = "id"
  XPATH = "xpath"
  CLASS = "class"



  attr_accessor :platform, :udid, :bundle_id, :ios_sim

  def initialize(options)
    self.platform = options[:platform]
    self.udid = options[:udid]
  end

  def skeletoner
    screenshot
    create_page_objects(page_source)
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

  def create_page_objects(page_source)
    page_source_html = Nokogiri::HTML.parse(page_source)
    page_source_html.css('node').each { |line| create_locator(line) }
  end

  def code_generation(method_name, locator_type, value)
    java = java(method_name, locator_type, value)
    add_new_page_object(java, Language::JAVA)

    # ADD OTHER LANGUAGES HERE
  end

  def add_new_page_object(code, lan)
    File.open("#{PAGE_OBJECTS_FOLDER}/#{@platform}_#{TIMESTAMP}.#{lan}", 'a') do |f|
      f.write(code)
    end
  end

  def page_source
    dump = `adb -s #{@udid} shell uiautomator dump | egrep -o '/.*?xml'`
    `adb -s #{@udid} shell cat #{dump}`
  end

  def screenshot
    file_name = "#{@platform}_#{TIMESTAMP}.png"
    `adb -s #{@udid} shell screencap -p /sdcard/#{file_name}`
    `adb -s #{@udid} pull /sdcard/#{file_name} #{ATTACHMENTS_FOLDER}/`
    `adb -s #{@udid} shell rm /sdcard/#{file_name}`
  end

end