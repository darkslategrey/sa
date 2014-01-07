
ENV['RAILS_ENV'] = 'production'

require 'active_record'
require 'octopus'
require './models/calendar'
require 'yaml'
require 'haml'

require 'pp'

config_db = YAML.load(File.open('./config/databases.yml', 'r'))
ActiveRecord::Base.establish_connection config_db['production']



class AxAgenda < Sinatra::Base

  get '/' do
    haml :index
  end

  get '/calendars' do
    calendars = [ Calendar.using(:je).first.as_ax ]
    calendars << Calendar.using(:jd).first.as_ax
    { :calendars => calendars }.to_json
  end
  
end


