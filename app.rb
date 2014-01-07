
ENV['RAILS_ENV'] = 'production'

require './lib/db_connect'
require './models/calendar'
require './models/action'

require 'yaml'
require 'haml'
require 'json'

require 'pp'

class AxAgenda < Sinatra::Base

  get '/' do
    haml :index
  end

  # startDate=2013-12-29&endDate=2014-02-01&page=1&start=0&limit=25 
  get '/events' do
    # events = [:je, :jd].map do |srv| Action.server(srv).ax_find params end
    '{}'
  end
  
  get '/calendars' do
    calendars = [:je, :jd].map do |srv| Calendar.server(srv).first.as_ax end
    { :calendars => calendars }.to_json
  end
  
end


