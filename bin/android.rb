class Android
  @@TIMESTAMP = (Time.now.to_f * 1000).to_i

  attr_accessor :platform, :udid, :bundle_id, :ios_sim, :dir

  def initialize(options)
    self.platform = options[:platform]
    self.udid = options[:udid]
    self.dir = options[:dir]
  end

  def skeletoner
    dump = %x(adb -s #{@udid} shell uiautomator dump | egrep -o '/.*?xml')
    page_source = %x(adb -s #{@udid} shell cat #{dump})
    get_elements_locators(page_source)  
  end


  private

  def get_elements_locators(page_source)
    i = 0
    p page_source
    doc = Nokogiri::HTML.parse(page_source)
    doc.css('node').map {|element|
    attribute = element["resource-id"]
    if  attribute.empty? 
      attribute = element["content-desc"]
      if attribute.empty?
        attribute = element["text"]
        if not attribute.empty?
          elem_class = element["class"]
          locator = "//#{elem_class}[@text='#{attribute}]'"
          name = elem_class
          name.slice!(/.*\./)
          name += i.to_s
          i += 1
          create_page_objects(name, "xpath", locator)
        end
      else 
        name = attribute
        name.slice!(/.*\./)
        name += i.to_s
        i += 1
        locator = "//#{elem_class}[@content-desc='#{attribute}]'"
        create_page_objects(name, "xpath", locator)
      end
    else
      p "ResoureId #{attribute}"
      name = attribute
      name.slice!(/.*id\//)
      p "NAME #{name}"
      create_page_objects(attribute, "id", attribute)
    end
    }
  end

  def get_java_method(name, locator_type, value)
    "By #{name}() {\n\treturn MobileBy.#{locator_type}(\"#{value}\");\n}\n\n"
  end

  def create_page_objects(name, locator_type, value)
    File.open("#{@dir}/#{@platform}_#{@@TIMESTAMP}.java", 'a') do |f|
      f.write(get_java_method(name, locator_type, value))
    end
  end



end
