class Android < Base
  RESOURCE_ID = { java: 'resource-id',
                  ruby: 'resource-id'}
  CONTENT_DESC = { java: 'content-desc',
                   ruby: 'content-desc'}
  TEXT = "text"
  ID = "id"
  XPATH = "xpath"
  CLASS = "class"

  attr_accessor :platform, :udid, :bundle_id, :ios_sim, :dir

  def initialize(options)
    self.platform = options[:platform]
    self.udid = options[:udid]
    self.dir = options[:dir]
  end

  def skeletoner
    create_page_objects(get_page_source)
  end

  private

  def create_locator_by_resouce_id(line)
    name = line[RESOURCE_ID]
    name.slice!(/.*id\//)
    code_generation(name, ID, line[RESOURCE_ID])
  end

  def create_locator_by_content_desc(line)
    @@locator_index += 1
    name = "#{line[CLASS]}#{@@locator_index}"
    name.slice!(/.*\./)
    locator = "//#{line[CLASS]}[@#{CONTENT_DESC}='#{line[CONTENT_DESC]}']"
    code_generation(name, XPATH, locator)
  end

  def create_locator_by_text(line)
    @@locator_index += 1
    name = "#{line[CLASS]}#{@@locator_index}"
    name.slice!(/.*\./)
    locator = "//#{line[CLASS]}[@#{TEXT}='#{line[TEXT]}'"
    code_generation(name, XPATH, locator)
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
    add_new_page_object(java, Language::RUBY)

    # ADD OTHER LANGUAGES HERE
  end

  def java(method_name, locator_type, value)
    <<~JAVA
      By #{camel_style(method_name)}() {
        return MobileBy.#{locator_type}("#{value}");
      }

    JAVA
  end

  def add_new_page_object(code, lan)
    File.open("#{@dir}/#{@platform}_#{TIMESTAMP}.#{lan}", 'a') do |f|
      f.write(code)
    end
  end

  def get_page_source
    dump = `adb -s #{@udid} shell uiautomator dump | egrep -o '/.*?xml'`
    `adb -s #{@udid} shell cat #{dump}`
  end

end