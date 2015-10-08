drop table brian.reviews;

create table brian.reviews(

user_id varchar(50),
review_id varchar(50),
stars int,
date date,
text varchar(50),
type varchar(16),  
business_id varchar(50),
user_id2 varchar(50),
funny_votes int,
useful_votes int,
votes_cool int,
review varchar(8000)
);


truncate table brian.reviews;
copy brian.reviews from 's3://ncarb-dsteam/Brian/Yelp/reviews.tsv'
credentials 'aws_access_key_id=[access_key];aws_secret_access_key=[secret]'
delimiter '\t'
REMOVEQUOTES
IGNOREHEADER as 1
DATEFORMAT AS 'YYYY-MM-DD';

select * from brian.reviews where lower(review) like '%awesome%' limit 4000;


drop table brian.tips;
create table brian.tips (
business_id varchar(50),
user_id varchar(50), date date, text varchar(8000),likes int,type  varchar(7)
);

truncate table brian.tips;
copy brian.tips from 's3://ncarb-dsteam/Brian/Yelp/tips.tsv'
credentials 'aws_access_key_id=[access_key];aws_secret_access_key=[secret]'
delimiter '\t'
REMOVEQUOTES
IGNOREHEADER as 1
DATEFORMAT AS 'YYYY-MM-DD';

drop table brian.checkins;
create table brian.checkins (
business_id varchar(50),  "9-Friday" int, "7-Friday" int, "13-Wednesday" int,
"17-Saturday" int,"13-Sunday" int,"17-Wednesday" int,"10-Sunday" int,
"18-Thursday" int,"14-Saturday" int,"22-Friday" int,"15-Monday" int,
"15-Thursday" int,"16-Tuesday" int,"21-Thursday" int,"13-Monday" int,
"14-Thursday" int,"12-Friday" int,"12-Monday" int,"9-Monday" int, 
"18-Wednesday" int,"15-Tuesday" int,"8-Thursday" int, "17-Friday" int,
"17-Thursday" int,"11-Tuesday" int,"12-Thursday" int,"10-Thursday" int,
"8-Monday" int, "9-Thursday" int, "9-Sunday" int, "18-Monday" int,
"19-Saturday" int,"7-Saturday" int, "11-Friday" int,"11-Thursday" int,
"17-Tuesday" int,"6-Friday" int, "12-Tuesday" int,"7-Thursday" int, 
"18-Tuesday" int,"16-Monday" int,"19-Tuesday" int,"12-Wednesday" int,
"10-Saturday" int,"13-Tuesday" int,"16-Thursday" int,"10-Friday" int,
"20-Tuesday" int,"4-Thursday" int, "9-Tuesday" int, "10-Tuesday" int,
"4-Sunday" int, "4-Monday" int, "11-Saturday" int,"11-Monday" int,
"10-Monday" int,"6-Saturday" int, "5-Monday" int, "6-Wednesday" int, 
"6-Sunday" int, "6-Monday" int, "5-Friday" int, "9-Wednesday" int, 
"5-Saturday" int, "4-Saturday" int, "9-Saturday" int, "7-Wednesday" int, 
"7-Tuesday" int, "7-Monday" int, "3-Thursday" int, "3-Wednesday" int, 
"8-Friday" int, "8-Saturday" int, "10-Wednesday" int,"8-Tuesday" int, 
"8-Wednesday" int, "5-Thursday" int, "6-Tuesday" int, "8-Sunday" int, 
"19-Thursday" int,"13-Thursday" int,"20-Thursday" int,"13-Friday" int,
"15-Friday" int,"17-Sunday" int,"19-Friday" int,"15-Sunday" int,
"15-Wednesday" int,"1-Friday" int, "19-Sunday" int,"19-Monday" int,
"16-Friday" int,"12-Sunday" int,"4-Friday" int, "18-Friday" int,
"18-Saturday" int,"16-Saturday" int,"14-Tuesday" int,"13-Saturday" int,
"14-Friday" int,"14-Monday" int,"16-Sunday" int,"17-Monday" int,
"5-Wednesday" int,"20-Saturday" int,"11-Sunday" int,"15-Saturday" int,
"3-Tuesday" int, "19-Wednesday" int,"12-Saturday" int,"4-Tuesday" int, 
"7-Sunday" int, "14-Sunday" int,"6-Thursday" int, "16-Wednesday" int,
"22-Thursday" int,"22-Monday" int,"23-Friday" int,"0-Friday" int, 
"0-Saturday" int, "0-Monday" int, "11-Wednesday" int,"20-Friday" int,
"21-Friday" int,"21-Monday" int,"21-Tuesday" int,"21-Wednesday" int,
"22-Sunday" int,"18-Sunday" int,"14-Wednesday" int,"20-Monday" int,
"20-Wednesday" int,"23-Tuesday" int,"21-Saturday" int,"0-Thursday" int, 
"3-Friday" int, "20-Sunday" int,"22-Wednesday" int,"5-Sunday" int, 
"3-Monday" int, "3-Sunday" int, "5-Tuesday" int, "4-Wednesday" int,
 "22-Saturday" int,"3-Saturday" int, "2-Saturday" int, "22-Tuesday" int,"1-Sunday" int, "21-Sunday" int,"2-Wednesday" int, "1-Wednesday" int, "2-Sunday" int, "0-Tuesday" int, "23-Thursday" int,"23-Sunday" int,"2-Tuesday" int,"2-Thursday" int, "23-Monday" int,"2-Monday" int, "1-Saturday" int, "2-Friday" int, "23-Saturday" int,"0-Wednesday" int, "1-Tuesday" int, "1-Thursday" int, "23-Wednesday" int,"1-Monday" int, 
 "0-Sunday" int
);

truncate table brian.checkins;
copy brian.checkins from 's3://ncarb-dsteam/Brian/Yelp/checkins.tsv'
credentials 'aws_access_key_id=[access_key];aws_secret_access_key=[secret]'
delimiter '\t'
REMOVEQUOTES
IGNOREHEADER as 1
DATEFORMAT AS 'YYYY-MM-DD';


drop table brian.business;
create table brian.business (
business_id varchar(50),
name varchar(500),
open_sun varchar(50),
closed_sun varchar(50),
open_mon varchar(50),
closed_mon varchar(50),
open_tues varchar(50),
closed_tues varchar(50),
open_wed varchar(50),
closed_wed varchar(50),
open_thu varchar(50),
closed_thu varchar(50),
open_fri varchar(50),
closed_fri varchar(50),
open_sat varchar(50),
closed_sat varchar(50),
 full_address varchar(500),
city varchar(50),
state varchar(50),
review_count varchar(50),
is_open varchar(50),
stars varchar(50),
lat varchar(50),
lon varchar(50),
type varchar(50),
categories varchar(500),
by_appt varchar(50),
price_range varchar(50),
happy_hour varchar(50),
smoking varchar(50),
byob varchar(50),
corkage varchar(50),
byob_corkage varchar(50),
 alcohol varchar(50),
 waiter_service varchar(50),
 wifi varchar(20)
);

truncate table brian.business;
copy brian.business from 's3://ncarb-dsteam/Brian/Yelp/businesses.tsv'
credentials 'aws_access_key_id=[access_key];aws_secret_access_key=[secret]'
delimiter '\t'
REMOVEQUOTES
IGNOREHEADER as 1
DATEFORMAT AS 'YYYY-MM-DD';

drop table brian.user;
create table brian.user(
user_id varchar(50),
useful_votes int,
funny_votes int,
cool_votes int,
average_stars float,
fan_count int,
friend_count int,
hot_compliments int,
writer_compliments int,
photos_compliments int,
cool_compliments int,
funny_compliments int,
cute_compliments int,
plain_compliments int,
name varchar(200)
);

truncate table brian.user;
copy brian.user from 's3://ncarb-dsteam/Brian/Yelp/users.tsv'
credentials 'aws_access_key_id=[access_key];aws_secret_access_key=[secret]'
delimiter '\t'
REMOVEQUOTES
IGNOREHEADER as 1
DATEFORMAT AS 'YYYY-MM-DD';

