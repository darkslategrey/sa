

class Action < Sequel::Model
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
    actions = srvs.map do |srv|
      self.server(srv)
    end
  end
  
end
