DROP TABLE revenue;
DROP TABLE max_revenue;

create table revenue(supplier_no int8, total_revenue double); 
create table max_revenue(max_revenue double);

insert overwrite into revenue
select 
	l_suppkey as supplier_no,
	sum(l_extendedprice * (1 - l_discount)) as total_revenue
from 
	lineitem
where 
	l_shipdate >= '1996-01-01'::date
	and l_shipdate < '1996-04-01'::date
group by
	l_suppkey;

insert overwrite into max_revenue
select 
	max(total_revenue)
from 
	revenue;


select 
	s_suppkey,
	s_name,
	s_address,
	s_phone,
	total_revenue
from
	supplier s join revenue r 
	on 
	s.s_suppkey = r.supplier_no
	join max_revenue m 
	on 
	r.total_revenue = m.max_revenue
order
	by s_suppkey;


--S_SUPPKEY S_NAME             S_ADDRESS         S_PHONE         TOTAL_REVENUE
--8449      Supplier#000008449 Wp34zim9qYFbVctdW 20-469-856-8873 1772627.21

