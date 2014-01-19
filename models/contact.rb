


class Contact < Sequel::Model
  set_dataset :llx_socpeople

  one_to_many :actions, :key => :fk_contact
  many_to_one :societe, :key => :fk_soc

  def to_s
    "#{civilite} #{firstname} #{name}"
  end

  def to_ax
    phones        = phone.blank? ? 'pas de fixe / ' : "#{phone} / "
    phones_perso  = phone_perso.blank? ? 'pas de perso / ' : "#{phone_perso} / "
    phones_mobile = phone_mobile.blank? ? 'pas de mobile' : phone_mobile 
    {
      :id => rowid,
      :civilite => civilite,
      :name => name,
      :firstname => firstname,
      :phone => phone,
      :phone_mobile => phone_mobile,
      :phnoe_perso => phone_perso,
      :email => email
    }
  end

  
end
  
