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

  it "should say it's a full day event" do
    action = Action.server(:je).where(:id => 1088).first
    action.fulldayevent = 0
    assert_equal action.is_fullday, true
  end

  it "should reorder actions list" do
    startDate = "2013-12-29"
    endDate   = "2014-02-01"
    actions   = Action.server(:jd).where("datep >= '#{startDate}' and datep2 < '#{endDate}' and ax_agenda_id != 0").order(:datep, :datec).all
    reordered = Action.reorder actions
    assert_operator reordered.size, :>, 0    
  end
end



