$:.unshift File.dirname(__FILE__) + "/../lib"

require 'active_support/all'
require 'ax_logger'

class Action < Sequel::Model
  include ::Axagenda::Logging
  
  set_dataset :llx_actioncomm

  many_to_one :calendar, :key => :ax_agenda_id
  many_to_one :type,     :key => :fk_action

  many_to_one :user_asked, :key => :fk_user_author, :class => :User
  many_to_one :user_done,  :key => :fk_user_done,   :class => :User
  many_to_one :user_todo,  :key => :fk_user_action, :class => :User

  many_to_one :societe,    :key => :fk_soc
  many_to_one :contact,    :key => :fk_contact
  
    # events = [ {
    #              "id"    => 1001,
    #              "cid"   => 1,
    #              "title" => "Vacation",
    #              "start" => "2014-01-07T10:00:00+01:00",
    #              "end"   => "2014-01-07T11:00:00+01:00",
    #              "notes" => "Have fun" }]

    # params = {"startDate"=>"2013-12-29",
    #           "endDate"=>"2014-02-01",
    #           "page"=>"1",
    #           "start"=>"0",
    #           "limit"=>"25"}
  
  def self.ax_find params, srvs
    startDate = DateTime.parse params['startDate']
    endDate   = DateTime.parse params['endDate']    
    endDate   = endDate == startDate ? startDate + 1.day : endDate
    actions = srvs.map do |srv|
      self.server(srv).where("datep >= '#{startDate}' and datep2 < '#{endDate}' and ax_agenda_id != 0").order(:datep).all
    end
    actions.flatten.map do |action|
      action.to_ax
    end
  end


  def to_ax
    {
      "id"    => id,
      "cid"   => calendar.id,
      "title" => "#{id} / #{label}",
      "start" => DateTime.parse(datep.to_s).to_s,
      "end"   => DateTime.parse(datep2.to_s).to_s,
      "notes" => note
    }
  end
end
