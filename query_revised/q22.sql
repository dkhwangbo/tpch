select
cntrycode, count(*) as numcust, sum(c_acctbal) as totacctbal
from (
	select substr(c_phone,1,2) as cntrycode, c_acctbal, c_custkey
	from customer
	where
	substr(c_phone,1,2) in ('13','31','23','29','30','18','17')
	and c_acctbal > 5003.6857652151575

) as custsale
left join orders
on o_custkey = c_custkey
where o_custkey is null

group by cntrycode
order by cntrycode;
