class Android < Base
  @@RESOURCE_ID = "resource-id"
  @@CONTENT_DESC = "content-desc"
  @@TEXT = "text"
  @@ID = "id"
  @@XPATH = "xpath"
  @@CLASS = "class"

  attr_accessor :platform, :udid, :bundle_id, :ios_sim, :dir

  def initialize(options)
    self.platform = options[:platform]
    self.udid = options[:udid]
    self.dir = options[:dir]
  end

  def skeletoner
    dump = %x(adb -s #{@udid} shell uiautomator dump | egrep -o '/.*?xml')
    page_source = %x(adb -s #{@udid} shell cat #{dump})  
    create_page_objects(page_source)  
  end


  private

  def create_locator_by_resouce_id(element)
    name = element[@@RESOURCE_ID]
    name.slice!(/.*id\//)
    add_locator_to_page_objects(name, @@ID, element[@@RESOURCE_ID])
  end

  def create_locator_by_content_desc(element)
    name = element[@@CONTENT_DESC]
    name.slice!(/.*id\//)
    locator = "//#{element[@@CLASS]}[@#{@@CONTENT_DESC}='#{element[@@CONTENT_DESC]}']"
    add_locator_to_page_objects(name, @@XPATH, locator)
  end

  def create_locator_by_text(element)
    name = element[@@CLASS]
    name.slice!(/.*\./)
    locator = "//#{element[@@CLASS]}[@#{@@TEXT}='#{element[@@TEXT]}'"
    add_locator_to_page_objects(name, @@XPATH, locator)
  end

  def create_locator(element)
    !element[@@RESOURCE_ID].empty? && create_locator_by_resouce_id(element) and
    !element[@@CONTENT_DESC].empty? && create_locator_by_content_desc(element) and
    !element[@@TEXT].empty? && create_locator_by_text(element)
  end

  def create_page_objects(page_source)
    doc = Nokogiri::HTML.parse(page_source)
    doc.css('node').map {|element|
      create_locator(element)
    }
  end

  def get_java_method(name, locator_type, value)
    "By #{name}() {\n\treturn MobileBy.#{locator_type}(\"#{value}\");\n}\n\n"
  end

  def add_locator_to_page_objects(name, locator_type, value)
    File.open("#{@dir}/#{@platform}_#{@@TIMESTAMP}.java", 'a') do |f|
      f.write(get_java_method(name, locator_type, value))
    end
  end
  

end