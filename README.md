[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-718a45dd9cf7e7f842a935f5ebbe5719a5e09af4491e668f4dbf3b35d5cca122.svg)](https://classroom.github.com/online_ide?assignment_repo_id=12416434&assignment_repo_type=AssignmentRepo)
# CSCI 422 Project - Josh Ness

## Project Business Goal
This project targets the National Football League (NFL). Through player data, matchup data, and sportbook data, my end goal is to be able to make informed decisions
related to sports betting. By constructing a quality data engineering lifecycle and eventually creating interactive dashboards, I anticipate a successful project.

## Data Sources

My project is interacting with two different data sources, I will provide a semi-detailed overview below.

### Data Source One - nfl-data-py

#### Data Source Information
This data source is free for anyone to use, and can be found [Here](https://pypi.org/project/nfl-data-py/)
Using this datasource consists of installing the library, and then you are free to call its methods to retrieve data.
Various different tables of data can be retrieved, including weekly player stats, roster, schedules and more. Weekly player stats will be the powerhouse of this project. The information is retrievable by passing a list of relevant years that you care about.

#### Data Source Ingestion
I have created a script that is ran to ingest the data. It retrieves several different tables and converts them to CSV format. Not much manipulation is done to any of the data, instead it gets sent to a Azure Datalake where each file is stored in their own blobs. Throughout the process, I have implemented a logger that documents the script runs, and diagnosis and issues should they happen.

### Data Source Two

#### Data Source Information
This data source is an API that has both free and paid plans. The API documentation can be found [here](https://the-odds-api.com/sports-odds-data/nfl-odds.html). I am using the most affordable paid plan, due to how many requests this project requires. Through the API, I am especially interested in the player props endpoint. Unfortunately, this endpoint is new and still being actively improved. It's certainly not in a bad state, but over time I'm expecting some improvements to make it even better.

#### Data Source Ingestion
I have created a separate script for this data source. The script crafts different API calls to get all the desired player prop markets for all the desiered games. The way the endpoint is currently set up, it requires a significant number of requests, making it relatively costly. This data source necessitates immediate processing to convert the JSON response to CSV format, which is then uploaded to my Azure Datalake. Logging is done and saved to the same location as the other data source.

