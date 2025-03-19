# Cyclistic Data Analytics Case Study: How Does a Bike-Share Navigate Speedy Success?

## Scenario

I am a junior data analyst working in the marketing analyst team at Cyclistic, a fictional bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, my team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, my team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve my recommendations, so they must be backed up with compelling data insights and professional data visualizations. I shall be following Google’s Data Analytics Process – Ask, Prepare, Process, Analyze, Share, and Act.

## Characters and teams

● Cyclistic: A bike-share program that features more than 5,800 bicycles and 600 docking stations. Cyclistic sets itself apart by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities and riders who can’t use a standard two-wheeled bike. The majority of riders opt for traditional bikes; about 8% of riders use the assistive options. Cyclistic users are more likely to ride for leisure, but about 30% use them to commute to work each day.

● Lily Moreno: The director of marketing and my manager. Moreno is responsible for the development of campaigns and initiatives to promote the bike-share program. These may include email, social media, and other channels.

● Cyclistic marketing analytics team: A team of data analysts who are responsible for collecting, analyzing, and reporting data that helps guide Cyclistic marketing strategy. I joined this team six months ago and have been busy learning about Cyclistic’s mission and business goals — as well as how I, as a junior data analyst, can help Cyclistic achieve them.

● Cyclistic executive team: The notoriously detail-oriented executive team will decide whether to approve the recommended marketing program.
 
## About the company

In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.

Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments.

One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.

Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a very good chance to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.

Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. Moreno and her team are interested in analyzing the Cyclistic historical bike trip data to identify trends.

## Marketing Strategy

Three questions will guide the future marketing program:

1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?

**Moreno has assigned me the first question to answer:**
*How do annual members and casual riders use Cyclistic bikes differently?*

I will have to produce a report with the following deliverables:

1. A clear statement of the business task
2. A description of all data sources used
3. Documentation of any cleaning or manipulation of data
4. A summary of my analysis
5. Supporting visualizations and key findings
6. My top three recommendations based on my analysis

<br/>

## ASK PHASE - A Clear Statement of the Business Task

To provide the marketing team with insights regarding consumer behavior to help them design marketing strategies aimed at converting casual riders into annual members.

## PREPARE PHASE - A Description of All Data Sources Used

Cyclistic’s historical trip data - [here](https://divvy-tripdata.s3.amazonaws.com/index.html)

The data has been made available by Motivate International Inc. under this license - [here](https://www.divvybikes.com/data-license-agreement)

I used 12 months of Cyclistic’s data starting from October, 2021 to September, 2022.

The dataset contains CSV files of each month, with these 13 columns;

A. ride_id: A unique ID for each ride.

B. rideable_type: The type of bike used in the ride.

C. started_at: Start timestamp of the ride.

D. ended_at: End timestamp of the ride.

E. start_station_name: Name of starting station.

F. start_station_id: Numeric ID of starting station.

G. end_station_name: Name of ending station.

H. end_station_id: Numeric ID of ending station.

I. start_lat: Latitude of starting station.

J. start_lng: Longitude of starting station.

K. end_lat: Latitude of ending station.

L. end_lng: Longitude of ending station.

M. member_casual: Defines whether the customer is a "member" or a "casual".

## PROCESS PHASE - Documentation of Any Cleaning or Manipulation of Data

* I opened each CSV spreadsheet and created a column called “ride_length.” I calculated the length of each ride in minutes by subtracting the column “started_at” from the column “ended_at” using the `=MOD(RIGHT(D2, 8)-RIGHT(C2, 8), 1)\*1440` command in each file. The `MOD` function is necessary to take care of negative results in the subtraction.

* Next, I created a column called “day_of_week,” and calculated the day of the week that each ride started using the `=WEEKDAY(LEFT(C2, 10))` command in each file. I formatted as “Custom dddd” in order to display the day of the week as text rather than number.

* Again, I created a new column called “ride_hour”, and obtained the hour each ride started using the `=MID(C2, 12, 2)` command in each file.

* Finally, I created a new column called “month_of_year”, and obtained the month for each ride using the `=LEFT(C2, 7)` command in each file.

* Then I went ahead to import each of the CSV files into a new database which I created for them in SQL Server. I united all the 12 tables into one single table and began to carry out further cleaning and exploration.

Two notes about the Cyclistic data:

1) The dataset contains a total of 5,470,672 rows.
3) After removing records with nulls and inconsistent data using SQL, I observed that 278,031 rows have trip duration of less than 3 minutes each. For the analysis, only trips 3 minutes or greater will be taken into account to remove any potential bookings made in error by the user.
4) Finally I have 3,952,294 rows of data left after removing nulls, inconsistent data as well as those trip records that are less than 3 minutes in duration. This is the size of data I will be working with.

## ANALYZE PHASE - A summary of my analysis

I did my analysis using SQL.

To see the details of my queries, [click here](code/analysis.sql)

The average trip duration of casual riders (25 mins) is more than double that of members (13 mins). This is possibly because members use the bikes just to get from point A to point B, while casual riders use them for leisure.

![average ride length by member and casual](charts/average_ride_length_by_member_casual.png)
 
 <br/>
 
Next let’s look at the hourly usage trends. 
 
![rides per hour by member and casual](charts/rides_per_hour_by_member_casual.png)
 
Here we can see that members’ usage has two peaks, the first around 8 a.m. and the second around 5 p.m. corresponding with the start and end of the workday. Casual riders on the other hand, start using the bikes more beginning from mid-day until evening.

In terms of daily usage, the data shows that members’ usage trend remain fairly consistent minutes difference between the peak on Sunday and the low on Wednesday.
 
![rides per weekday by member and casual](charts/rides_per_weekday_by_member_casual.png)
 
 <br/>
 
In this monthly usage chart, we can see that both members and casual riders show a similar trend with more trips made in the warmer months, peaking in July, and less trips during winter, with the least trips in January.

![rides by member casual by month](charts/rides_by_member_casual_by_month.png)

 <br/>
 
## SHARE PHASE - Supporting visualizations and key findings

The full dashboard and visualization sheets are available [here]{https://public.tableau.com/app/profile/donatus.enebuse).

## ACT PHASE - My top three recommendations based on my analysis

To guide the marketing campaign to convert casual riders into annual members, we now have some data driven insights on how casual riders and annual members use Cyclistic’s bikes differently. The key findings and my recommendations for the marketing campaign are as follows:
1) Casual riders prefer to take longer trips averaging 25 minutes per trip compared to members who average only 13 minutes. Use this statistics to show casual riders how they could save more money in the long run.
2) Casual riders prefer to use Cyclistic bikes on the weekends where the number of users are almost twice as much as users in the middle of the week. Develop a weekend membership plan whereby rides on the weekends are included in the base price while members have the option to book weekday rides at a lower rate.
3) Casual riders mostly use the bikes within the hours of 12 pm to 5 pm. Devise a membership plan where rides within this period are also included in the base price while members have the option to book rides at 8 am and at 5 pm at a discount.
