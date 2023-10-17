# ReadMe for the Ingestion deliverable for the project.

## Overview
The Ingestion phase of your project is a major step towards project completion.  It has multiple deliverables.  
- The primary goal is to programmatically access your two datasets and store them in Azure storage (60 points). 
- The second goal is for you to do some initial exploratory analysis on your dataset (20 points).  
- The third goal is to get started on your final deliverable for this class - this repo.  You will use this same repo for the Transformation & Serving phase of your project.  For this assignment, you should provide an overview of your project along with information on your datasets and how you ingested them in the ReadMe.md for the repo (20 points).

## Data ingestion
The minimum requirement for the project is that you programmatically access your data and upload it to the cloud.  This can be done using your local computer as was done in the ingestion assigmment.  The general idea is that you should be able to refresh your dataset by simply re-running your local script.

Data cleaning and transformation is not a priority for this phase as having the data in raw form is a good practice.  That said, doing basic transformations to get the data into an appropriate structure for the next step makes sense.  For example, converting JSON data to CSV after an API call is reasonable in this phase.  If you are web scraping, converting the data to a Pandas dataframe and doing basic data conversion is also appropriate.

To complete this section using your local computer, add code to DataSet1.py and DataSet2.py in src\ingestion for your datasets. The last step in each of these code files should be an upload to ADLS.  As part of the Ingestion phase, you should create a new storage account with a folder layout that is appropriate for your project.

Allowing you to do this on a local computer is a short cut.  In a fully developed data pipeline, you would do this step using a cloud resource.  That might be directly in an orchestration tool that supports your data source or using a cloud code execution capability like Azure Functions or AWS Lambda. The thought process behind allowing local computer ingestion is a) the code you write is transferable to a cloud capability, and b) working through cloud ingestion and full automation of the ingestion step is beyond the scope of the class. 

You are welcome to use a cloud approach if that is a priority for you for the project.  Doing so successfully will earn high marks on the assignment, including the possibility of extra credit.  If you do so, the structure of the Ingestion portion of the repo will need to align with your cloud approach and not with the expected local computer approach outlined here.  Please keep the structure of src\ingestion, but re-shape the repo as needed from there.

### Evidence and grading
- Code - your code should be well written and easy to read.  No extra commented out code should exist.  Appropriate data and control structures should be used.   The code should be in the src\ingestion folder.
- Azure storage - A screen shot showing the successful upload of your data into Azure storage should be put in the ingestion_analysis folder.  As noted above, a new storage account for your project is expected along with an organization that makes sense for your design.

## Exploratory data analysis
Understanding the nuances of your datasets is essential for your next step of transformations.  Knowing the size of the dataset will drive the compute choice.  Understanding the data types of tabular data columns will determine what you need to do to transform the data into proper numeric, date, or other structures.  Looking at the distribution of values will determine if you have outliers and need to do some form of anamoly detection.  Some columns may have significant missing data and you will need a strategy for dealing with these.

In src\ingestion\ExploratoryAnalysis.py, write some code that explores your datasets.  A library like pandas_profiling can be very helpful for this, but that has scale limitations and may not be the best choice.  This code may need to run on Databricks if the data is very large.

When complete, write a summary document about your data and place it in the SupplementaryInfo\IngestionAnalysis  folder.  The exact type of document is up to you, but having some graphics and tables to summarize the data will be helpful for the reader.

Alternatively, you can use a large language model to analyze your data.  There are tutorials available online that walk you through how to use a tool like ChatGPT for data analysis.  In this case, capture your session via screenshots or export the session.

### Evidence and grading
- Summary description -  a document in the SupplementaryInfo\IngestionAnalysis folder that provides information about the datasets.  
- Code - Python code or similar in src\ingestion (ExploratoryAnalysis.py is the default) that you used to create the information in your document.

## Project documentation
Provide an overview of your project along with appropriate details on your datasets and ingestion process in the README.md in the repo.  This is the first thing that people coming to your repo will see, so it needs to be well written.  Work to find the balance between providing details about the project without getting into too much detail in this top level document.

### Evidence and grading
- A well written README.md covering the project overview, datasets, and ingestion.  This should target an individual coming to your repo for the first time.  The reader should have a good overview of the project and a desire to learn more about it.