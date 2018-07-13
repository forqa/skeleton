require 'erb'
require 'fileutils'
require 'nokogiri'
require 'logger'
require 'colorize'
require 'mini_magick'
require_relative 'skeleton/languages.rb'
require_relative 'skeleton/root.rb'
require_relative 'skeleton/version'
require_relative 'skeleton/base'
require_relative 'skeleton/ios'
require_relative 'skeleton/android'

module Skeleton
	class Skeleton
	  attr_accessor :platform, :udid, :bundle_id

	  def initialize(options)
	    self.platform = options.platform
	    self.udid = options.udid
	    self.bundle_id = options.bundle
	    @driver = ios? ? IOS.new(options) : Android.new(options)
	  end

	  def platform=(platform)
	    platform.nil? || platform.downcase!
	    if platform != 'ios' && platform != 'android'
	      raise 'Set platform, ios or android [-p arg]'
	    end
	    @platform = platform
	  end

	  def udid=(udid)
      raise 'Not set udid [-u arg]' if udid.nil?
	    @udid = udid
	  end

	  def bundle_id=(bundle_id)
      raise 'Not set bundle_id [-b arg]' if @platform == 'ios' && bundle_id.nil?
	    @bundle_id = bundle_id
	  end

    def run
			@driver.clear
			@driver.precondition
			@driver.skeletoner
			fill_html
			open_url
    end

		def fill_html
			language = Language.new
			%w[ruby java python javascript].each do |lang|
        attach_image
				type = language.type(lang)
        folder = Base::PAGE_OBJECTS_FOLDER
				@pageobject = File.read(Dir["#{folder}/*.#{type}"].first)
				@elements_tree = File.read(Dir["#{folder}/*.xml"].first)
        if @driver.class == Android
          @elements_tree = Nokogiri::XML(@elements_tree).to_s
          @elements_tree.gsub!('<', '&lt;')
          @elements_tree.gsub!('>', '&gt;')
        end
				template = File.read("#{Base::ROOT_DIR}/html/template.html.erb")
				result = ERB.new(template).result(binding)
				File.open("#{Base::ROOT_DIR}/html/#{lang}.html", 'w+') { |f| f.write(result) }
			end
    end

    def attach_image
      screenshot = Dir["#{Base::ATTACHMENTS_FOLDER}/*.png"].first
      image = MiniMagick::Image.new(screenshot)
      image.rotate(90) if image.width > image.height
      FileUtils.cp_r(screenshot, "#{Base::ROOT_DIR}/html/screenshot.png")
    rescue MiniMagick::Error => e
      @driver.log.error(e)
    end

		def open_url
			url = 'http://localhost:4567/index.html'
			`open #{url}`
			@driver.log.info("Look at your pretty page objects: #{url} 😍")
		end

	  def ios?
	    @platform == 'ios'
	  end

	  def android?
	    @platform == 'android'
	  end
	end
end
