library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="miley.cda5nmppsk8w.us-east-1.redshift.amazonaws.com", 
                 port="5439", dbname="ncarbdw", user="admin")
miserables <- dbGetQuery(con,"with miserable as (select * from brian.user u where u.user_id in (
select distinct user_id from (
select b.categories, love.avg_stars, love.biz_count, love.review_count, r.stars, r.review, u.*
from brian.top_categories love 
join brian.business b on b.categories = love.categories 
join brian.reviews r on r.business_id = b.business_id
join brian.user u on u.user_id = r.user_id
where
r.stars - love.avg_stars <= -1.5
order by love.avg_stars desc))),
joyful as (
select * from brian.user u where u.user_id in (
select distinct user_id from (
select b.categories, misery.avg_stars, misery.biz_count, misery.review_count, r.stars, r.review, u.*
from brian.bottom_categories misery 
join brian.business b on b.categories = misery.categories 
join brian.reviews r on r.business_id = b.business_id
join brian.user u on u.user_id = r.user_id
where
r.stars - misery.avg_stars >= 1.5
order by misery.avg_stars desc)))
select * from (
select * from miserable
minus
select * from joyful)
")

joyous <- dbGetQuery(con,"with miserable as (select * from brian.user u where u.user_id in (
select distinct user_id from (
select b.categories, love.avg_stars, love.biz_count, love.review_count, r.stars, r.review, u.*
from brian.top_categories love 
join brian.business b on b.categories = love.categories 
join brian.reviews r on r.business_id = b.business_id
join brian.user u on u.user_id = r.user_id
where
r.stars - love.avg_stars <= -1.5
order by love.avg_stars desc))),
joyful as (
select * from brian.user u where u.user_id in (
select distinct user_id from (
select b.categories, misery.avg_stars, misery.biz_count, misery.review_count, r.stars, r.review, u.*
from brian.bottom_categories misery 
join brian.business b on b.categories = misery.categories 
join brian.reviews r on r.business_id = b.business_id
join brian.user u on u.user_id = r.user_id
where
r.stars - misery.avg_stars >= 1.5
order by misery.avg_stars desc)))
select * from (
select * from joyful
minus
select * from miserable)")

summary(miserables$average_stars)
hist(miserables$average_stars)
summary(joyous$average_stars)
hist(joyous$average_stars, breaks=100)
t.test(miserables$average_stars,joyous$average_stars)
t.test(miserables$fan_count,joyous$fan_count)
t.test(miserables$friend_count,joyous$friend_count)
t.test(miserables$hot_compliments,joyous$hot_compliments)

dat <- cbind('joy', joyous)
names(dat)[1] <- 'type'
dat2 <- cbind('misery', miserables)
names(dat2)[1] <- 'type'

dat <- rbind(dat,dat2)
ggplot(dat, aes(x=friend_count)) + 
  geom_histogram(data=subset(dat,type == 'joy'),aes(y=..density..),      # Histogram with density instead of count on y-axis
                 binwidth=.5,
                 colour="black", fill="red", alpha=.1) +
  geom_vline(data=subset(dat,type == 'joy'),aes(xintercept=mean(friend_count, na.rm=T)),   # Ignore NA values for mean
             color="red", linetype="dashed", size=1)+
  geom_density(data=subset(dat,type == 'joy'),alpha=.2, fill="red") +
  geom_histogram(data=subset(dat,type == 'misery'),aes(y=..density..),      # Histogram with density instead of count on y-axis
                 binwidth=.5,
                 colour="orange", fill="blue", alpha=.1) +
  geom_density(data=subset(dat,type == 'misery'),alpha=.2, fill="blue") +
  geom_vline(data=subset(dat,type == 'misery'),aes(xintercept=mean(friend_count, na.rm=T)),   # Ignore NA values for mean
             color="blue", linetype="dashed", size=1) + theme_bw() + xlim(0,50)
