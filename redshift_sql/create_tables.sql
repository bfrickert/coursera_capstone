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
business_id varchar(50),  "9-Friday" varchar(8), "7-Friday" varchar(8), "13-Wednesday" varchar(8),
"17-Saturday" varchar(8),"13-Sunday" varchar(8),"17-Wednesday" varchar(8),"10-Sunday" varchar(8),
"18-Thursday" varchar(8),"14-Saturday" varchar(8),"22-Friday" varchar(8),"15-Monday" varchar(8),
"15-Thursday" varchar(8),"16-Tuesday" varchar(8),"21-Thursday" varchar(8),"13-Monday" varchar(8),
"14-Thursday" varchar(8),"12-Friday" varchar(8),"12-Monday" varchar(8),"9-Monday" varchar(8), 
"18-Wednesday" varchar(8),"15-Tuesday" varchar(8),"8-Thursday" varchar(8), "17-Friday" varchar(8),
"17-Thursday" varchar(8),"11-Tuesday" varchar(8),"12-Thursday" varchar(8),"10-Thursday" varchar(8),
"8-Monday" varchar(8), "9-Thursday" varchar(8), "9-Sunday" varchar(8), "18-Monday" varchar(8),
"19-Saturday" varchar(8),"7-Saturday" varchar(8), "11-Friday" varchar(8),"11-Thursday" varchar(8),
"17-Tuesday" varchar(8),"6-Friday" varchar(8), "12-Tuesday" varchar(8),"7-Thursday" varchar(8), 
"18-Tuesday" varchar(8),"16-Monday" varchar(8),"19-Tuesday" varchar(8),"12-Wednesday" varchar(8),
"10-Saturday" varchar(8),"13-Tuesday" varchar(8),"16-Thursday" varchar(8),"10-Friday" varchar(8),
"20-Tuesday" varchar(8),"4-Thursday" varchar(8), "9-Tuesday" varchar(8), "10-Tuesday" varchar(8),
"4-Sunday" varchar(8), "4-Monday" varchar(8), "11-Saturday" varchar(8),"11-Monday" varchar(8),
"10-Monday" varchar(8),"6-Saturday" varchar(8), "5-Monday" varchar(8), "6-Wednesday" varchar(8), 
"6-Sunday" varchar(8), "6-Monday" varchar(8), "5-Friday" varchar(8), "9-Wednesday" varchar(8), 
"5-Saturday" varchar(8), "4-Saturday" varchar(8), "9-Saturday" varchar(8), "7-Wednesday" varchar(8), 
"7-Tuesday" varchar(8), "7-Monday" varchar(8), "3-Thursday" varchar(8), "3-Wednesday" varchar(8), 
"8-Friday" varchar(8), "8-Saturday" varchar(8), "10-Wednesday" varchar(8),"8-Tuesday" varchar(8), 
"8-Wednesday" varchar(8), "5-Thursday" varchar(8), "6-Tuesday" varchar(8), "8-Sunday" varchar(8), 
"19-Thursday" varchar(8),"13-Thursday" varchar(8),"20-Thursday" varchar(8),"13-Friday" varchar(8),
"15-Friday" varchar(8),"17-Sunday" varchar(8),"19-Friday" varchar(8),"15-Sunday" varchar(8),
"15-Wednesday" varchar(8),"1-Friday" varchar(8), "19-Sunday" varchar(8),"19-Monday" varchar(8),
"16-Friday" varchar(8),"12-Sunday" varchar(8),"4-Friday" varchar(8), "18-Friday" varchar(8),
"18-Saturday" varchar(8),"16-Saturday" varchar(8),"14-Tuesday" varchar(8),"13-Saturday" varchar(8),
"14-Friday" varchar(8),"14-Monday" varchar(8),"16-Sunday" varchar(8),"17-Monday" varchar(8),
"5-Wednesday" varchar(8),"20-Saturday" varchar(8),"11-Sunday" varchar(8),"15-Saturday" varchar(8),
"3-Tuesday" varchar(8), "19-Wednesday" varchar(8),"12-Saturday" varchar(8),"4-Tuesday" varchar(8), 
"7-Sunday" varchar(8), "14-Sunday" varchar(8),"6-Thursday" varchar(8), "16-Wednesday" varchar(8),
"22-Thursday" varchar(8),"22-Monday" varchar(8),"23-Friday" varchar(8),"0-Friday" varchar(8), 
"0-Saturday" varchar(8), "0-Monday" varchar(8), "11-Wednesday" varchar(8),"20-Friday" varchar(8),
"21-Friday" varchar(8),"21-Monday" varchar(8),"21-Tuesday" varchar(8),"21-Wednesday" varchar(8),
"22-Sunday" varchar(8),"18-Sunday" varchar(8),"14-Wednesday" varchar(8),"20-Monday" varchar(8),
"20-Wednesday" varchar(8),"23-Tuesday" varchar(8),"21-Saturday" varchar(8),"0-Thursday" varchar(8), 
"3-Friday" varchar(8), "20-Sunday" varchar(8),"22-Wednesday" varchar(8),"5-Sunday" varchar(8), 
"3-Monday" varchar(8), "3-Sunday" varchar(8), "5-Tuesday" varchar(8), "4-Wednesday" varchar(8),
 "22-Saturday" varchar(8),"3-Saturday" varchar(8), "2-Saturday" varchar(8), "22-Tuesday" varchar(8),"1-Sunday" varchar(8), "21-Sunday" varchar(8),"2-Wednesday" varchar(8), "1-Wednesday" varchar(8), "2-Sunday" varchar(8), "0-Tuesday" varchar(8), "23-Thursday" varchar(8),"23-Sunday" varchar(8),"2-Tuesday" varchar(8),"2-Thursday" varchar(8), "23-Monday" varchar(8),"2-Monday" varchar(8), "1-Saturday" varchar(8), "2-Friday" varchar(8), "23-Saturday" varchar(8),"0-Wednesday" varchar(8), "1-Tuesday" varchar(8), "1-Thursday" varchar(8), "23-Wednesday" varchar(8),"1-Monday" varchar(8), 
 "0-Sunday" varchar(8)
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

