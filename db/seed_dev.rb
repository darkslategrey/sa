
require 'sequel'
require 'yaml'

axdbconf   = YAML.load_file 'config/database.yml'

conf_dev   = axdbconf['development']
je_dev     = conf_dev['je']
jd_dev     = conf_dev['jd']

mstr_adapter = conf_dev['master']['adapter']
mstr_user    = conf_dev['master']['username']
mstr_pass    = conf_dev['master']['password']
mstr_host    = conf_dev['master']['host']
mstr_port    = conf_dev['master']['port']
mstr_db      = conf_dev['master']['database']

mstr_url = "#{mstr_adapter}://#{mstr_user}:#{mstr_pass}@#{mstr_host}:#{mstr_port}/#{mstr_db}"

servers = {:read_only => {}}
servers[:je] = {:database => je_dev['database']}
servers[:jd] = {:database => jd_dev['database']}

DB = Sequel.connect mstr_url, :max_connections => 10, :servers => servers
                    
DB.extension :server_block
DB.extension :arbitrary_servers
Sequel::Model.plugin :sharding
Sequel::Model.plugin :json_serializer

Dir['models/*.rb'].map do |m| require "./#{m}" end

condition = 'datep >= "2013-01-01" and datep2 <= "2013-01-28" and ax_agenda_id != 0'
now = DateTime.now


%w/je jd/.each do |db|
  actions = Action.server(db.to_sym).where(condition).all
  puts "#{db.upcase} move #{actions.count} actions from 2013-01-01 to #{now}"
  actions.each do |action|
    datep     = action.datep
    datep2    = action.datep2
    
    new_datep  = DateTime.new(now.year, now.month, datep.day, datep.hour, datep.min)
    new_datep2 = DateTime.new(now.year, now.month, datep2.day, datep2.hour, datep2.min)

    action.datep  = new_datep
    action.datep2 = new_datep2
    action.save
  end  
end



