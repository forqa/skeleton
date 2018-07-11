module Language
  JAVA = 'java'
  RUBY = 'rb'
  PYTHON = 'py'

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

  def language_type(lang:)
    case lang
    when 'ruby'
      RUBY
    when 'java'
      JAVA
    when 'python'
      PYTHON
    else
      "I haven't this language"
    end
  end
end