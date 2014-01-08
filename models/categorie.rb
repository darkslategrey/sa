

class Categorie < Sequel::Model
  set_dataset :llx_categorie

  many_to_many :fournisseurs, :left_key => :fk_categorie, :right_key => :fk_societe,
               :join_table => :llx_categorie_fournisseur

  many_to_many :societe, :left_key => :fk_categorie, :right_key => :fk_societe,
               :join_table => :llx_categorie_societe
  

end
