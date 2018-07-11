require 'erb'
require 'fileutils'
require 'nokogiri'
require 'logger'
require 'colorize'
require_relative 'skeleton/version'
require_relative 'skeleton/base'
require_relative 'skeleton/ios'
require_relative 'skeleton/android'

module Skeleton
	class Skeleton
		include Language

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
	    if udid.nil?
	      raise 'Not set udid [-u arg]'
	    end
	    @udid = udid
	  end

	  def bundle_id=(bundle_id)
	    if @platform == 'ios' && bundle_id.nil?
	      raise 'Not set bundle_id [-b arg]'
	    end
	    @bundle_id = bundle_id
	  end

	  def run
			@driver.clear
			@driver.precondition
			@driver.skeletoner
			fill_html
			@driver.log.info('Get it: http://localhost:4567/index.html 😍')
		end

		def fill_html
			languages = ['ruby', 'java']
			languages.each do |lang|
				type = language_type(lang: lang)
				@pageobject = File.read(Dir["#{Base::PAGE_OBJECTS_FOLDER}/*.#{type}"].first)
				@elements_tree = File.read(Dir["#{Base::PAGE_OBJECTS_FOLDER}/*.xml"].first)
				screenshot = Dir["#{Base::ATTACHMENTS_FOLDER}/*.png"].first
				FileUtils.cp_r(screenshot, "../html/screenshot.png")
				template = File.read('../html/template.html.erb')
				result = ERB.new(template).result(binding)
				File.open("../html/#{lang}.html", 'w+') { |f| f.write(result) }
			end
		end

	  def ios?
	    @platform == 'ios'
	  end

	  def android?
	    @platform == 'android'
	  end
	end
end
