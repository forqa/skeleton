require_relative 'version'

class Base
   ROOT_DIR = "#{`gem environment gemdir`.strip}" \
               "/gems/#{Skeleton::GEM_NAME}-#{Skeleton::VERSION}".freeze
end