# coding: utf-8
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
    params = {
      :ref_ext=> '',
      :entity=>1,
      :datep=>DateTime.new(2014, 01, 14),
      :datep2=>DateTime.new(2014, 01, 14),
      :datea=>nil,
      :datea2=>nil,
      :fk_action=>5,
      :label=>
        "438 / se voir à vincennes et faire le point sur collaboration jkhjkhjk",
      :datec=>DateTime.new(2014, 01, 14),
      :tms=>DateTime.new(2014, 01, 14),
      :fk_user_author=>1,
      :fk_user_mod=>nil,
      :fk_project=>nil,
      :fk_soc=>152,
      :fk_contact=>289,
      :fk_parent=>0,
      :fk_user_action=>1,
      :fk_user_done=>nil,
      :priority=>0,
      :fulldayevent=>1,
      :punctual=>1,
      :percent=>0,
      :location=>"",
      :durationp=>nil,
      :durationa=>nil,
      :note=>"",
      :fk_element=>nil,
      :elementtype=>nil,
      :ax_agenda_id=>2
    }
    DB.with_server(:jd) do
      action = Action.new params
      assert_equal action.is_fullday, true
    end
  end

  it "should reorder actions list" do
    startDate = "2013-12-29"
    endDate   = "2014-02-01"
    actions   = Action.server(:jd).where("datep >= '#{startDate}' and datep2 < '#{endDate}' and ax_agenda_id != 0").order(:datep, :datec).all
    reordered = Action.reorder actions
    assert_operator reordered.size, :>, 0    
  end
end



