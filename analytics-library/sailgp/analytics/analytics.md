# SailGP Data Analysis

![Banner](images/banner.jpg)

## Introduction

In this lab you'll get a taste of what it is to be a Data Athlete for SailGP! One of their jobs is to do a post-race analysis. The goal of such an analysis is to find out why one boat finishes before the other one. You'll do this by looking for clues in the data and calculate various performance metrics. The final goal of this is to help the sailing teams to perform better in the upcoming race!

In this lab we'll start with some basic statistics such as the time that it takes each team to finish the race, the maximum speed that the teams achieve and the amount of time that they are able to foil (let the boat rise out of the water).

The tool that will make this possible is **Oracle Analytics Cloud** (OAC), which will work on data that's stored and processed by **Oracle Autonomous Data Warehouse** (ADW).

<!--
[](youtube:Sf5MkI9pTn0)
-->

__Estimated Lab Time:__ 20 minutes

### Objectives
- Learn how a SailGP Data Athlete extracts valuable insights from sensor data
- Learn how to use Oracle Analytics Cloud to prepare and analyze data

### Prerequisites
- An Oracle Free Tier, Always Free, Paid or Live Labs Cloud Account
- Oracle Analytics Cloud
- Autonomous Data Warehouse

## **STEP 1**: Create the connection from Oracle Analytics Cloud to Autonomous Database

**Oracle Analytics Cloud** will be the tool which you use to analyze your data. **Autonomous Data Warehouse** is used to store and organize the data.
Therefore we need to create a connection from Oracle Analytics Cloud to Autonomous Data Warehouse first. To be able to create this connection, OAC will need to use a so-called "wallet" file. The wallet file (client credentials), along with the database user ID and password, provides access to your Autonomous Database in the most secure way possible. The "wallet" file can be obtained from the database menus.

1. In Oracle Cloud, click the **Navigation Menu** in the upper left, navigate to **Oracle Database**, and select **Autonomous Data Warehouse**.

	![Oracle Console SignIn](images/adw_menu.png)

   You can see all the **ADW** instances that you have **created**.
   **Select** the instance `SAILGP` that we created before.

   ![ADW databases list](images/select-sailgp-database.png)

2. We will download the wallet file. The wallet file (client credentials), along with the database user ID and password, provides access to your Autonomous Database in the most secure way possible.

   > NOTE: Store wallet files in a secure location. Share wallet files only with authorized users.

3. On the ADW detail page,click **DB Connection**.

   ![AWD DB Connection](images/adw_db_connection.png)

4. Click **Download Wallet** on Database Connection side-screen. Leave  the default value `Instance Wallet` as the **Wallet Type**. Finally, click **Download Wallet**.

   ![AWD Download Wallet](images/adw_download_wallet.png)

5. Type the password, confirm the password by typing it again and click **Download**.

      - Password: `Oracle_12345`
      - Confirm Password: `Oracle_12345`

   ![AWD Wallet Password](images/adw_wallet_password.png)

6. Click **Close**. A `ZIP` file will start downloading.

   ![AWD Download Wallet](images/adw_download_wallet.png)

7. Use the Wallet in Oracle Analytics Cloud

   **Return** to the **Oracle Cloud Infrastructure console** and click on the menu icon on the left.

   Navigate to **Analytics & AI** and then **Analytics Cloud**.

   ![OAC Web Console](images/analytics-oac.png)

8. **Open** the Cloud Analytics **URL** associated with your instance (the one that we created in Lab 2) by using the dots menu button on the right-hand side of your instance information and selecting **Analytics Home Page**.

   > Make sure your Oracle Analytics Cloud instance is in status `Active` (not `Creating`) before you go to **Analytics Home Page**.
   >
   > Be patient, Analytics Cloud sometimes can take few more minutes to provision.

   ![Cloud Analytics URL](images/select-oac-instance.png)

   The **Oracle Analytics** page will open in a new browser **window/tab**.

9. On the top right-hand side of the screen, click **Create**, and then **Connection**.

   ![Connection Creation](images/oac-create-connection.png)

10. Choose **Oracle Autonomous Data Warehouse**.

   ![Connection Creation - ADW](images/select-adw.png)

   Use the following information to configure your **connection**.

   > **Connection Name**: `SAILGP`
   >
   > **Client Credentials**: Use the Browse button to upload the **wallet zip> file** that you downloaded. It will automatically extract the `cwallet.sso` file from this zip bundle.
   >
   > **Username**: `SAILOR`
   >
   > **Password**: `Oracle_12345`
   >
   > **Service Name**: Keep the default, the name of your database followed by the `_high` suffix.
   >

   ![Connection Creation](images/oac-adw-connection-details-admin.png)

11. Select **Save** to save your new connection **information**.

## **STEP 2:** Add the dataset to Oracle Analytics Cloud

We're going to take a deep dive on the SailGP regatta that took place in Bermuda in April 2021. In particular, we are going to have a look at race 4 (out of 7 in total). We're going to do a post race analysis with the goal of helping the teams perform better in the upcoming race.

Earlier, we uploaded the data of this race to Autonomous Data Warehouse. Now, we have to make this available to Oracle Analytics Cloud.

1. On the top right, choose **Create** and then **Data Set**.

   ![Create dataset](images/create-dataset.png)

2. Select the `SAILGP` connection.

   ![Select SAILGP connection](images/select-sailgp-connection.png)

3. Open the `SAILOR` schema and **double click** on the `SGP_STRM_PIVOT` table.

   ![Add dataset](images/add-dataset.png)

   Each record in this data set represents one second of the race for one particular team.
   At each second of the race, we can see the values of many of the sensors of the boat of each team.

   You see how Oracle Analytics is profiling the columns in the data set. It creates histograms and other charts of each of the columns to quickly give you insight into what value there is in them. For example, have a look at column `B_NAME`. This shows you that there are 8 countries that are competing (column `B_NAME`). And have a look at `LENGTH_RH_BOW_MM`, Which shows you how far the boat lifts out of the water, the values appear to hover between 0 and 1.5m above the water.

   These graphs are a great way to quickly get an understanding of your data.

4. Configure the details of the dataset

   Now at the bottom of the screen, click on `SGP_STRM_PIVOT` to configure the details of the dataset.

   ![Details dataset](images/details-dataset.png)

5. Modify `TIME_GRP` column

   This attribute contains the time in the race, in seconds. For example, -30 indicates 30 seconds before the start of the race. Value 0 indicates the start of the race, et cetera.

   Right now it is classified as a `MEASURE` (visible because of the # symbol). However, we will not use this attribute to calculate, therefore we will convert this into an `ATTRIBUTE`.

   Click the header of the `TIME_GRP` column, then click the value next to **Treat As** and change it to **Attribute**.

   ![Change TIME_GRP to attribute](images/change-timegrp-to-attribute.png)

   The symbol next to the column header changes to `A`.

6. **Pivot** the representation

   Pivot the presentation so it becomes easier to modify the column configuration.

   ![Change TIME_GRP to attribute](images/change-representation.png)

7. Modify the **Aggregation** type of `BOAT_SPEED_KNOTS` (boat speed in knots)

   Later on, we will want to obtain the Maximum Boat Speed for each team. Because of this, we want to set the default aggregation of the `BOAT_SPEED_KNOTS` field to **Maximum**.

   Find the `BOAT_SPEED_KNOTS` column and click it, then change the aggregation to **Maximum**.

   ![Change aggregation to maximum](images/boat-speed-max.png)

<!--
8. Modify the aggregation type of TWS_MHU_TM_KM_H_1 (wind speed)

   Similarly, later on we'll want to obtain the Average Wind Speed.
   Because of this, we want to set the default aggregation of the TWS_MHU_TM_KM_H_1 (wind speed) to "Average".

   Find the TWS_MHU_TM_KM_H_1 column and click it, then change the aggregation to "Average".

   ![Change aggregation to average](images/tws-average.png)
-->

8. Save the data set

   Finally, click the **Save** icon and give the data set a logical name, e.g. **Race Data**.

   ![Set name and save data set](images/save-dataset.png)

## **STEP 3:** Basic statistics

1. Still in the data set editor, on the top right, click **Create Project**.

   ![Change aggregation to average](images/create-project.png)

   Now you have prepared your data, you are ready to start creating some visualizations and finally get some insights!

	Now you are in the Visualization area!

	> NOTE: As a general note, keep in mind that you can use the Undo/Redo buttons at the top right of the screen if you make any mistake in this section.
   >
   > ![Undo](images/undo.png)

2. See who were the winners of the race

   Let's start with our first visualization challenge: Find out who took the least time to go from start to finish by creating a chart on `B_NAME` (team name) and `TIME_SAILED` (the number of seconds they were sailing).

   Drag `B_NAME` to the canvas.

   ![pic1](images/drag-bname.png)

   Find the `TIME_SAILED` column and drag it to the canvas as well.

   ![pic1](images/drag-time-sailed.png)

   The result should look like this. You have a simple table with the time that each team took to complete the race.

   Let's make this a bit easier to interpret: Change the representation to Horizontal Stacked bar chart.

   ![pic1](images/change-to-horbar.png)

   We want to see the fastest team first, so let's change the sorting. Click the **Sorting** icon (top right).

   ![pic1](images/change-sorting.png)

   Configure the sorting to be by `TIME_SAILED` from low to high.

   ![pic1](images/change-sorting2.png)

   We can see that Great Britain was the winner, followed by Australia.

   Actually, Japan and the USA did not finish the race because they collided. Let's remove them from the outcome by adding a filter. Drag `B_NAME` to the filter area.

   ![pic1](images/drag-bname-to-filter.png)

   Then configure the filter to include all countries apart from `JPN` and `USA`. You see how the chart now contains only the 6 remaining teams.

   ![pic1](images/configure-filter.png)

   You can see that the boats that finished last were France and Denmark, we will now compare France and Denmark to Great Britain to see how they are different. Hopefully we will find some indicators on where France and Denmark can make improvements.

3. Compare maximum boat speeds

   Which teams are able to obtain the maximum speed with the boat? Let's find out!

   Right click on the `BOAT_SPEED_KNOTS` field and choose **Create Best Visualization**.

   ![pic2](images/visualize-knots.png)

   This shows the maximum speed across all boats in this race. In fact, this was a new record for all SailGP races so far! 51 knots per hour is over 94 kilometers per hour or 59 miles per hour!

   Now, show what the maximum speeds are for all countries, by dragging `B_NAME` onto the same chart.

   ![pic2](images/drag-bname2.png)

   Change the chart type to **Horizontal Stacked**.

   ![pic2](images/change-chart-type.png)

   **Sort** the chart by boat speed.

   ![pic2](images/sort-icon.png)
   ![pic2](images/sort-by-boat-speed.png)

   In this case, the teams that have the higher maximum speed also are the teams that are finishing highest. However we have to be careful drawing any conclusions from this. Remember, in sailing the highest speed doesn't necessarily mean the best track taken through the course, nor that you will be the winner.

   ![pic2](images/conclusion.png)

4. Investigate how much the teams are foiling

   Foiling is the phenomenon where boats go fast enough to rise out of the water. Because they rise of the water, they have less water resistance, resulting in even higher speeds. Because of this, teams will always try to foil as much as possible. Let's see how well the teams are able to foil.

	 ![pic2](images/f50-foiling.png)

   First create a calculation to calculate the percentage of time that teams are foiling. We can use the `TIME_SAILED` (total time to complete race) and `TIME_FOILING` for this. Add a calculation (right click on **My Calculations**) with the name `Foiling Percentage` and create the following formula. Remember that you can drag the fields in from the left to add them to the formula.

   It should look like this:

   > `(TIME_FOILING / TIME_SAILED) *100`

   ![pic2](images/foiling-percentage.png)

   Now create a chart to display the foiling percentage for all the teams. First, create a new chart with overall foiling percentage by right clicking on the new Foiling Percentage field and choosing **Create Best Visualization**.

   ![pic2](images/foiling-percentage2.png)

   Now add the `B_NAME` column in the visualization to show the foiling percentage per team.

   ![pic2](images/drag-bname3.png)

   Change the chart type to **Horizontal Bar Stacked**.

   ![pic2](images/change-chart-type2.png)

   And change the sorting to be on Foiling Percentage **High to Low**.

   ![pic2](images/change-sorting3.png)

   We can see that, although Denmark does a good job foiling, they are still the last team to cross the finish line.

	![pic2](images/conclusion-denmark.png)

   Save the project with name `Basic statistics on Bermuda race 4`.

   ![pic2](images/save-project.png)

   Go back to the **Home Page**.

   ![pic2](images/to-homepage.png)

Congratulations on completing this lab! Now you're ready to move on to the next part of the post-race analysis: analyzing the start of the race.

## **Acknowledgements**

- **Author** - Jeroen Kloosterman, Technology Product Strategy Director
- **Author** - Victor Martin, Technology Product Strategy Manager
- **Contributor** - Priscila Iruela
