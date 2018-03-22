require_relative 'languages.rb'

class Base
  include Language

  PAGE_OBJECTS_FOLDER = 'PageObjects'
  ATTACHMENTS_FOLDER = 'Attachments'
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

  def create_logger
    @log = Logger.new(STDOUT)
    @log.level = Logger::INFO
    @log.formatter = proc do |severity, datetime, progname, msg|
      "[#{severity}] #{datetime}: " + "#{msg}\n".colorize(:light_cyan)
    end
  end

  def snake_style(method_name)
    method_name.each_char.with_index do |char, char_i|
      method_name[char_i] =
        if /[ -!$%^&*()+|~=`{}\[\]:";'<>?,.\/]/.match(method_name[char_i])
          '_'
        elsif /[A-Z]/.match(method_name[char_i])
          if method_name[char_i - 1] != '_'
            "_#{method_name[char_i]}"
          else
            method_name[char_i]
          end
        else
          method_name[char_i]
        end
    end
    method_name.squeeze('_').downcase
  end

  def camel_style(method_name)
    space_i = 0
    method_name[0] = method_name[0].downcase
    method_name.each_char.with_index do |char, char_i|
      if /[ -!$%^&*()_+|~=`{}\[\]:";'<>?,.\/]/.match(char)
        method_name[char_i - space_i] = ''
        method_name[char_i - space_i] = method_name[char_i - space_i].capitalize
        space_i += 1
      end
    end
  end

  def increment_locator_id
    @locator_index = @locator_index.nil? ? 1 : @locator_index + 1
  end

  def java(method_name, locator_type, value)
    <<~JAVA
      By #{camel_style(method_name)}() {
        return MobileBy.#{locator_type[:java]}("#{value}");
      }

    JAVA
  end

  def ruby(method_name, locator_type, value)
    <<~RUBY
      def #{snake_style(method_name)}
        return :#{locator_type[:ruby]}, "#{value}"
      end

    RUBY
  end

  def screenshot
  end

  def page_source
  end

  def code_generation
  end

end