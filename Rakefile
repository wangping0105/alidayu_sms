require "bundler/gem_tasks"


load "tasks/sms.rake"


require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.pattern = "test/*_test.rb"
  t.ruby_opts << "-r test_helper"
end

task :default => :test