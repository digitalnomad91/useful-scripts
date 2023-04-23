

#List all ports used by containers
docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" -a

# Import mysql db in docker container
docker exec <docker_image_id> /usr/bin/mysqldump -uroot --password=<password> <database> > filename.sql


# Test redis connection from within docker container context.
docker run --rm redis redis-cli -h 162.55.243.109 -p 3788
