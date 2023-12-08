[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-718a45dd9cf7e7f842a935f5ebbe5719a5e09af4491e668f4dbf3b35d5cca122.svg)](https://classroom.github.com/online_ide?assignment_repo_id=12416434&assignment_repo_type=AssignmentRepo)

# StatTrack
### Data Driven Sports and Betting Decisions by Josh Ness

![StatTrack Logo](/SupplementaryInfo/StatTrack%20Logo.png)


## Overview and Business Goal
Over 60% of online gambling revenue comes from sports betting, and by 2024, the sports betting market is expected to be valued at over 155 billion USD. This market will continue growing, with a predicted compound annual growth of 14.6% until 2030.

By leveraging player data, matchup data, sportsbook data and more, the goal of StatTrack is to provide actionable insights that help in making informed betting decisions. Eventually, the data pipeline will be used in a application that bettors can use on their mobile devices. To achieve this, an a efficient data pipeline is needed to dynamically injest data from different sources, store, transform, and serve the data.

## Data Sources
Currently, StatTrack is specific to the NFL. It utilizes two main data sources, but should additional sports be added in the future, that would likely introduce additional datasets. Any current data sources will be highlighted below.

### Data Source One: nfl-data-py

#### Data Source Information
- **Accessibility**: This data source is free for anyone to use, and can be found [here](https://pypi.org/project/nfl-data-py/). This source is NFL specific.
- **Functionality**: Using this datasource consists of installing the library, which can be used to call methods and retrieve data.
- **Relative Data**: Various different tables of data can be retrieved, including play-by-play stats, roster, schedules and more. Play-By-Play stats will be the powerhouse of StatTrack.

### Data Source Two: The Odds API

#### Data Source Information
- **Accessibility**: This data source is an API that has both free and paid plans. The API documentation can be found [here](https://the-odds-api.com/sports-odds-data/nfl-odds.html). 
- **Functionallity**: StatTrack utilizes the most affordable paid plan, due to how many requests are required. API requests can be made once you register an account to obtain a key. The API is still being developed and there are high hopes for improvement in the future.
- **Relative Data**: The main endpoint is the player props endpoint. This endpoint is new and is still being actively improved. Over time, changes are expected that will in turn enhance the project.

## Data Engineering Lifecycle

## Ingestion
Each source used within StatTrack has its own ingestion script, but they follow simillar practices. Data is loaded into a DataFrame after retreival from its source, whether that is an API or a python client. Wrangling in this stage is minimal, but there is some that gets done. 
- If data is unstructured (JSON), it is flattened into structured data.
- Columns are renamed into cleaner names that will be used in the database.

After data is loaded into a DataFrame, it is sent to a custom function that sends it as a parquet file to the desired location within Microsoft Azure Blob Storage. This function uses a buffer to send the file without ever having to use local storage. 

## Transformation
StatTrack uses Azure Functions to bridge ingestion and blob storage to the next step, transformation. Immedietly after new data is saved to the blob storage via the ingestion scripts, it is detected by BlobTrigger functions within an Azure Function App. These trigger functions load the parquet files into a DataFrame. Once loaded, a custom function is called that crafts a SQL BULKINSERT function based off of the DataFrame's column names, hence the reason for renaming them previously. The trigger function then connects to StatTrack's database and uses the crafted query to insert new data into the staging tables of the database. 

Most of the transformation occurs now that the data is in staging tables nad beings prepped to go into a finalized star schema. All transformations are in a stored procedure, which is called at the end of the BlobTrigger functions after all data is already within the staging tables. Transformations include:
- Converting unecessary string columns to better formats. For example, within a 'Field Goal Result' column, values are changed from 'good' or 'missed' to 1 or 0.
- Creation of a column in the player props table that generates player information into a player id used by other tables in the database.
- Converting all columns to the most appropriate format, whether that be type DECIMAL, BIT, DATETIE, or other.
- Ensuring all PK and FK constraints within the star schema are respected.
- Several other transformations

Once all necessary wrangling is done, the data finally is inserted into the star schema tables, as long as the primary keys don't already exist. If they do exist, it checks whether or not information has changed, meaning that there was a stat correction. If data has in fact changed, it updates the existing data with the new data. Once again, this whole process is automatic and will be done immedietly after ingestion. 

## Serving
StatTrack is currently using PowerBI that connects to the database. From here, users can interact with various powerful visualizations.
- Users could see how many receptions a player had game, or see exactly how many yards each reception of theirs earned the team.
- Users could find out how many rushing a receiving yards and player has on average at a specific stadium, against a specific opponent, in certain weather, and much more.
- Users can track how a players betting lines compare to how they hve historically performed under certain conditions.

## Future
While StatTrack has its full data pipeline in place, there are plans to improve its serving powers. In the future, possibilities include:
- **Application**: A mobile StatTrack application that will offer free and paid versions of the app. 
- **Insights**: In the future, StatTrack hopes to use AI to geerate quick helpful insights. For example, providing an insight that 'Kirk Cousins has thrown for over 274.5 passing yards in 9 of his last 10 games where the Minnesota Vikings were underdogs on the road.

## Responsibility
While data can help make informed decisions, sports betting is a form of gambling. Even with StatTrack, nothing is guarenteed to happen within sports, and all users must acknowledge the risk of betting participation.