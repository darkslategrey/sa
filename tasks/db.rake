

require 'sequel'
require 'yaml'

environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
puts "Prepare env #{environment}"    
$axdbconf   = YAML.load_file 'config/database.yml'
$conf_env = $axdbconf[environment]


namespace :db do
  task :environment do
    begin 
      require './lib/db_connect'
      Dir['models/*.rb'].map do |m| require "./#{m}" end
    rescue Exception => e
      puts "Error while connect : #{e}"
      if environment == 'development'
        puts "Create dev db env"
        %w/je jd master/.each do |db|
          dev_adapter  = $conf_env[db]['adapter']
          dev_port     = $conf_env[db]['port']
          dev_host     = $conf_env[db]['host']            
          dev_username = $conf_env[db]['username']
          dev_pass     = $conf_env[db]['password']
          dev_db_name  = $conf_env[db]['database']

        end
      end
    end
  end
  
  desc "Setup the db"
  task :setup => [:environment, :migrate, :seed, :set_axcal_id] do
    puts "Setup END"
  end

  desc "setup dev db"
  task :setup_dev => :environment do
    puts "setup dev db START"    
    puts "\tcreate dev dbs START"
    %w/je jd master/.each do |db|
      dev_adapter  = $conf_env[db]['adapter']
      dev_port     = $conf_env[db]['port']
      dev_host     = $conf_env[db]['host']            
      dev_username = $conf_env[db]['username']
      dev_pass     = $conf_env[db]['password']
      dev_db_name  = $conf_env[db]['database']
      prod_db_name = $axdbconf['production'][db]['database']

      puts "\t\tdrop dev #{db}"
      %x/mysqladmin -u #{dev_username} -p#{dev_pass} -f drop #{dev_db_name}/ 

      puts "\t\tcreate dev #{db}"
      %x/mysqladmin -u #{dev_username} -p#{dev_pass} create #{dev_db_name}/
      
      puts "\t\tdump #{db}"
      %x[mysqldump -u #{dev_username} -p#{dev_pass} #{prod_db_name} > db/prod_#{db}.dump.sql]
      
      puts "\t\tload dev #{db}"
      %x[cat db/prod_#{db}.dump.sql | mysql -u #{dev_username} -p#{dev_pass} #{dev_db_name}]

      # puts "\t\tload dev seed data #{db} START"
      # %x[ruby db/seed_dev.rb]
      # db_url = "#{dev_adapter}://#{dev_username}:#{dev_pass}@#{dev_host}:#{dev_port}/#{dev_db_name}"
      # %x[sequel #{db_url} db/seed_dev.rb]
      # puts "\t\tload dev seed data #{db} END"      
    end
    puts "\tcreate dev dbs END"
    puts "setup dev db END"
    puts "Please run 'ruby db/seed_dev.rb' to load data into current month"
  end


  desc "revert db[migration_number]"
  task :revert, [:version]  => :environment do |t, args|
    puts "Migrate START"
    dbs = $conf_env.keys.map do |k| $conf_env[k]['database'] end
    dbs.each do |db|
      out = %x{sequel -E -m db/migrate  -M #{args[:version]} mysql2://root:admin@localhost:3306/#{db}}
      puts out
    end
    puts "Migrate END"
  end
  
  desc "migrate db"
  task :migrate => :environment do
    puts "Migrate START"
    dbs = $conf_env.keys.map do |k| $conf_env[k]['database'] end
    dbs.each do |db|
      out = %x{sequel -E -m db/migrate mysql2://root:admin@localhost:3306/#{db}}
      puts out
    end
    puts "Migrate END"
  end

  desc "load axagenda data"
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

  desc "Attach users to axagenda"
  task :attach_user => :environment do
    puts "Attach user START"
    [:je, :jd].each do |db|
      ax_agenda = Calendar.server(db).where('name like "Actions%"').first
      ax_group_users = Group.server(db).where(:nom => 'AX Agenda').first.users
      ax_group_users.each do |user|
        next if user.agendas.size > 0
        puts "\tAdd #{user.firstname} to #{ax_agenda.name}"
        ax_agenda.add_user user
      end
      ax_agenda.save
    end
    puts "Attach user END"
  end
end

