

Sequel.migration do
  up do
    alter_table(:ax_agendas) do
      add_column :shortname, String
    end
    from(:ax_agendas).where(:name => 'Actions Jobenfance').update(:shortname => 'je')
    from(:ax_agendas).where(:name => 'Actions Jobdependance').update(:shortname => 'jd')
  end

  down do
    alter_table(:ax_agendas) do
      drop_column :shortname
    end
  end
end




