

require 'active_record'
require 'octopus'
require './models/calendar'
require 'yaml'
require 'haml'

require 'pp'

config_db = YAML.load(File.open('./config/databases.yml', 'r'))
ActiveRecord::Base.establish_connection config_db['je']



class AxAgenda < Sinatra::Base

  get '/' do
    haml :index
  end

  get '/calendars' do
    calendars = [ Calendar.using(:je).first.as_json ]
    calendars << Calendar.using(:jd).first.as_json
    calendars.to_json
  end
  
end


