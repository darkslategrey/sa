# coding: utf-8
require File.expand_path '../spec_helper.rb', __FILE__

include Rack::Test::Methods

def app
  AxAgenda
end

describe "Axagenda App" do

  it "should successfully respond" do
    get '/'
    assert_equal 200, last_response.status
  end

  it "should return the je/jd calendars" do
    get '/calendars'
    response = JSON.parse last_response.body
    assert_equal 2, response['calendars'].size
  end


  it "should return a list of events" do
    get '/events?startDate=2013-12-29&endDate=2014-02-01'
    response = JSON.parse last_response.body
  end

  it "should return all the ax group users" do
    get '/users?agenda=je'
    response = JSON.parse last_response.body
    assert_operator response["users"].size, :>, 0
    get '/users?agenda=jd'    
    assert_operator response["users"].size, :>, 0    
  end

  it "should update the action" do
    params = { "EventId" =>  "438",
               "all_day" =>  false,
               "cid" =>  "2",
               "cname" =>  "jd",
               "end" =>  "2014-01-14T09:30:00+01:00",
               "id" =>  "438",
               "location" =>  "",
               "notes" =>  "",
               "owner" =>  1,
               "reminder" =>  "",
               "start" =>  "2014-01-14T09:00:00+01:00",
               "title" =>  "438 / se voir à vincennes et faire le point sur collaboration jkhjkhjk",
               "url" =>  ""
             }
    post '/events', params
    response = JSON.parse last_response.body
    pp response
    assert_equal response['success'], true
    action = Action.server(:jd).where(:id => 438).first
    assert_equal action.label, "438 / se voir à vincennes et faire le point sur collaboration jkhjkhjk"
  end
end
