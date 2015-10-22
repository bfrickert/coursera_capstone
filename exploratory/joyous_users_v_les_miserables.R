library(RPostgreSQL)
library(dplyr)
library(RColorBrewer)
library(ggplot2)

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

avgs <- dbGetQuery(con,"select * from brian.user")

rm(con);rm(drv)
summary(miserables$average_stars)
hist(miserables$average_stars)
summary(joyous$average_stars)
hist(joyous$average_stars, breaks=100)
t.test(miserables$average_stars,joyous$average_stars)
t.test(miserables$fan_count,joyous$fan_count)
t.test(miserables$friend_count,joyous$friend_count)
t.test(miserables$hot_compliments,joyous$hot_compliments)
t.test(miserables$writer_compliments, joyous$writer_compliments)
t.test(miserables$funny_compliments, joyous$funny_compliments)

set.seed(6)
joyous.out <- replicate( 100000, mean( sample(joyous$hot_compliments, 2000) ) )
miserables.out <- replicate( 100000, mean( sample(miserables$hot_compliments, 2000) ) )
avgs.out <- replicate( 100000, mean( sample(avgs$hot_compliments, 2000) ) )
summary(joyous.out)
summary(miserables.out)
dat <- NA
dat <- cbind('joy', joyous.out)
names(dat) <- c('type','hot_compliments')
dat2 <- NA
dat2 <- cbind('misery', miserables.out)
names(dat2) <- c('type', 'hot_compliments')
dat <- data.frame(rbind(dat,dat2), stringsAsFactors = F)
names(dat) <- c('type','hot_compliments')
df.avgs <- data.frame(as.numeric(avgs.out), stringsAsFactors = F)
names(df.avgs) <- 'hot_compliments'

t.test(miserables.out, avgs.out)

ggplot(dat, aes(x=as.numeric(hot_compliments))) + 
  geom_histogram(data=filter(dat,type == 'joy'),aes(y=..density..),      # Histogram with density instead of count on y-axis
                 binwidth=.5,
                 colour="black", fill="red", alpha=.1) +
  geom_vline(data=filter(dat,type == 'joy'),aes(xintercept=mean(as.numeric(hot_compliments))),   # Ignore NA values for mean
             color=brewer.pal(8,"Set3")[4], linetype="dashed", size=2)+
  geom_density(data=filter(dat,type == 'joy'),alpha=.4, fill=brewer.pal(11,"Spectral")[1]) +
  geom_histogram(data=df.avgs,aes(y=..density..),      # Histogram with density instead of count on y-axis
                 binwidth=.5,
                 colour="pink", fill="orange", alpha=.1) +
  geom_vline(data=df.avgs,aes(xintercept=mean(as.numeric(hot_compliments))),   # Ignore NA values for mean
             color=brewer.pal(8,"Set3")[7], linetype="dashed", size=2)+
  geom_density(data=df.avgs,alpha=.4, fill=brewer.pal(11,"Spectral")[6]) +
  geom_histogram(data=filter(dat,type == 'misery'),aes(y=..density..),      # Histogram with density instead of count on y-axis
                  binwidth=.5,
                  colour="orange", fill="blue", alpha=.1) +
  geom_density(data=filter(dat,type == 'misery'),alpha=.4, fill=brewer.pal(12,"Paired")[2]) +
  geom_vline(data=filter(dat,type == 'misery'),aes(xintercept=mean(as.numeric(hot_compliments))),   # Ignore NA values for mean
             color=brewer.pal(8,"Set3")[3], linetype="dashed", size=2) + theme_bw() + xlim(0,50)
t.test(as.numeric(filter(dat, type=='misery')$hot_compliments), as.numeric(df.avgs$hot_compliments))
