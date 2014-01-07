
ENV['RAILS_ENV'] = 'production'

require 'pry'

namespace :ax do

  task :run do
    exec "rerun --dir models,views,public -- rackup --port 4000 config.ru"
  end

  task :console do
    Pry.config.requires = ['./lib/db_connect', './models/calendar']
    Pry.config.pager = false
    Pry.start
  end

end
