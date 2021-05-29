
DZIEN=$(date +%u)

for i in `docker inspect --format='{{.Name}}' $(docker ps -q) | cut -f2 -d\/`
        do container_name=$i
                if [[ $i == *"DBPOSTGRE"* ]]; then
			if [[ $i == *"zabbix"* ]]; then
#				docker exec $i /bin/bash /backup/pg/backup_db.sh
				for db in `docker exec $i psql -U zabbix -l | grep "|" | tail -n +2 | grep -v template* | grep -v postgres  |cut -d "|" -f 1`
                        	do
                               	docker exec $i pg_dump -U zabbix > /backup/pg/$db-day-$DZIEN.sql
                        	done
			else
                        	for db in `docker exec $i psql -U postgres -l | grep "|" | tail -n +2 | grep -v template* | grep postgres  |cut -d "|" -f 1`
                        	do
                                	docker exec $i pg_dump -Z1 -Fc -U postgres --clean $db > /backup/pg/$db-day-$DZIEN.sql
                        	done
			fi
                fi
done

