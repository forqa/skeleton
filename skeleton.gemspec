
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "skeleton/version"

Gem::Specification.new do |spec|
  spec.name          = Skeleton::GEM_NAME
  spec.version       = Skeleton::VERSION
  spec.authors       = ["a.alterpesotskiy"]
  spec.email         = ["33gri@bk.ru"]

  spec.summary       = %q{CLI for fast generating multi language page objects from iOS and Android screens.}
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

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3.0"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_dependency "colorize", "~> 0.8.1"
  spec.add_dependency "mini_magick", "~> 4.8.0"
  spec.add_dependency "nokogiri", "~> 1.8.2"
  spec.add_dependency "fileutils"
  spec.add_dependency "commander"
end
