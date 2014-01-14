require 'sequel'
require 'yaml'


mstr_adapter = "#{$conf_env['master']['adapter']}"
mstr_user    = "#{$conf_env['master']['username']}"
mstr_pass    = "#{$conf_env['master']['password']}"
mstr_host    = "#{$conf_env['master']['host']}"
mstr_port    = "#{$conf_env['master']['port']}"
mstr_db      = "#{$conf_env['master']['database']}"

je_db = $conf_env['je']['database']
jd_db = $conf_env['jd']['database']

mstr_url = "#{mstr_adapter}://#{mstr_user}:#{mstr_pass}@#{mstr_host}:#{mstr_port}/#{mstr_db}"

servers = {:read_only => {}}
servers[:je] = {:database => je_db}
servers[:jd] = {:database => jd_db}

DB = Sequel.connect mstr_url, :max_connections => 10, :servers => servers
                    
DB.extension :server_block
DB.extension :arbitrary_servers
Sequel::Model.plugin :sharding
Sequel::Model.plugin :json_serializer

