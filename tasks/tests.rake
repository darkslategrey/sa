require 'rake/testtask'


Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
end

desc 'js test' 
task :tjs do
  out = %x{phantomjs spec/javascripts/helpers/run-jasmine.js   http://localhost:8888}
  puts out
end

if ENV['RACK_ENV'] in %w/test development/
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
end


