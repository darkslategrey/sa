

require 'sequel'

Dir['models/*.rb'].map do |m| require "./#{m}" end

namespace :db do

  task :environment do
    environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
    puts "Prepare env #{environment}"    
    conf = YAML.load_file 'config/databases.yml'
    $conf_env = conf[environment]
    require './lib/db_connect'
  end
  
  desc "Setup the db"
  task :setup => [:environment, :migrate, :seed, :set_axcal_id] do
    puts "Setup END"
  end

  desc "Migrate the db"
  task :migrate => :environment do
    puts "Migrate START"
    dbs = $conf_env.keys.map do |k| $conf_env[k]['database'] end
    dbs.each do |db|
      out = %x{sequel -l db/migrate.log -m db/migrate mysql2://root:admin@localhost:3306/#{db}}
      puts out
    end
    puts "Migrate END"
  end

  desc "Load the db"
  task :seed => :environment do
    puts "Seed START"
    Calendar.server(:je).where(:title => 'Actions Jobenfance').count != 0 or
      Calendar.create_using_server(:je, { :title => 'Actions Jobenfance', :color => 4,
                                          :name => 'Actions Jobenfance', :id => 1 })
    Calendar.server(:jd).where(:title => 'Actions Jobdependance').count != 0 or    
      Calendar.create_using_server(:jd, { :title => 'Actions Jobdependance', :color => 25,
                                          :name => 'Actions Jobdependance', :id => 2 })
    puts "Seed END"
  end

  desc "Attach actions to calendar"
  task :set_axcal_id => :environment do
    puts "Set ids START"
    reset = "update llx_actioncomm set ax_agenda_id = 0"
    update = "update llx_actioncomm set ax_agenda_id = ? where fk_action in ?"
    [:je, :jd].each do |db|    
      DB.with_server(db) do
        cal_id = Calendar.first.id        
        type_ids = Type.where('code in ?', %w/AC_TEL AC_FAX AC_PROP AC_EMAIL AC_RDV AC_COM AC_SHIP AC_SUP_ORD AC_SUP_INV/).map do |t| t.id end
        DB[reset].update
        DB[update, cal_id, type_ids].update
      end
    end
    puts "Set ids END" 
  end
end
