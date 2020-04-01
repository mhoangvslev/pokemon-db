# vgsales-db

In this project, we build data warehouse from game sales, platform, publisher, developer, etc. 

## Cleaning
### Clean up CSV from Python script
- Takes input files from "dataset/raw"
- Put cleaned up files in "dataset/clean"
- You can easily customise the script to change these parameters
```sh
python csv_cleaner.py <in_dir> <out_dir>
```

### Import clean data to DBMS
- Launch ```db-import.sh```, the script will create decoy tables to hold clean CSV data, create triggers on decoy tables so that when you insert clean data using ```COPY...```, the data will be transfered to the final tables.

![](https://i.imgur.com/lnZ22lx.jpg)

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

### Visualisation
We use Grafana to build our dashboard
- [Snapshot](https://snapshot.raintank.io/dashboard/snapshot/nb4wZFJ0yZIjLycNO0uKJl4U5ygWK0pH)
- Import from ```sql/vgsales-db-1585696436321.json```

