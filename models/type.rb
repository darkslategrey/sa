


class Type < Sequel::Model
  set_dataset :llx_c_actioncomm

  one_to_many :actions, :key => :fk_action
end



