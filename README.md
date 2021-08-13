# OOS Impact on Sales

Analysis and model for understanding impact of OOS rates and other metrics on sales.

## 1. Setup 
### 1.1. Credentials
Make sure you have your odbc credentials set-up. If not, refer to [this guide](https://github.com/Chewy-Inc/sc-data-science/blob/master/docs/database.md#12-mac).

Also check for Snowflake access, as it is used in part of this project.

#### Install Dependencies
Install the following modules before setting up the connections. They are included in the requirements text file.

## 2. Description of Folders
- summary_results: It contains all the outputs, including images, word documents, and summaries of the model resuls
- queries: It ontains the queries used in the main analysis
- notebooks: It contains the notebooks created
- lost: It contains the python files for database connection
- data: Folder for saving data generated from queries and used in the notebooks. 

## 3. Description of Variables Used
| Variable | Description |
| -------- | ----------- |
|total_views_mc2|	Total PDP page views per mc2; trigger event: detail|
|conversions_purchase_mc2|	How many PDP page views converted to purchase per mc2|
|conv_purc_mc2_rate|	How many PDP page views converted to purchase by the total PDP page views per mc2|
|total_views|	Total PDP page views for all mc2 combined; trigger event: detail|
|conversions_purchase|	How many PDP page views converted to purchase for all mc2 combined|
|conv_purc_rate|	How many PDP page views converted to purchase by the total PDP page views for all mc2 combined|
|conv_purc_to_all|	How many PDP page views (per mc2) converted to purchase by the total PDP page views for all mc2 combined|
|total_views_perc|	Total PDP page views per mc2 by the total PDP page views for all mc2 combined|
|oos_rate|	How many times items were oos by the items count per week|
|total_price*|	Total price for units ordered, excluding canceled orders|
|ordered_qty|	Total units ordered, excluding canceled orders|
|autoship_qty|	Total units ordered that were flagged autoship, excluding canceled orders|
|conv_order_mc2_rate|	Total units ordered per mc2 by the total PDP page views per mc2|
|total_visits_mc2|	Total visits (any event) per mc2|
|total_visits_all|	Total visits (any event) all mc2 combined|
|total_visits_exc|	Total visits (any event) all mc2 combined, excluding the mc2 being studied|
|lagged_oos_rate|	Lagged oos_rate variable by one week|
target variable*

