select avg(r.stars* 1.00000), count(distinct(r.user_id)) from brian.user u
join brian.reviews r on r.user_id = u.user_id 
where friend_count > 20;

select count(9) from brian.reviews;

select * from brian.user order by hot_compliments desc;


select * from alpine.exam_deltas order by exam_date_time desc limit 4;

select b.name, "0-Wednesday", b.full_address, b.stars, r.*, b.city, b.state, r.avg_stars - b.stars relative_performance
from brian.checkins ch
join brian.business b on b.business_id = ch.business_id 
join (select b.business_id, avg(r.stars*1.00000) avg_stars, count(u.user_id) user_count, avg(u.hot_compliments*1.00000) hottie, sum(hot_compliments) sum_hottie, avg(u.funny_compliments*1.00000) funny, sum(funny_compliments) sum_funny, avg(u.fan_count*1.00000) fans, sum(fan_count) sum_fans from brian.user u join brian.reviews r on r.user_id = u.user_id join brian.business b on b.business_id = r.business_id group by b.business_id) r on r.business_id = b.business_id
where user_count > 100
order by relative_performance desc
limit 222;

select * from brian.reviews r 
where r.business_id = 'yrhBaepgKHWCZ1W5CHT-og'
limit 2000;

select * from brian.user where user_id = '4a2SjXc0U4k4MRN2EdcNwg';
