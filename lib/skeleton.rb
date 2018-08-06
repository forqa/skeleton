require 'erb'
require 'fileutils'
require 'nokogiri'
require 'colorize'
require 'mini_magick'
require_relative 'skeleton/languages.rb'
require_relative 'skeleton/root.rb'
require_relative 'skeleton/version'
require_relative 'skeleton/logger'
require_relative 'skeleton/base'
require_relative 'skeleton/ios'
require_relative 'skeleton/android'

module Skeleton
	class Skeleton
	  attr_accessor :platform, :udid, :bundle_id, :browser

	  def initialize(options)
	    self.platform = options.platform
	    self.browser = options.browser
	    @driver = ios? ? IOS.new(options) : Android.new(options)
	  end

	  def platform=(platform)
	    platform.nil? || platform.downcase!
	    if platform != 'ios' && platform != 'android'
	      raise 'Set platform, ios or android [-p arg]'
	    end
	    @platform = platform
	  end

    def run
			@driver.precondition
			@driver.skeletoner
			fill_html
			open_url
    end

		def fill_html
			languages = ios? ? Language.all : Language.all - ['swift']
			languages.each do |lang|
        attach_image
				type = Language.domain(lang)
        folder = Base::PAGE_OBJECTS_FOLDER
				@screen_objects = File.read(Dir["#{folder}/*.#{type}"].first)
				@elements_tree = File.read(Dir["#{folder}/*.xml"].first)
				@build_version = "v#{VERSION}"
        if @driver.class == Android
          @elements_tree = Nokogiri::XML(@elements_tree).to_s
          @elements_tree.gsub!('<', '&lt;')
          @elements_tree.gsub!('>', '&gt;')
        end
				template = File.read("#{Base::ROOT_DIR}/server/template.html.erb")
				result = ERB.new(template).result(binding)
				File.open("#{Base::ROOT_DIR}/server/#{lang}.html", 'w+') { |f| f.write(result) }
			end
    end

    def attach_image
      screenshot = Dir["#{Base::ATTACHMENTS_FOLDER}/*.png"].first
      image = MiniMagick::Image.new(screenshot)
      image.rotate(90) if image.width > image.height
    rescue MiniMagick::Error => err
      Log.warn(err)
		ensure
			FileUtils.cp_r(screenshot, "#{Base::ROOT_DIR}/server/screenshot.png")
    end

		def open_url
      port = File.read("#{Base::ROOT_DIR}/server/port")
			url = "http://localhost:#{port}/skeleton"
			`open #{url}` if @browser
			Log.info("Look at your pretty page objects: \n#{url} 😍")
    rescue Errno::ENOENT
      Log.warn('Something went wrong with skeleton server 💩' \
							 "\nTry to rerun it (:")
		end

	  def ios?
	    @platform == 'ios'
	  end

	  def android?
	    @platform == 'android'
	  end
	end
end
