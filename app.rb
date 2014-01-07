
ENV['RAILS_ENV'] = 'production'

require './models/calendar'
require 'yaml'
require 'haml'
require 'pp'
require 'sequel'


DB_JE = Sequel.connect 'mysql://root:admin@localhost:3306/jobenfance',
                       :max_connections => 10, :logger => 'log/je.log'
DB_JD = Sequel.connect 'mysql://root:admin@localhost:3306/jobdependance',
                       :max_connections => 10, :logger => 'log/jd.log'


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


