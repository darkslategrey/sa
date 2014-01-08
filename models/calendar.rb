


class Calendar < Sequel::Model
  set_dataset :ax_agendas
  unrestrict_primary_key

  one_to_many :actions, :key => :ax_agenda_id
  
  def as_ax
    { :id => id, :title => title, :color => color }
  end
end


