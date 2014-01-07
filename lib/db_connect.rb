require 'sequel'

servers = {:read_only => {}}
servers[:jd] = {:database => 'jobdependance'}
servers[:je] = {:database => 'jobenfance'}

DB = Sequel.connect 'mysql2://root:admin@localhost:3306/master_doli',
                    :max_connections => 10, :servers => servers
DB.extension :server_block    
Sequel::Model.plugin :sharding

