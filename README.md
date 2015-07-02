## Apex Limit Events

Apex runs in a multitenant environment. The Apex runtime engine strictly enforces limits to ensure that runaway Apex doesn’t monopolize shared resources. If some Apex code ever exceeds a limit, the associated governor issues a run-time exception that cannot be handled. Apex limits are defined in the [Salesforce documentation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_gov_limits.htm). 

This repository contains a force.com project that allows you to visualize and test ApexLimitEvents. Apex Limit Events, currently in pilot (contact your salesforce account executive to be nominated for the pilot program), provides visibility into the state and health of your Apex executions in production. It consists of near real-time events and hourly roll-up aggregate metrics. Each event consists of key information about the Apex execution in the context of a limit including:

* EntryPointId
* EntryPointName
* EntryPointType
* EventTime
* ExecutionIdentifier
* Id
* LimitType
* LimitValue
* NamespacePrefix
* UserId
* Username

To learn more specifics about the Apex Limit Events Pilot functionality, read the pilot [tip sheet](http://bit.ly/apexLimits).

## Installation

The majority of 

The easiest way to install this project into your org is to make use of the workbench tool (http://workbench.developerforce.com).  

1. Download a ZIP of the repository. 
2. Uncompress the files. Find the src folder with the package.xml file in it. Re-zip it on the command line: 
```zip -r deploy.zip src.```
3. Open Workbench (http://workbench.developerforce.com/) 
4. Login to the desired organization with a user that has Modify All Data.  
5. Select *Deploy* from the *migration* menu and when prompted, choose your zip file and select 'Allow Missing Files' checkbox before deploying it.

## Configuration and Usage

To view the ApexLimitEventsPage, you must assign the correct permissions to the user. An example permission set is included in this repository: Apex_Limits permission set.

To generate Apex Limit Event data, you can use the ApexLimitJob class. You will need to schedule it as an Apex job. You can read more about Apex scheduled jobs in the [documentation](https://help.salesforce.com/apex/HTViewHelpDoc?id=code_schedule_batch_apex.htm&language=en_US). ![alt tag] (https://raw.github.com/atorman/apexLimitEvents/master/scheduledApex.png)

To generate a more signficant amount of Apex Limit Event data than the scheduled Apex job, you can also use the limitsHammer.py python script. It calls an Apex Rest API service, also included in this repository, that intentionally fails by exceeding the governor limit treshold. To use this script, you must first change the USERNAME and PASSWORD constants to an authenticated user who can call the limitsTest Apex Rest service. After that, you can either:
1. on a Mac or Linux OS: run from the terminal: ```python limitsHammer.py```
2. on a Linux OS only: copy limitsHammer.py to /bin and modify crontab with the following: ```* * * * * python /bin/limitsHammer.py```

## Credit

Contributors include:

* Adam Torman created and orchestrated the majority of the repository including limitsHammer.py
* Doug Bitting provided significant help with the multi-dimensional Google charts
* Josh Kaplan created the basis of the limitsTest code
* Alex Warshavsky created the original Apex rest service that became limitsTest

This repo is As-Is. All pull requests are welcome.

## Screen Shot
![alt tag] (https://raw.github.com/atorman/apexLimitEvents/master/samplePage.png)# apexLimitEvents
