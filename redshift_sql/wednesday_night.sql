select b.name, "0-Wednesday", b.full_address, b.stars, r.*, b.city, b.state, r.avg_stars - b.stars relative_performance
from brian.checkins ch
join brian.business b on b.business_id = ch.business_id 
join (select b.business_id, avg(r.stars*1.00000) avg_stars, count(distinct u.user_id) user_count, avg(u.friend_count*1.00000) avg_friend_count, avg(u.hot_compliments*1.00000) hottie, 
        avg(u.funny_compliments*1.00000) funny, avg(u.fan_count*1.00000) avg_fan_count, avg(t.tip_count*1.0000000) avg_tip_count
        from brian.user u join brian.reviews r on r.user_id = u.user_id 
        join brian.business b on b.business_id = r.business_id 
        join (select count(8) tip_count, user_id from brian.tips t group by t.user_id) t on t.user_id = r.user_id
        group by b.business_id) r on r.business_id = b.business_id
where user_count > 100
order by relative_performance desc
limit 22200;

select * from brian.reviews r where r.business_id = 'GJp4zTQPPsCEkUitopGfAQ' order by r.stars;

select b.categories, r.* from brian.reviews r join brian.business b on b.business_id = r.business_id 
where (lower(r.review) like '%lobster%' and lower(b.categories) not like '%restaurant%') 
   --or b.categories like '%seafood%'
   ; 
