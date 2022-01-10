# MariaDB ColumnStore Quick Start

[MariaDB ColumnStore](https://mariadb.com/docs/features/mariadb-columnstore/) is a columnar storage engine that utilizes a massively parallel distributed data architecture. ColumnStore is designed for big data scaling to process petabytes of data, linear scalability and exceptional performance with real-time response to analytical queries. 

**This README provides steps to get you up and running with MariaDB ColumnStore using a [Docker](https://www.docker.com/) container**

## Prerequisites 

Before getting started with this walkthrough you will need:

* [Docker Desktop](https://www.docker.com/get-started)
* [git](https://git-scm.com/) (optional)

## Overview

This walkthrough will step you through the process of installing, accessing and configuring single-node MariaDB ColumnStore instance, made available through MariaDB Community Server within a Docker container. 

**Note:** To use this download, import and use this data on an existing, non-container MariaDB Server instance (including [MariaDB SkySQL](https://mariadb.com/skyview)) jump to step #4.

### 1. Using a Docker image to create a Docker container

Pull down the [MariaDB Community Server (with ColumnStore) image](https://hub.docker.com/r/mariadb/columnstore) and create a new container by executing the following command in a terminal window:

```bash
$ docker run -d -p 3306:3306 --name mcs_container mariadb/columnstore
```

### 2. Enter the newly created container

```bash
$ docker exec -it mcs_container bash
```

**Note:** The next several steps involve work within the Docker container, but that is not a hard requirement. The scripts within this repository will also work outside of the container as well.

### 3. Install [git](https://git-scm.com/) using [yum](http://yum.baseurl.org/)

```bash
$ yum install git
```

### 4. Clone **this** repository

```bash
$ git clone https://github.com/mariadb-corporation/dev-example-columnstore-quickstart.git
```

### 5. Download flight data 

The sample data used in this example comes from the United States Department of Transportation, which provides millions of records of flight data spanning many years.

Use the following command to execute a script that will download US domestic flight data between a `start` and `end` year. 

```bash 
$ ./get_flight_data.sh
```

**Note:** Keep in mind that there are millions of flight records that can take up gigabytes of storage space.

### 6. Create schemas and load data

This repository includes the following schema:

* travel (`database`)
    * **airlines** (`ColumnStore table`) - airlines providing flights within the United States
    * **airports** (`ColumnStore table`) - airports within the United States
    * **flights** (`ColumnStore table`) - US domestic flight records 

In this sample, the [create_and_load.sh](create_and_load.sh) script will be used to create the schemas (via [schema.sql](schema.sql)) and load the following tables:

* travel.airlines - using [data/airlines.csv](data/airlines.csv)
* travel.airports - using [data/airports.csv](data/airports.csv)
* travel.flights - using data that is downloaded with the [get_flight_data.sh](get_flight_data.sh) script

Execute the following command to execute a script to create the schema and load data.

```bash
$ ./create_and_load.sh
```

#### **Additional uses**

The [create_and_load.sh](create_and_load.sh) script can also be used by specifying by database details like `host`, `port`, `user`, and `password`.

./create_and_load.sh [host] [port_number] [user] [password]

```bash
$ ./create_and_load.sh 127.0.0.1 3306 app_user Password123!
```

The script can also be used with a MariaDB SkySQL database (by including a path to the [Certificate authority chain file](https://mariadb.com/products/skysql/docs/instructions/connecting/)). For example:

./create_and_load.sh [host] [port_number] [user] [password] [ca_file_path]

```bash 
$ ./create_and_load.sh analytics-demo.mdb0001390.db.skysql.net 5001 DB00003799 Password123 skysql_chain.pem
```

## Support and Contribution <a name="support-contribution"></a>

Please feel free to submit PR's, issues or requests to this project project or projects within the [official MariaDB Corporation GitHub organization](https://github.com/mariadb-corporation).

If you have any other questions, comments, or looking for more information on MariaDB please check out:

* [MariaDB Developer Hub](https://mariadb.com/developers)
* [MariaDB Community Slack](https://r.mariadb.com/join-community-slack)

Or reach out to us diretly via:

* [developers@mariadb.com](mailto:developers@mariadb.com)
* [MariaDB Twitter](https://twitter.com/mariadb)

## License <a name="license"></a>
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=plastic)](https://opensource.org/licenses/MIT)
