

require 'sequel'
require './lib/db_connect'
require './models/calendar'

namespace :db do

  task :migrate do
    %w/jobenfance jobdependance master_doli/.each do |db|
      %x{sequel -m db/migrate mysql2://root:admin@localhost:3306/#{db}}
    end
  end

  task :seed do
    Calendar.create_using_server(:je, { :title => 'Actions Jobenfance', :color => 4,
                                        :name => 'Actions Jobenfance', :id => 1 })
    Calendar.create_using_server(:jd, { :title => 'Actions Jobdependance', :color => 25,
                                          :name => 'Actions Jobdependance', :id => 2 })
  end
end
