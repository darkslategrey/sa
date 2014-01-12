

require 'sequel'
require './lib/db_connect'
Dir['models/*.rb'].map do |m| require "./#{m}" end

namespace :db do

  desc "Init the db"
  task :init => [:migrate, :seed, :set_axcal_id] do
  end

  desc "Migrate the db"
  task :migrate do
    %w/jobenfance jobdependance master_doli/.each do |db|
      %x{sequel -m db/migrate mysql2://root:admin@localhost:3306/#{db}}
    end
  end

  desc "Load the db"
  task :seed do
    Calendar.create_using_server(:je, { :title => 'Actions Jobenfance', :color => 4,
                                        :name => 'Actions Jobenfance', :id => 1 })
    Calendar.create_using_server(:jd, { :title => 'Actions Jobdependance', :color => 25,
                                        :name => 'Actions Jobdependance', :id => 2 })
  end

  desc "Attach actions to calendar"
  task :set_axcal_id do
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
  end
end
