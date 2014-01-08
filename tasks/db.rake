

require 'sequel'
require './lib/db_connect'
require './models/calendar'
require './models/action'

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

  # todo: met a jour seulement les actions type tel fax rdv etc
  task :set_axcal_id do
    [:je, :jd].each do |srv|
      cal_id = Calendar.server(srv).first.id
      Action.server(srv).each do |a|
        a.update :ax_agenda_id => cal_id
      end
    end
  end
end
