require 'optparse'
require_relative 'modules/ios.rb'
require_relative 'modules/android.rb'

class Skeleton
  include IOS
  include Android

  attr_accessor :platform, :udid, :bundle_id, :ios_sim

  def initialize(options)
    self.platform = options[:platform]
    self.udid = options[:udid]
    self.ios_sim = options[:ios_sim]
    self.bundle_id = options[:bundle_id]
  end

  def platform=(platform)
    platform.downcase! if not platform.nil?
    if (platform != 'ios' && platform != 'android')
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
    if ios?
      get_ios_skeleton
    elsif android?
      get_android_skeleton
    end
  end

  def ios?
    @platform == 'ios'
  end

  def android?
    @platform == 'android'
  end

end

options = {:ios_sim => false}
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
  opts.on('--ios_sim',
          'Set this arg, if you use iOS Simulator [optional arg]') do
    |val| options[:ios_sim] = val
  end
  opts.parse!
end

skeleton = Skeleton.new(options)
skeleton.start
