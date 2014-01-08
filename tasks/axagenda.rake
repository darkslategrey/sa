
ENV['RAILS_ENV'] = 'production'

require 'pry'

namespace :ax do

  task :run do
    exec "rerun -b --dir models,views,public -- rackup --port 4000 config.ru"
  end

  task :console do
    models = Dir['models/*.rb'].map do |m| "./#{m}" end
    Pry.config.requires = ['./lib/db_connect'] + models
    Pry.config.pager = false
    Pry.start
  end

end
