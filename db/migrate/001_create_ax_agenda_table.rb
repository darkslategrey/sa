class CreateAxAgendaTable < ActiveRecord::Migration
  using(:master, :je, :jd)
  def change
    create_table :ax_agendas do |t|
      t.string :name
      t.string :title
      t.integer :color
      t.timestamps
    end
  end
end
