class Language
  JAVA = 'java'.freeze
  RUBY = 'rb'.freeze
  PYTHON = 'py'.freeze
  JAVASCRIPT = 'js'.freeze

  def java(camel_method_name:, locator_type:, locator_value:)
    <<~JAVA
      By #{camel_method_name} = MobileBy.#{locator_type[:java]}("#{locator_value}");

    JAVA
  end

  def ruby(snake_method_name:, locator_type:, locator_value:)
    <<~RUBY
      #{snake_method_name} = :#{locator_type[:ruby]}, "#{locator_value}"

    RUBY
  end

  def python(snake_method_name:, locator_type:, locator_value:)
    <<~PYTHON
      #{snake_method_name} = driver.#{locator_type[:python]}("#{locator_value})"

    PYTHON
  end

  def js(camel_method_name:, locator_type:, locator_value:)
    <<~JS
      #{camel_method_name} = driver.elements("#{locator_type[:javascript]}", "#{locator_value}");

    JS
  end

  def type(format)
    case format
    when 'ruby', 'rb'
      RUBY
    when 'java'
      JAVA
    when 'javascript', 'js'
      JAVASCRIPT
    when 'python', 'py'
      PYTHON
    else
      "I haven't this language format"
    end
  end
end