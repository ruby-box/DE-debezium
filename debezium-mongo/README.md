# Docker debezium-mongodb
## 구현된 내용
* kafka, kafka connect
* mongodb
* 참고문서 : [github/debezium/debezium-example](https://github.com/debezium/debezium-examples/tree/main/tutorial)
* 데이터레이크 컨플 :
  * Debezium MongoDB : [이동](https://confluence.wemakeprice.com/display/DATALAKE/02.+%28Source+Connector%29+MongoDB)
  * message test 참고 컨플 : [몽고 S/C 관련 데비지움 transforms 중 메세지 flatten(SMT 중 일부) 내용 조사](https://confluence.wemakeprice.com/pages/viewpage.action?pageId=253237275)


## Docker 기동/중지 명령어
```sh
cd debezium-mongo
# 컨테이너 기동
export DEBEZIUM_VERSION=1.6
docker-compose -f docker-compose-mongodb.yaml up

# 컨테이너 중지
# docker-compose -f docker-compose-mongodb.yaml down

# MongoDB 컨테이너 접속
# docker-compose -f docker-compose-mongodb.yaml exec mongodb /bin/bash
```

## MongoDB 명령어
```sh
export DEBEZIUM_VERSION=1.6
# Initialize MongoDB replica set and insert some test data
docker-compose -f docker-compose-mongodb.yaml exec mongodb bash -c '/usr/local/bin/init-inventory.sh'

# Modify records in the database via MongoDB client
# admin account (id/pw) : admin/admin
docker-compose -f docker-compose-mongodb.yaml exec mongodb bash -c 'mongo -u $MONGODB_USER -p $MONGODB_PASSWORD --authenticationDatabase admin inventory'
 
db.customers.insert([
    { _id : NumberLong("1005"), first_name : 'Bob', last_name : 'Hopper', email : 'thebob@example.com', unique_id : UUID() }
]);
```

## kafka & kafka connector 명령어
```sh
export DEBEZIUM_VERSION=1.6
# Start MongoDB connector
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @"config/register-mongodb.json"
 
# Consume messages from a Debezium topic
docker-compose -f docker-compose-mongodb.yaml exec kafka /kafka/bin/kafka-console-consumer.sh \
    --bootstrap-server kafka:9092 \
    --from-beginning \
    --property print.key=true \
    --topic dbserver1.inventory.customers
```
