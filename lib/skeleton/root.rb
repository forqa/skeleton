class Base
  # ROOT_DIR_FOR_DEBUG = File.expand_path('..', Dir.pwd)
  ROOT_DIR = "#{`gem environment gemdir`.strip}" \
               "/gems/#{Skeleton::GEM_NAME}-#{Skeleton::VERSION}"
end