

class Societe < Sequel::Model
  set_dataset :llx_societe

  one_to_many :actions,  :key => :fk_soc
  one_to_many :contacts, :key => :fk_soc

  many_to_many :cat_fourn, :left_key => :fk_societe, :right_key => :fk_categorie, :class => :Categorie,
               :join_table => :llx_categorie_fournisseur

  many_to_many :cat_soc,   :left_key => :fk_societe, :right_key => :fk_categorie, :class => :Categorie,
               :join_table => :llx_categorie_societe
end
