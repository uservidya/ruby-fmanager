lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fmanager/version'


Gem::Specification.new do |spec|
    spec.name           = 'fmanager'
    spec.version        = FManager::VERSION
    spec.summary        = %q{Managing files over multiple storage resources.}
    spec.description    = %q{FManager indexes main storage folders, searches for duplicated files, checks for file backup status.}

    spec.authors            = ['ShinYee']
    spec.email              = ['shinyee@speedgocomputing.com']
    spec.homepage           = 'http://github.com/xman/ruby-fmanager'
    spec.licenses           = ['GPLv3']

    spec.required_ruby_version      = '>= 2.0.0'
    spec.required_rubygems_version  = '>= 2.0.3'

    spec.files         = `git ls-files`.split($/)
    spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
    spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
    spec.require_paths = ["lib"]

    spec.add_development_dependency "bundler", "~> 1.3"
    spec.add_development_dependency "rake"
end
