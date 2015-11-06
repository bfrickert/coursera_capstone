select * from brian.joyful;

select avg(r.stars *1.0000) from brian.business b
join brian.reviews r on r.business_id = b.business_id
join brian.miserables m on m.user_id = r.user_id
where lower(categories) like '%nightlif%';

select avg(r.stars *1.0000) from brian.business b
join brian.reviews r on r.business_id = b.business_id
join brian.joyful m on m.user_id = r.user_id
where lower(categories) like '%nightlif%';

select * from brian.miserables;
