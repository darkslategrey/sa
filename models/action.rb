# coding: utf-8
$:.unshift File.dirname(__FILE__) + "/../lib"

require 'active_support/all'
require 'ax_logger'

class Action < Sequel::Model
  extend Axagenda::Logging
  
  set_dataset :llx_actioncomm

  set_allowed_columns :calendar, :datep, :datep2
  
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
    # Attention ici sur le ^Société !! Risque de ne pas voir l'action
    labelcond = "label not regexp '^Bon de commande|^Facture FA|^Facture AV|^Proposition valid|^Société'"
    usercond  = "fk_user_action IS NOT NULL"
    condition = "datep >= '#{startDate}' and datep2 < '#{endDate}' and #{usercond} and #{labelcond} and percent != 100"
    Action.logger.info "condition #{condition}"

    actions = []
    srvs.each do |srv|
      actions += self.server(srv).where(condition).order(:datep, :datec).all
    end
    actions = reorder actions.flatten
    actions = actions.map do |action| action.to_ax end
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
      if action.is_fullday # test le tout dans fullday 
        sorted_actions[:fullday] << action
      else
        sorted_actions[:fullday] << action        
        # sorted_actions[:rdv] << action
      end
      ordered_actions["#{d}-#{m}-#{y}"] = sorted_actions
    end

    interval = 10
    converted_actions = []
    ordered_actions.each_pair do |date, actions|
      hour, min = 9, 0
      d, m, y   = date.split '-'
      nd = DateTime.new(y.to_i, m.to_i, d.to_i, hour, min, 0, '+1')
      actions[:fullday].each do |action|
        action.datep  = nd
        action.datep2 = nd + interval.minute
        nd += interval.minute
        converted_actions << action
      end
      # converted_actions += actions[:rdv]
    end
    converted_actions
  end

    # EventId: "1088"
    # all_day: false
    # cid: "2"
    # cname: "jd"
    # end: "2014-01-14T10:30:00+01:00"
    # id: "1088"
    # location: ""
    # notes: null
    # owner: 2
    # reminder: ""
    # start: "2014-01-14T10:00:00+01:00"
    # title: "1088 / RDV Client Synhèse et début collaboration jhjjkhkj"
    # url: ""
  def self.update_doli params
    self.logger.debug("Start update <#{params['cname']}> <#{params['id']}>")
    msg = ''
    success = false
    action = Action.server(params['cname'].to_sym).where(:id => params['id']).first
    action.label = params['title']
    action.note  = params['notes']
    action.datep = params['start']
    action.datep2 = params['end']

    if not action.contact.nil?
      action.contact.phone = params['contact_phone']
      action.contact.phone_perso = params['contact_phone_perso']
      action.contact.phone_mobile = params['contact_phone_mobile']
      action.contact.email = params['contact_email']

      begin
        action.contact.save
      rescue Exception => e
        self.logger.error "Update Error: #{e}"
      end
      
    end

    action.percent = 100 if params['is_finished']

    begin
      action.save
    rescue Exception => e
      msg = "Erreur mise à jour: #{e}"
      success = false
    else
      msg = "Action mise à jour"
      success = true
    end
    { :msg => msg, :success => success }
  end

  
  def is_fullday
    return true if fulldayevent == 1
    return true if datep2 - datep == DOLI_FULLDAY
    return true if datep2 == datep
    return false
  end

  def to_ax
    environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
    title = environment == 'development' ? "#{id} / " : ''
    title += societe.nil? ? label : societe.nom
    title += ' - '
    title += contact.nil? ? "Pas de contact" : "#{contact.civilite} #{contact.name}"

    Action.logger.info "to ax pour #{id} calendar #{calendar}"
    Action.logger.info "calendar id #{calendar.id}"


    shortname = calendar.name =~ /Jobenfance/ ? 'je' : 'jd'

    contact_email = contact_phone = contact_phone_perso = contact_phone_mobile = ''
    if not contact.nil?
      contact_email = contact.email
      contact_phone = contact.phone
      contact_phone_perso = contact.phone_perso
      contact_phone_mobile = contact.phone_mobile
    end

    ax_contact = contact.nil? ? nil : contact.to_ax
    {
      "id"    => id,
      "cid"   => calendar.id,
      "cname" => shortname,
      "title" => title,
      "start" => DateTime.parse(datep.to_s).to_s,
      "end"   => DateTime.parse(datep2.to_s).to_s,
      "notes" => note,
      "owner" => user_todo.rowid,
      "contact_email"        => contact_email,
      "contact_phone"        => contact_phone,
      "contact_phone_perso"  => contact_phone_perso,
      "contact_phone_mobile" => contact_phone_mobile,
      "is_finished" => false
    }
  end
end
