DROP TABLE q4_order_priority_tmp;

CREATE TABLE q4_order_priority_tmp (O_ORDERKEY INT8);

INSERT OVERWRITE INTO q4_order_priority_tmp 
select 
	DISTINCT l_orderkey 
from 
	lineitem
where 
	l_commitdate < l_receiptdate;


select
	o_orderpriority,
	count(*) as order_count 
from 
	orders o 
	join
		q4_order_priority_tmp t 
	on
		o.o_orderkey = t.o_orderkey
		and o.o_orderdate >= '1993-07-01'::date
		and o.o_orderdate < '1993-10-01'::date
group by
	o_orderpriority 
order by
	o_orderpriority;

