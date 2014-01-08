require File.expand_path '../spec_helper.rb', __FILE__




describe 'Action' do
  it "should return a list of action from all calendars" do
    params = {"startDate"=>"2013-12-29",
              "endDate"=>"2014-02-01",
              "page"=>"1",
              "start"=>"0",
              "limit"=>"25"}
    actions = Action.ax_find params, [:je, :jd]
    actions.size.wont_equal 0
  end

end



