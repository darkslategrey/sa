
# $:.unshift File.dirname(__FILE__) + "/../lib"

require 'yaml'
require 'haml'
require 'json'
require 'sinatra'

require 'pp'

environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
conf = YAML.load_file './config/databases.yml'
$conf_env = conf[environment]

require './lib/db_connect'
require './lib/ax_logger'

Dir['models/*.rb'].map do |m| require "./#{m}" end


class AxAgenda < Sinatra::Base
  include Axagenda::Logging

  get '/' do
    haml :index
    # haml :remote, :layout => :remote_layout    
  end

  get '/users' do
    db = params['agenda']        
    logger.info("agenda <#{db}>")

    agenda = Group.server(db.to_sym).find(:nom => 'AX Agenda').first
    users  = agenda.users.map do |user|
        user.to_ax
      end
    { :users => users, :success => true }.to_json
  end
  

# {"id":"","cid":"1","title":"fdkljfdklsjkl","start":,"end":"2014-01-07T01:00:00+01:00","loc":"","notes":"","url":"","ad":false,"rem":"","rrule":"","duration":60,"origid":"","rsstart":"","ristart":"2014-01-07T00:00:00+01:00","redit":""}  
  # startDate=2013-12-29&endDate=2014-02-01&page=1&start=0&limit=25 
  get '/events' do
    events = Action.ax_find(params, [:je, :jd])
    logger.info("events size #{events.size}")
    { :events => events, :success => true }.to_json 
  end

  post '/events' do
    # all_day: false
    # cid: "1"
    # end: "2014-01-06T01:00:00+01:00"
    # id: ""
    # location: ""
    # notes: ""
    # reminder: ""
    # start: "2014-01-06T00:00:00+01:00"
    # title: "fdsfds"
    # url: ""
  end 
  
  get '/calendars' do
    calendars = [:je, :jd].map do |srv| Calendar.server(srv).first.as_ax end
    { :calendars => calendars, :success => true }.to_json
  end

  # not yet
  post '/calendars' do
  end
end


