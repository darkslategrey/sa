


Sequel.migration do
  change do
    create_table(:user_axagendas) do
      foreign_key :fk_user, :llx_user
      foreign_key :ax_agenda_id, :ax_agendas
    end
  end
end
