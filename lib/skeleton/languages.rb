class Language
  JAVA = 'java'
  RUBY = 'rb'
  PYTHON = 'py'

  def java(camel_method_name:, locator_type:, locator_value:)
    <<~JAVA
      By #{camel_method_name}() {
        return MobileBy.#{locator_type[:java]}("#{locator_value}");
      }

    JAVA
  end

  def ruby(snake_method_name:, locator_type:, locator_value:)
    <<~RUBY
      def #{snake_method_name}
        return :#{locator_type[:ruby]}, "#{locator_value}"
      end

    RUBY
  end

  def type(format)
    case format
    when 'ruby'
      RUBY
    when 'java'
      JAVA
    when 'python'
      PYTHON
    else
      "I haven't this language format"
    end
  end
end