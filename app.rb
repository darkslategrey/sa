
ENV['RAILS_ENV'] = 'production'

require './lib/db_connect'
require './models/calendar'
require 'active_support'

require 'yaml'
require 'haml'
require 'json'

require 'pp'

class AxAgenda < Sinatra::Base

  get '/' do
    haml :index
  end

  get '/calendars' do
    calendars = []
    calendars = [:je, :jd].map do |srv| Calendar.server(srv).first.as_ax end
    { :calendars => calendars }.to_json
  end
  
end


