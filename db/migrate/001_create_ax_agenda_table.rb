
Sequel.migration do
  up do
    create_table :ax_agendas do
      primary_key :id
      String  :name
      String  :title
      Integer :color
    end
  end

  down do
    drop_table :ax_agendas
  end
end

