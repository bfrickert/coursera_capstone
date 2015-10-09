select b.name, "0-Wednesday", b.full_address, b.stars, r.*, b.city, b.state, r.avg_stars - b.stars relative_performance, b.categories
from brian.checkins ch
join brian.business b on b.business_id = ch.business_id 
join (select b.business_id, avg(r.stars*1.00000) avg_stars, count(distinct u.user_id) user_count, avg(u.friend_count*1.00000) avg_friend_count, avg(u.hot_compliments*1.00000) hottie, 
        avg(u.funny_compliments*1.00000) funny, avg(u.fan_count*1.00000) avg_fan_count, avg(t.tip_count*1.0000000) avg_tip_count
        from brian.user u join brian.reviews r on r.user_id = u.user_id 
        join brian.business b on b.business_id = r.business_id 
        join (select count(8) tip_count, user_id from brian.tips t group by t.user_id) t on t.user_id = r.user_id
        group by b.business_id) r on r.business_id = b.business_id
where --user_count > 100 and 
      "0-friday" + "1-friday" + "2-friday" + "3-friday" + "4-friday" + "5-friday" + "0-monday" + "1-monday" + "2-monday" + "3-monday" + "4-monday" + "5-monday" + "0-saturday" + "1-saturday" + "2-saturday" + "3-saturday" + "4-saturday" + "5-saturday" + "0-sunday" + "1-sunday" + "2-sunday" + "3-sunday" + "4-sunday" + "5-sunday" + "0-thursday" + "1-thursday" + "2-thursday" + "3-thursday" + "4-thursday" + "5-thursday" + "0-tuesday" + "1-tuesday" + "2-tuesday" + "3-tuesday" + "4-tuesday" + "5-tuesday" + "0-wednesday" + "1-wednesday" + "2-wednesday" + "3-wednesday" + "4-wednesday" + "5-wednesday" > 99
order by relative_performance desc
limit 22200;

select * from brian.reviews r where r.business_id = 'GJp4zTQPPsCEkUitopGfAQ' order by r.stars;

select b.categories, r.* from brian.reviews r join brian.business b on b.business_id = r.business_id 
where (lower(r.review) like '%lobster%' and lower(b.categories) not like '%restaurant%') 
   --or b.categories like '%seafood%'
   ; 


select ch.business_id from brian.checkins ch
where "0-friday" + "1-friday" + "2-friday" + "3-friday" + "4-friday" + "5-friday" + "0-monday" + "1-monday" + "2-monday" + "3-monday" + "4-monday" + "5-monday" + "0-saturday" + "1-saturday" + "2-saturday" + "3-saturday" + "4-saturday" + "5-saturday" + "0-sunday" + "1-sunday" + "2-sunday" + "3-sunday" + "4-sunday" + "5-sunday" + "0-thursday" + "1-thursday" + "2-thursday" + "3-thursday" + "4-thursday" + "5-thursday" + "0-tuesday" + "1-tuesday" + "2-tuesday" + "3-tuesday" + "4-tuesday" + "5-tuesday" + "0-wednesday" + "1-wednesday" + "2-wednesday" + "3-wednesday" + "4-wednesday" + "5-wednesday" > 99 limit 443;

select column_name
from information_schema.columns where table_schema = 'brian' and 
table_name like '%checkins%' and substring(column_name, 1, 2) in ('0-','1-', '2-', '3-', '4-','5-') order by substring(column_name, 3,4), substring(column_name, 1, 2);

