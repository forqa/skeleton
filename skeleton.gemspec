
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "skeleton/version"

Gem::Specification.new do |spec|
  spec.name          = Skeleton::GEM_NAME
  spec.version       = Skeleton::VERSION
  spec.authors       = ["Alexey Alter-Pesotskiy", "Dmitry Shcherbakov"]
  spec.email         = ["a.alterpesotskiy@mail.ru"]

  spec.summary       = "Tool for fast generating multi language page objects from iOS (device/simulator) and Android (devices/emulator) screens."
  spec.homepage      = "https://github.com/forqa/skeleton"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["skeleton"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency("bundler")
  spec.add_development_dependency("rake")
  spec.add_development_dependency('fasterer', '0.8.3')
  spec.add_development_dependency('rubocop', '0.49.1')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_dependency("colorize", "~> 0.8.1")
  spec.add_dependency("mini_magick", "~> 4.9.4")
  spec.add_dependency("nokogiri", "~> 1.10.8")
  spec.add_dependency("sinatra", "~> 2.0.3")
  spec.add_dependency("fileutils")
  spec.add_dependency("commander")
end
