
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "skeleton/version"

Gem::Specification.new do |spec|
  spec.name          = "skeleton"
  spec.version       = Skeleton::VERSION
  spec.authors       = ["a.alterpesotskiy"]
  spec.email         = ["33gri@bk.ru"]

  spec.summary       = %q{CLI for fast generating multi language page objects from iOS and Android screens.}
  spec.homepage      = "https://github.com/forqa/skeleton"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3.0"
  spec.add_development_dependency "colorize", "~> 0.8.1"
  spec.add_development_dependency "nokogiri", "~> 1.8.2"
  spec.add_development_dependency "fileutils"
end
