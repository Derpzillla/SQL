-- SQL Challange 
select count(*)
from customer
where c_custkey=60008;

select count(*) 
from customer
where c_mktsegment = 'AUTOMOBILE';

select count(*)
from orders 
where o_orderdate > '1998-08-01';   -- year month day

select count(*)
from orders 
where o_orderdate between '1998-07-01' and '1998-08-01';

select *
from orders sample(20 rows);


describe table part;

-- Activity part 1
select *
from customer c
inner join orders o on c.c_custkey = o.o_custkey
where c.c_custkey in (1,2,3)
order by c.c_custkey;


select *
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c.c_custkey in (1,2,3)
order by c.c_custkey;


-- Activity part 2
select c.c_custkey,
count(o.o_custkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
--where c.c_custkey in (1,2,3)
group by c.c_custkey
order by c.c_custkey
limit 10;

-- Activity park 3a

select c.c_custkey,
count(o.o_custkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c.c_custkey in (1,2,3)
group by c.c_custkey
order by orders_count desc;


-- Activity park 3b

select c.c_custkey,
count(o.o_custkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
--where c.c_custkey in (1,2,3)
group by c.c_custkey
having orders_count > 35
order by orders_count asc;

-- Activity part 4

SELECT L_ORDERKEY, COUNT(*) AS line_item_count
FROM LINEITEM
GROUP BY L_ORDERKEY
HAVING COUNT(*) > 5
ORDER BY line_item_count DESC;

SELECT line_item_count, COUNT(*) AS order_count
FROM (
    SELECT L_ORDERKEY, COUNT(*) AS line_item_count
    FROM LINEITEM
    GROUP BY L_ORDERKEY
)
GROUP BY line_item_count
ORDER BY line_item_count;



