


class Calendar < ActiveRecord::Base
  self.table_name = 'ax_agendas'

  def as_ax
    { :id => id, :title => title, :color => color }
  end

  

end
