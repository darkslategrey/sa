
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


# {"id":"","cid":"1","title":"fdkljfdklsjkl","start":,"end":"2014-01-07T01:00:00+01:00","loc":"","notes":"","url":"","ad":false,"rem":"","rrule":"","duration":60,"origid":"","rsstart":"","ristart":"2014-01-07T00:00:00+01:00","redit":""}  
  # startDate=2013-12-29&endDate=2014-02-01&page=1&start=0&limit=25 
  get '/events' do
    events = Action.ax_find params, [:je, :jd]
    { :events => events }.to_json 
  end
  
  get '/calendars' do
    calendars = [:je, :jd].map do |srv| Calendar.server(srv).first.as_ax end
    { :calendars => calendars }.to_json
  end
  
end


