


class Contact < Sequel::Model
  set_dataset :llx_socpeople

  one_to_many :actions, :key => :fk_contact
  many_to_one :societe, :key => :fk_soc

  def to_s
    "#{civilite} #{firstname} #{name}"
  end

  def to_ax
    {
      :id => rowid,
      :civilite => civilite,
      :name => name,
      :firstname => firstname,
      :phone => phone,
      :phone_perso => phone_perso,
      :phone_mobile => phone_mobile,
      :email => email
    }
  end

  
end
  
