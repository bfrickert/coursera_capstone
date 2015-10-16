--################################################
--If'n I ever need to know how to get checkin info again
--################################################
select ch.business_id from brian.checkins ch
where "0-friday" + "1-friday" + "2-friday" + "3-friday" + "4-friday" + "5-friday" + "0-monday" + "1-monday" + "2-monday" + "3-monday" + "4-monday" + "5-monday" + "0-saturday" + "1-saturday" + "2-saturday" + "3-saturday" + "4-saturday" + "5-saturday" + "0-sunday" + "1-sunday" + "2-sunday" + "3-sunday" + "4-sunday" + "5-sunday" + "0-thursday" + "1-thursday" + "2-thursday" + "3-thursday" + "4-thursday" + "5-thursday" + "0-tuesday" + "1-tuesday" + "2-tuesday" + "3-tuesday" + "4-tuesday" + "5-tuesday" + "0-wednesday" + "1-wednesday" + "2-wednesday" + "3-wednesday" + "4-wednesday" + "5-wednesday" > 99 limit 443;

select column_name
from information_schema.columns where table_schema = 'brian' and 
table_name like '%checkins%' and substring(column_name, 1, 2) in ('0-','1-', '2-', '3-', '4-','5-') order by substring(column_name, 3,4), substring(column_name, 1, 2);
--################################################
--################################################


--These are people have patronized business in the highest ranking categories
--Categories so great that they transcend the quality of the businesses. People just enjoy these categories
--Yet these are people who have patronized businesses in these pleasure categories and issued reviews that are at least two full stars less than the avg_stars for this category.
with miserable as (select * from brian.user u where u.user_id in (
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
select average_stars from (
select * from miserable
minus
select * from joyful);

