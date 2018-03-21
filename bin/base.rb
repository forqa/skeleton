require_relative 'languages.rb'

class Base
  include Language

  TIMESTAMP = (Time.now.to_f * 1000).to_i

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

  def get_page_source
  end
end