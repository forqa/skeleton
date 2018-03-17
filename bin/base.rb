class Base
  TIMESTAMP = (Time.now.to_f * 1000).to_i
  @@locator_index = 0

  def snake_style(method_name)
    method_name[0] = method_name[0].downcase
    method_name.squeeze!('_')  
    method_name.each_char.with_index do |char, char_i|
      method_name[char_i] =
        if char == ' ' || char == '-'
          '_'
        elsif /[A-Z]/.match(method_name[char_i])
          if method_name[char_i - 1] != '_'
            '_' + method_name[char_i].downcase
          else
            method_name[char_i].downcase
          end
        else
          method_name[char_i]
        end
    end
  end

  def camel_style(method_name)
    space_i = 0
    method_name[0] = method_name[0].downcase
    method_name.each_char.with_index do |char, char_i|
      if char == ' ' || char == '_' || char == '-'
        method_name[char_i - space_i] = ''
        method_name[char_i - space_i] =
          method_name[char_i - space_i].capitalize
        space_i += 1
      end
    end
  end

  def get_page_source
  end
end