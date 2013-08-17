$:.unshift File.expand_path("../lib", __FILE__)
require 'rake/testtask'

require 'fmanager'


task :default => []


desc 'Run tests.'
task :test
Rake::TestTask.new do |t|
    t.libs << 'lib'
    t.test_files = Dir.glob('test/**/test_*.rb')
end
