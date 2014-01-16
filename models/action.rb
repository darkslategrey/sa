# coding: utf-8
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

  # => 86340 secondes dans 23h59 minutes
  # c'est de cette façon que le doli identifit les fullday
  DOLI_FULLDAY = 60 * 60 * 23 + (60 * 59)
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
      reorder self.server(srv).where("datep >= '#{startDate}' and datep2 < '#{endDate}' and ax_agenda_id != 0").order(:datep, :datec).all
    end
    actions.flatten.map do |action|
      action.to_ax
    end
  end

  # Les actions doli toute la journée sont convertis en events AX
  # Ces actions s'ordonnent à  1/2 d'interval pour apparaître dans
  # le panneau principal de l'AX
  def self.reorder actions
    ordered_actions = {}
    actions.each do |action|
      datep, datep2  = action.datep, action.datep2
      d, m, y        = datep.day, datep.month, datep.year
      sorted_actions = ordered_actions["#{d}-#{m}-#{y}"] || {:fullday => [], :rdv => []} 
      if action.is_fullday
        sorted_actions[:fullday] << action
      else
        sorted_actions[:rdv] << action
      end
      ordered_actions["#{d}-#{m}-#{y}"] = sorted_actions
    end

    converted_actions = []
    ordered_actions.each_pair do |date, actions|
      hour, min = 9, 0
      d, m, y   = date.split '-'
      nd = DateTime.new(y.to_i, m.to_i, d.to_i, hour, min, 0, '+1')
      actions[:fullday].each do |action|
        action.datep  = nd
        action.datep2 = nd + 30.minute
        nd += 30.minute
        converted_actions << action
      end
    end
    converted_actions
  end

  def is_fullday
    return true if fulldayevent == 1
    return true if datep2 - datep == DOLI_FULLDAY
    return true if datep2 == datep
    return false
  end

  def to_ax
    {
      "id"    => id,
      "cid"   => calendar.id,
      "cname" => calendar.shortname,
      "title" => "#{id} / #{label}",
      "start" => DateTime.parse(datep.to_s).to_s,
      "end"   => DateTime.parse(datep2.to_s).to_s,
      "notes" => note,
      "owner" => user_todo.rowid
    }
  end
end
