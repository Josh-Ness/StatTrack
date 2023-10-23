[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-718a45dd9cf7e7f842a935f5ebbe5719a5e09af4491e668f4dbf3b35d5cca122.svg)](https://classroom.github.com/online_ide?assignment_repo_id=12416434&assignment_repo_type=AssignmentRepo)
# CSCI 422 Project - NFL Data Analysis and Visualization - Josh Ness

## Overview and Business Goal
This repository targets the National Football League (NFL). By leveraging player data, matchup data, and sportbook data, the end goal is to be able to provide actionable insights that help in making informed betting decisions. To achieve this, an a efficient data engineering cycle is needed to dynamically injest data from different sources and store it in Microsoft Azure. From there, the data will be served to create interactive dashboards that aid in analyzing expectations for any given NFL player. 

## Data Sources
The project interacts with two primary data sources, which are each outlined below.

### Data Source One: nfl-data-py

#### Data Source Information
- **Accessibility**: This data source is free for anyone to use, and can be found [Here](https://pypi.org/project/nfl-data-py/).
- **Functionality**: Using this datasource consists of installing the library, and then you are free to call its methods to retrieve data.
- **Relative Data**: Various different tables of data can be retrieved, including weekly player stats, roster, schedules and more. Weekly player stats will be the powerhouse of this project. The methods to retrieve the data take a list of seasons as an argument.

#### Data Source Ingestion
- **Retrieval**: A single script is ran to ingest the data. It retrieves several different tables and converts them to CSV format. Data wrangling is not very present here.
- **Storage**: The ingestion script benefits from using a buffer to send the CSV format data to Microsoft Azure without ever being in local storage.
- **Logging**: Throughout the ingestion process, a logger is present to document successful runs, or diagnose any issues that arise.

### Data Source Two: The Odds API

#### Data Source Information
- **Accessibility**: This data source is an API that has both free and paid plans. The API documentation can be found [here](https://the-odds-api.com/sports-odds-data/nfl-odds.html)
- **Functionallity**: The project uses the most affordable paid plan, due to how many requests are required. API requests can be made once you register an account to obtain a key.
- **Relative Data**: The main endpoint is the player props endpoint. This endpoint is new and is still being actively improved. It's certainly not in a bad state, but over time changes are expected that will in turn enhance the project.

#### Data Source Ingestion
- **Retrieval**: A single exists to collect data from the API. The script crafts different API calls to get all the desired player prop markets for all the desiered games. The returned data necessitates immediate processing to convert the JSON response to CSV format.
- **Storage**: The ingestion script benefits from using a buffer to send the CSV format data to Microsoft Azure without ever being in local storage.
- **Logging**: Throughout the ingestion process, a logger documents information to the same log as the other source.

