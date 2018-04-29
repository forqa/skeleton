require_relative 'languages.rb'
require_relative 'root.rb'

class Base
  include Language

  PAGE_OBJECTS_FOLDER = "#{ROOT_DIR}/PageObjects"
  ATTACHMENTS_FOLDER = "#{ROOT_DIR}/Attachments"
  TIMESTAMP = (Time.now.to_f * 1000).to_i

  def precondition
    create_logger
    FileUtils.mkdir_p(PAGE_OBJECTS_FOLDER)
    FileUtils.mkdir_p(ATTACHMENTS_FOLDER)
  end

  def log
    if @log.nil?
      create_logger
    end
    @log
  end

  def skeletoner
  end

  protected

  def save(code:, format: 'xml')
    file_path = "#{PAGE_OBJECTS_FOLDER}/#{@platform}_#{TIMESTAMP}.#{format}"
    File.open(file_path, 'a') { |f| f.write(code) }
  end

  def create_logger
    @log = Logger.new(STDOUT)
    @log.level = Logger::INFO
    @log.formatter = proc do |severity, datetime, progname, msg|
      "[#{severity}] #{datetime}: " + "#{msg}\n".colorize(:light_cyan)
    end
  end

  def snake_style(method_name)
    method_name.tr("@()[]'\"*!?{}:;#$^.,\/\\", '').
                tr('-', '_').
                gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
                gsub(/([a-z\d])([A-Z])/, '\1_\2').
                gsub(/\s/, '_').
                gsub(/__+/, '_').
                downcase
  end

  def camel_style(method_name)
    method_name.tr!("@()[]'\"*!?{}:;#$^.,\/\\", '')
    camel = method_name.split(/_|-|\ /).inject([]) do |buffer, e|
      buffer.push(buffer.empty? ? e : e.capitalize)
    end.join
    if camel == camel.upcase
      camel.downcase
    else
      camel[0] = camel[0].downcase
      camel
    end
  end

  def increment_locator_id
    @locator_index = @locator_index.nil? ? 1 : @locator_index + 1
  end

  def screenshot
  end

  def page_source
  end

  def code_generation
  end
end
