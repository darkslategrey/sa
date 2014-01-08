

class Group < Sequel::Model
  set_dataset :llx_usergroup

  many_to_many :users, :left_key => :fk_usergroup, :right_key => :fk_user,
               :join_table => :llx_usergroup_user
end

class User < Sequel::Model
  set_dataset :llx_user

  many_to_many :groups, :left_key => :fk_user, :right_key => :fk_usergroup,
               :join_table => :llx_usergroup_user

  one_to_many :author, :key => :fk_user_author, :class => :Action
  one_to_many :done,   :key => :fk_user_done,   :class => :Action
  one_to_many :todo,   :key => :fk_user_action, :class => :Action
  
  def has_events?
    author.size > 0 and return true
    done.size   > 0 and return true
    todo.size   > 0 and return true
    return false
  end
end
