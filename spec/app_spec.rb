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

  it 'should persist a rescheduled action' do
    action_id = nil
    datep     = DateTime.now 
    datep2    = datep + 1.hour
    DB.with_server(:je) do
      action = Action.new(:label => 'test', :datep => datep, :datep2 => datep2)
      action.save
      action_id = action.id
      puts "action #{action_id}"
    end
    new_datep  = datep + 1.day
    new_datep2 = datep2 + 1.day
    put "/events/#{action_id}", { :id => action_id, :start => new_datep, :end => new_datep2, :cname => :je }.to_json, { 'CONTENT_TYPE' => 'application/json' }
    action = Action.server(:je).where(:id => action_id).first
    assert_equal action.datep, new_datep
    assert_equal action.datep2, new_datep2
  end

  it 'should delete an action' do
    action_id = nil
    DB.with_server(:je) do
      action = Action.new :label => 'test delete'
      action.save
      action_id = action.id
    end
    delete "/events/#{action_id}", { :cname => :je }.to_json, { 'CONTENT_TYPE' => 'application/json' }
    action = Action.server(:je).where(:id => action_id).first
    assert_equal action, nil
  end
  
end
