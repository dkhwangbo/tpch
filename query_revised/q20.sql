DROP TABLE IF EXISTS q20_tmp1 ;
DROP TABLE IF EXISTS q20_tmp2 ;
DROP TABLE IF EXISTS q20_tmp3 ;
DROP TABLE IF EXISTS q20_tmp4 ;

create table q20_tmp1(p_partkey int8);
create table q20_tmp2(l_partkey int8, l_suppkey int8, sum_quantity double);
create table q20_tmp3(ps_suppkey int8, ps_availqty int8, sum_quantity double);
create table q20_tmp4(ps_suppkey int8);

insert overwrite into q20_tmp1
select distinct p_partkey
from
  part 
where 
  p_name like 'forest%';

insert overwrite into q20_tmp2
select 
  l_partkey, l_suppkey, 0.5 * sum(l_quantity)
from
  lineitem
where
  l_shipdate >= date '1994-01-01'
  and l_shipdate < date '1995-01-01'
group by l_partkey, l_suppkey;

insert overwrite into q20_tmp3
select 
  ps_suppkey, ps_availqty, sum_quantity
from  
  partsupp ps join q20_tmp1 t1 
  on 
    ps.ps_partkey = t1.p_partkey
  join q20_tmp2 t2 
  on 
    ps.ps_partkey = t2.l_partkey and ps.ps_suppkey = t2.l_suppkey;

insert overwrite into q20_tmp4
select 
  ps_suppkey
from 
  q20_tmp3
where 
  ps_availqty > sum_quantity
group by ps_suppkey;

select 
  s_name, s_address
from 
  supplier s join nation n
  on
    s.s_nationkey = n.n_nationkey
    and n.n_name = 'CANADA'
  join q20_tmp4 t4
  on 
    s.s_suppkey = t4.ps_suppkey
order by s_name;



--S_NAME              S_ADDRESS
--Supplier#000000020  iybAE,RmTymrZVYaFZva2SH,j

