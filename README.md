# vgsales-db

In this project, we build data warehouse from game sales, platform, publisher, developer, etc. 

## Cleaning
### Clean up CSV from Python script
```sh
```

### Import clean data to DBMS
- Launch ```db-import.sh```, the script will create decoy tables to hold clean CSV data, create triggers on decoy tables so that when you insert clean data using ```COPY...```, the data will be transfered to the final tables.

![](https://i.imgur.com/9W5xbYh.jpg)

- In the script, modify the below line to fit your setup:
```sh
PGUSERNAME="postgres"
DBNAME="vgsales-db"
HOSTNAME="localhost"
PORT="5432"
export PGPASSWORD="postgres"
```

- Then launch
```sh
sh scripts/db-import.sh # Wait until it's done
```
