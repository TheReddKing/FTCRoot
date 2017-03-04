# Database Structure

Note the reason for this particular data structure was because Heroku limited the rows to 10000 on the free plan. Since this website currently doesn't have any funding, I had to change the structure multiple times to prevent it from taking up too many rows.

## Regions
id

name

## Events
id

region_id (to specific region)

name

date (MM/DD/YYYY)

ftcmatchcode (from ftc-data on github)

competitiontype (type of competition)

data_competition (Details of events, matches separated by "|")

advanceddata (1 if detailed, 0 if not, and null if non existent)

data_stats

advancedstats (1 if exists, null if nonexistent)

data_raw (ie. # of balls scored in teleOP)

advancedraw (1 if exists, null if nonexistent)


## Teams

id (Unique ID)

name

location (string)

location_lat

location_long

data_competions (Add ID values of Events)

blurb

website

contact_email

contact_twitter

contact_youtube

contact_facebook
