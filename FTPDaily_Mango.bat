@echo off

For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set curtime=%%a%%b)
set d=C:\ptlspg
set dir=C:/ptlspg
cd %d%
set db=ptls
set logfile=log.txt
set last_success=from_date.txt
set pfx=1881 Yonge
set feq=Daily
set fln=%pfx%_%feq%
rem set sdate=%date%
if exist %last_success% (
set /p sdate=<%last_success%
) else (
 echo %date% - from_date.txt file not found! Using today's date. > %logfile%
)
set stime="%sdate% 00:00:00"
set edate=%sdate%
set etime="%edate% 23:59:59"
set csvfile=%fln%_%date%.csv
set sqlfile=C:\ptlspg\%feq%.sql
set ofile=C:\ptlspg\csv\%csvfile%
set outfile="C:/ptlspg/csv/%csvfile%"

echo use %db% ;> %sqlfile%
echo select * from>>%sqlfile%
echo ((select 'Property', 'SN', 'Channel', 'Time', 'Utility', 'Description', 'Value', 'Unit')>> %sqlfile%
echo union>> %sqlfile%
echo (select "%pfx%" as `property`, p.name as `SN`, (select "0") as `Channel`, from_unixtime(v.ts div 1000) as `time`, (select "Electricity") as `utility`, >> %sqlfile%
echo concat(p.name,' - ' ,substring(p.deviceName,locate('iM45 ID1',p.deviceName))) as `description`, >> %sqlfile%
echo v.pointValue as value, (select "kWh") as unit >> %sqlfile%
echo from datapoints p, pointvalues v >> %sqlfile%
echo where p.id=v.dataPointId and p.deviceName like '%%iM45%%' and >> %sqlfile%
echo v.ts ^> unix_timestamp(%stime%)*1000 and v.ts ^< unix_timestamp(%etime%)*1000 >> %sqlfile%
rem echo and hour(from_unixtime (v.ts div 1000)) = 0 >> %sqlfile%
echo group by description, time)) A >> %sqlfile%
echo INTO OUTFILE ^"%outfile%^" FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '^"' LINES TERMINATED BY '\r\n' ;>> %sqlfile%

mysql.exe -uroot -pODYSSEY99GRANITE < %sqlfile%
echo %date%>%last_success%
echo %date% - from_date.txt updated.> %logfile%
FOR /F "tokens=* USEBACKQ" %%F IN (`cscript %d%\setup\countRows.vbs %ofile% //nologo`) DO (
SET var=%%F
)

rem ftp info ip/username/password/path (if not /)
echo %date% - Data taken from %csvfile% at %date%>> log.txt
echo open 52.228.42.17> temp.txt
echo DYNRYTRQFJH>> temp.txt
echo 6cfQ7vArOJ>> temp.txt
echo bin>> temp.txt
echo cd />> temp.txt
echo put %outfile%>> temp.txt
echo quit>> temp.txt

rem Start FTP command with script
ftp -s:temp.txt

rem Deletes the file
del temp.txt
echo %date% - %csvfile% sent to ftp://52.228.42.17/>> log.txt
:END