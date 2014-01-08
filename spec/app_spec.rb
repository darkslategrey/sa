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
    get '/events?startDate=2013-12-29&endDate=2014-02-01&page=1&start=0&limit=25'
    response = JSON.parse last_response.body
  end
  
end
