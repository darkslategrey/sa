
Sequel.migration do
  change do
    add_column :llx_actioncomm, :ax_agenda_id, Integer
  end
end
