require 'optparse'
require 'fileutils'
require 'nokogiri'
require 'logger'
require 'colorize'
require_relative 'bin/base.rb'
require_relative 'bin/ios.rb'
require_relative 'bin/android.rb'

class Skeleton

  attr_accessor :platform, :udid, :bundle_id

  def initialize(options)
    self.platform = options[:platform]
    self.udid = options[:udid]
    self.bundle_id = options[:bundle_id]
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

  def start
    @driver.precondition
    @driver.skeletoner
    @driver.log.info("#{Dir.pwd}/#{Base::PAGE_OBJECTS_FOLDER}/. 😍")
  end

  def ios?
    @platform == 'ios'
  end

  def android?
    @platform == 'android'
  end
end

options = {}
ARGV.options do |opts|
  opts.on('-u',
  				'--udid=val',
  				'Set device udid',
  				String) { |val| options[:udid] = val }
  opts.on('-p',
  				'--platform=val',
  				'Set device platform',
  				String) { |val| options[:platform] = val }
  opts.on('-b',
  				'--bundle=val',
  				'Set bundleId for your app [required for iOS]',
  				String) { |val| options[:bundle_id] = val }
  opts.parse!
end

skeleton = Skeleton.new(options)
skeleton.start
