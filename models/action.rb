# -*- coding: utf-8 -*-

# coding: utf-8
$:.unshift File.dirname(__FILE__) + "/../lib"

require 'active_support/all'
require 'ax_logger'

class Action < Sequel::Model
  extend Axagenda::Logging
  
  set_dataset :llx_actioncomm

  set_allowed_columns :calendar, :datep, :datep2, :label
  
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
  
  def self.ax_find params, srvs
    startDate = DateTime.parse params['startDate']
    endDate   = DateTime.parse params['endDate']    
    endDate   = endDate == startDate ? startDate + 1.day : endDate
    # Attention ici sur le ^Société !! Risque de ne pas voir l'action
    labelcond = "label not regexp '^Bon de commande|^Facture FA|^Facture AV|^Proposition valid|^Société'"
    usercond  = "fk_user_action IS NOT NULL"
    datecond  = "((datep >= '#{startDate}' and datep2 < '#{endDate}') OR (datep >= '#{startDate}' and datep2 IS NULL))"
    condition = "#{datecond} and #{usercond} and #{labelcond} and percent != 100"
    Action.logger.info "condition #{condition}"

    actions = []
    srvs.each do |srv|
      actions += self.server(srv).where(condition).order(:datep, :datec, :id).all
      Action.logger.info "srv #{srv} nbr events #{actions.size}"
    end
    actions = reorder actions.flatten
    actions = actions.map do |action|
      logger.info "found event #{action.id} / <#{action.label}>"
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
      sorted_actions = ordered_actions["#{d}-#{m}-#{y}"] || {:fullday => [], :rdv => []} # rdv not used
      sorted_actions[:fullday] << action
      ordered_actions["#{d}-#{m}-#{y}"] = sorted_actions
    end

    interval = 5
    converted_actions = []
    ordered_actions.each_pair do |date, actions|
      hour, min = 1, 0
      d, m, y   = date.split '-'
      nd = DateTime.new(y.to_i, m.to_i, d.to_i, hour, min, 0, '+1')
      actions[:fullday].each do |action|
        action.datep  = nd
        action.datep2 = nd + interval.minute
        nd += interval.minute
        converted_actions << action
      end
    end
    converted_actions
  end


  def self.delete_from_doli action_id, params
    success = false
    begin 
      Action.server(params['cname'].to_sym).where(:id => action_id).delete
    rescue Exception => e
      msg = "Erreur suppression action ##{action_id}"
    else
      msg = "Action ##{action_id} supprimée"
      success = true
    end
    logger.info "delete action #{action_id} msg #{msg} success #{success}"
    { :msg => msg, :success => success }
  end


  def self.update_doli params
    logger.info("Start update <#{params['cname']}> <#{params}>")
    msg = ''
    success = false
    action = Action.server(params['cname'].to_sym).where(:id => params['id']).first
    logger.info "update_doli action #{action}"
    action.label = params['subject']
    action.note  = params['notes']
    action.datep = params['start']
    action.datep2 = params['end']
    logger.info "action #{action}"

    if not action.contact.nil?
      logger.info "action maj contact"
      action.contact.phone        = params['contact_phone']
      action.contact.phone_perso  = params['contact_phone_perso']
      action.contact.phone_mobile = params['contact_phone_mobile']
      action.contact.email        = params['contact_email']
      begin
        action.contact.save
      rescue Exception => e
        self.logger.error "Update Error: #{e}"
      end
    end

    action.percent = 100 if params['is_finished']

    begin
      logger.info "action save start"
      action.save
      logger.info "action save end"
    rescue Exception => e
      msg = "Erreur mise à jour: #{e}"
      logge.info "error #{msg}"
      success = false
    else
      msg = "Action mise à jour"
      logger.info "Action maj ok"
      success = true
    end
    logger.info "fin maj msg #{msg} success #{success}"
    { :msg => msg, :success => success }
  end

  
  def is_fullday
    return true if fulldayevent == 1
    return true if datep2 - datep == DOLI_FULLDAY
    return true if datep2 == datep
    return false
  end

  def to_ax
    title = "#{id} / "
    title += societe.nil? ? label : societe.nom
    title += ' - '
    title += contact.nil? ? "Pas de contact" : "#{contact.civilite} #{contact.name}"

    Action.logger.info "to ax pour #{id} calendar #{calendar}"
    Action.logger.info "calendar id #{calendar.id}"

    shortname = calendar.name =~ /Jobenfance/ ? 'je' : 'jd'

    contact_email = contact_phone = contact_phone_perso = contact_phone_mobile = ''
    if not contact.nil?
      contact_email        = contact.email
      contact_phone        = contact.phone
      contact_phone_perso  = contact.phone_perso
      contact_phone_mobile = contact.phone_mobile
    end

    ax_contact = contact.nil? ? nil : contact.to_ax
    {
      "id"    => id,
      "subject" => label,
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
