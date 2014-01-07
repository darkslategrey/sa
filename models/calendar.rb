


class Calendar < Sequel::Model
  set_dataset :ax_agendas
  unrestrict_primary_key
  def as_ax
    { :id => id, :title => title, :color => color }
  end
end


