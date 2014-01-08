


class Contact < Sequel::Model
  set_dataset :llx_socpeople

  one_to_many :actions, :key => :fk_contact
  many_to_one :societe, :key => :fk_soc
end
  
