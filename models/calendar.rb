


class Calendar < Sequel::Model
  set_dataset :ax_agendas
  unrestrict_primary_key

  one_to_many :actions, :key => :ax_agenda_id

  many_to_many :users, :right_key => :fk_user, :left_key => :ax_agenda_id,
               :join_table => :user_axagendas
  
  def as_ax
    { :id => id, :title => title, :color => color, :desc => '', :hidden => false }
  end
end


