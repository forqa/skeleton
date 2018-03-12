module IOS

  @@IOS_ELEMENT_TYPES = [
    'Other', 'Button', 'StaticText', 'Switch', 'TextView', 'TextField', 'Image'
  ]

  def get_ios_skeleton
    ios_arch = @ios_sim ? 'iOS Simulator' : 'iOS'
    page_source = %x(xcodebuild test \
                    -project Skeleton.xcodeproj \
                    -scheme Skeleton \
                    -destination 'platform=#{ios_arch},id=#{@udid}' \
                    bundle_id="#{@bundle_id}" | \
                    awk '/start_grep_tag/,/end_grep_tag/')
    locators = {}
    page_source.each_line do |line|
      line_first_word = line.split.first
      element_type = line_first_word.nil? ? '' : line_first_word.chomp(',')
      if @@IOS_ELEMENT_TYPES.include?(element_type)
        if line.include?('identifier')
          locator = /identifier: '(.*?)'/.match(line)[1]
        elsif line.include?('label')
          locator = /label: '(.*?)'/.match(line)[1]
        else
          next
        end
        locators[locator] = element_type
      end
    end

    locators.each { |x, y| puts "#{x}: #{y}" }
  end


end