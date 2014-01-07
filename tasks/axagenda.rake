
ENV['RAILS_ENV'] = 'production'

require 'octopus'
require './models/calendar'
require 'pry'



namespace :ax do

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

  task :load_data => :environment do
    Calendar.using(:je).create!(id: 1, name: 'Actions Jobenfance',
                                title: 'Actions Jobenfance',
                                color: '2')
    Calendar.using(:jd).create!(id: 2, name: 'Actions Jobdependance',
                                title: 'Actions Jobdependance',
                                color: '22')
  end
  
  
end
