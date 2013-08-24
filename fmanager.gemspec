lib = File.expand_path("../lib", __FILE__)
$:.unshift lib unless $:.include?(lib)
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

    # spec.add_development_dependency

    spec.files          = Dir.glob('lib/**/*.rb')
    spec.files         += Dir.glob('bin/**/*.rb')
    spec.files         += ['COPYING']
    spec.files         += ['fmanager.gemspec', 'Rakefile']
    spec.files         += ['history.txt', 'readme.md']
    spec.test_files     = Dir.glob('test/**/*.rb')
    spec.test_files    += Dir.glob('test/**/*.txt')

    spec.executables    = %w(fm)
    spec.require_paths  = ["lib"]
end
