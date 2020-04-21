use ptls ;
select * from
((select "Property", "SN", "Channel", "Time", "Utility", "Description", "Value", "Unit") 
union 
(select "Your_Site_Name", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch1 * i.mtpr, i.unit 
from accum a, info i where a.sn = i.sn and i.chan = 1 and a.RealReadDate >="2020-01-08 00:00:00"and a.RealReadDate <="2020-01-08 23:59:59" 
group by a.sn, a.readdate order by a.sn, a.readdate asc) 
union 
(select "Your_Site_Name", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch2 * i.mtpr, i.unit 
from accum a, info i where a.sn = i.sn and i.chan = 2 and a.RealReadDate >="2020-01-08 00:00:00"and a.RealReadDate <="2020-01-08 23:59:59" 
group by a.sn, a.readdate order by a.sn, a.readdate asc) 
union 
(select "Your_Site_Name", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch3 * i.mtpr, i.unit 
from accum a, info i where a.sn = i.sn and i.chan = 3 and a.RealReadDate >="2020-01-08 00:00:00"and a.RealReadDate <="2020-01-08 23:59:59" 
group by a.sn, a.readdate order by a.sn, a.readdate asc) 
union 
(select "Your_Site_Name", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch4 * i.mtpr, i.unit 
from accum a, info i where a.sn = i.sn and i.chan = 4 and a.RealReadDate >="2020-01-08 00:00:00"and a.RealReadDate <="2020-01-08 23:59:59" 
group by a.sn, a.readdate order by a.sn, a.readdate asc) 
union 
(select "Your_Site_Name", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch5 * i.mtpr, i.unit 
from accum a, info i where a.sn = i.sn and i.chan = 5 and a.RealReadDate >="2020-01-08 00:00:00"and a.RealReadDate <="2020-01-08 23:59:59" 
group by a.sn, a.readdate order by a.sn, a.readdate asc) 
union 
(select "Your_Site_Name", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch6 * i.mtpr, i.unit 
from accum a, info i where a.sn = i.sn and i.chan = 6 and a.RealReadDate >="2020-01-08 00:00:00"and a.RealReadDate <="2020-01-08 23:59:59" 
group by a.sn, a.readdate order by a.sn, a.readdate asc) 
union 
(select "Your_Site_Name", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch7 * i.mtpr, i.unit 
from accum a, info i where a.sn = i.sn and i.chan = 7 and a.RealReadDate >="2020-01-08 00:00:00"and a.RealReadDate <="2020-01-08 23:59:59" 
group by a.sn, a.readdate order by a.sn, a.readdate asc) 
union 
(select "Your_Site_Name", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch8 * i.mtpr, i.unit 
from accum a, info i where a.sn = i.sn and i.chan = 8 and a.RealReadDate >="2020-01-08 00:00:00"and a.RealReadDate <="2020-01-08 23:59:59" 
group by a.sn, a.readdate order by a.sn, a.readdate asc)) A 
INTO OUTFILE "C:/ptlspg/csv/2425_Your_Site_Name_2020-01-09.csv" FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n';
