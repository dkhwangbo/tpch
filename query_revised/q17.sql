DROP TABLE q17_small_quantity_order_revenue;
DROP TABLE lineitem_tmp;

create table q17_small_quantity_order_revenue (avg_yearly double);
create table lineitem_tmp (t_partkey int8, t_avg_quantity double);

insert overwrite into lineitem_tmp
select 
  l_partkey as t_partkey, 0.2 * avg(l_quantity) as t_avg_quantity
from 
  lineitem
group by l_partkey;

select
  sum(l_extendedprice) / 7.0 as avg_yearly
from
  (select l_quantity, l_extendedprice, t_avg_quantity from
   lineitem_tmp t join
     (select
        l_quantity, l_partkey, l_extendedprice
      from
        part p join lineitem l
        on
          p.p_partkey = l.l_partkey
          and p.p_brand = 'Brand#23'
          and p.p_container = 'MED BOX'
      ) l1 on l1.l_partkey = t.t_partkey
   ) a
where l_quantity < t_avg_quantity;

--AVG_YEARLY
--348406.05

