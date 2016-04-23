# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'annotate_gemfile/version'

Gem::Specification.new do |spec|
  spec.name          = "annotate_gemfile"
  spec.version       = AnnotateGemfile::VERSION
  spec.authors       = ["Jake Moffatt"]
  spec.email         = ["jakeonrails@gmail.com"]

  spec.summary       = %q{Adds gem descriptions from Rubygems to every gem in the Gemfile}
  spec.description   = %q{Adds gem descriptions from Rubygems to every gem in the Gemfile}
  spec.homepage      = "https://github.com/jakeonrails/annotate_gemfile"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['annotate-gemfile']
  spec.require_paths = ["lib"]

  spec.add_dependency "gems"
  spec.add_dependency "ruby-progressbar"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "pry-byebug"
end
