for i in jobenfance jobdependance master_doli
do
    echo 'drop table ax_agendas' | mysql -u root -padmin $i
    echo 'drop table schema_migrations' | mysql -u root -padmin $i
done
    
