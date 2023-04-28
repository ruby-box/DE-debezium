# Start the topology as defined in https://debezium.io/documentation/reference/stable/tutorial.html
export DEBEZIUM_VERSION=1.6
docker-compose -f docker-compose-mongodb.yaml up
 
# Initialize MongoDB replica set and insert some test data
# docker-compose -f docker-compose-mongodb.yaml exec mongodb bash -c 'scripts/init-inventory.sh'
