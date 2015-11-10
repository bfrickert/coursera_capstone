select * from brian.joyful;

select * from (
select count(distinct b.business_id) biz_count, count(8) cnt, avg(r.stars *1.0000) av,b.categories from brian.business b
join brian.reviews r on r.business_id = b.business_id
join brian.miserables m on m.user_id = r.user_id
--where lower(categories) like '%americ%'
group by b.categories) mis 
join (

select count(distinct b.business_id) biz_count, count(8) cnt, avg(r.stars *1.0000) av,b.categories from brian.business b
join brian.reviews r on r.business_id = b.business_id
join brian.joyful m on m.user_id = r.user_id
--where lower(categories) like '%americ%'
group by b.categories) joy on mis.categories=joy.categories and mis.av > joy.av
where joy.biz_count > 6 and mis.cnt > 29;

select * from brian.miserables;


select b.categories, avg(r.stars*1.00000000000) avg_stars, u.feedback_quadrant
from  brian.business b
join  brian.reviews r on r.business_id = b.business_id
join  (select user_id, case when feedback between 0 and 2 then 1
                     when feedback between 2 and  10 then 2 
                     when feedback between 10 and 42 then 3
                     else 4 end feedback_quadrant from (
select user_id, useful_votes	+ funny_votes	+ cool_votes + fan_count	+ 
        friend_count	+ hot_compliments	+ writer_compliments	+ photos_compliments	+ 
        cool_compliments	+ funny_compliments	+ cute_compliments	+ plain_compliments feedback
from brian.user)) u on u.user_id = r.user_id
join (select user_id, 'miserables' tipe from brian.miserables
union
select user_id, 'joyful' tipe from brian.joyful) t on t.user_id = r.user_id
where b.categories != ''
group by b.categories, u.feedback_quadrant;

