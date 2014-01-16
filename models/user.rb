

class Group < Sequel::Model
  set_dataset :llx_usergroup

  many_to_many :users, :left_key => :fk_usergroup, :right_key => :fk_user,
               :join_table => :llx_usergroup_user


end

class User < Sequel::Model
  set_dataset :llx_user
  set_primary_key :rowid
  
  many_to_many :groups, :left_key => :fk_user, :right_key => :fk_usergroup,
               :join_table => :llx_usergroup_user

  many_to_many :agendas, :left_key => :fk_user, :right_key => :ax_agenda_id, :class => :Calendar,
               :join_table => :user_axagendas
  
  one_to_many :author, :key => :fk_user_author, :class => :Action
  one_to_many :done,   :key => :fk_user_done,   :class => :Action
  one_to_many :todo,   :key => :fk_user_action, :class => :Action
  
  def has_events?
    author.size > 0 and return true
    done.size   > 0 and return true
    todo.size   > 0 and return true
    return false
  end


  def to_ax
    {
      :nom => "#{firstname} #{name}",
      :id  => rowid,
      :selected => true,
      :cid => agendas.first.id
    }
  end

  
  # def self.ax_find params, dbs
  #   [{:nom => 'greg', :id => '}]
  # end

  
end
