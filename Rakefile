

require 'pry'
require 'active_record'
require 'octopus'
require './models/calendar'

task :default => :test


task :run do
  exec "rerun --dir models,views,public -- rackup --port 4000 config.ru"
end

task :environment do
  db_config = YAML.load_file('./config/databases.yml')
  ActiveRecord::Base.establish_connection db_config['je']
end

task :console => :environment do
  Pry.config.pager = false
  Pry.start
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
end


