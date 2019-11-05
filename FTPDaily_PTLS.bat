@echo off

For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set curtime=%%a%%b)
set d=C:\ptlspg
set dir=C:/ptlspg
cd %d%
set db=ptls
set logfile=C:\ptlspg\logs\log.txt
set last_success=C:\ptlspg\setup\from_date.txt
set pfx=[project name]
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
set sqlfile=C:\ptlspg\setup\%feq%.sql
set ofile=C:\ptlspg\csv\%csvfile%
set outfile="C:/ptlspg/csv/%csvfile%"
echo use %db% ;> %sqlfile%
echo select * from>>%sqlfile%
echo ((select "Property", "SN", "Channel", "Time", "Utility", "Description", "Value", "Unit") >>%sqlfile%
echo union >>%sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch1 * i.mtpr, i.unit >>%sqlfile%
echo from accum a, info i where a.sn = i.sn and i.chan = 1 and a.RealReadDate ^>=%stime%and a.RealReadDate ^<=%etime% >>%sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc) >>%sqlfile%
echo union >>%sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch2 * i.mtpr, i.unit >>%sqlfile%
echo from accum a, info i where a.sn = i.sn and i.chan = 2 and a.RealReadDate ^>=%stime%and a.RealReadDate ^<=%etime% >>%sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc) >>%sqlfile%
echo union >>%sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch3 * i.mtpr, i.unit >>%sqlfile%
echo from accum a, info i where a.sn = i.sn and i.chan = 3 and a.RealReadDate ^>=%stime%and a.RealReadDate ^<=%etime% >>%sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc) >>%sqlfile%
echo union >>%sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch4 * i.mtpr, i.unit >>%sqlfile%
echo from accum a, info i where a.sn = i.sn and i.chan = 4 and a.RealReadDate ^>=%stime%and a.RealReadDate ^<=%etime% >>%sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc) >>%sqlfile%
echo union >>%sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch5 * i.mtpr, i.unit >>%sqlfile%
echo from accum a, info i where a.sn = i.sn and i.chan = 5 and a.RealReadDate ^>=%stime%and a.RealReadDate ^<=%etime% >>%sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc) >>%sqlfile%
echo union >>%sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch6 * i.mtpr, i.unit >>%sqlfile%
echo from accum a, info i where a.sn = i.sn and i.chan = 6 and a.RealReadDate ^>=%stime%and a.RealReadDate ^<=%etime% >>%sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc) >>%sqlfile%
echo union >>%sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch7 * i.mtpr, i.unit >>%sqlfile%
echo from accum a, info i where a.sn = i.sn and i.chan = 7 and a.RealReadDate ^>=%stime%and a.RealReadDate ^<=%etime% >>%sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc) >>%sqlfile%
echo union >>%sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch8 * i.mtpr, i.unit >>%sqlfile%
echo from accum a, info i where a.sn = i.sn and i.chan = 8 and a.RealReadDate ^>=%stime%and a.RealReadDate ^<=%etime% >>%sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc)) A >>%sqlfile%
echo INTO OUTFILE %outfile% FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '^"' LINES TERMINATED BY '\r\n';>>%sqlfile%
mysql.exe < %sqlfile%
echo %date%>%last_success%
echo %date% - from_date.txt updated.> %logfile%
FOR /F "tokens=* USEBACKQ" %%F IN (`cscript %d%\setup\countRows.vbs %ofile% //nologo`) DO (
SET var=%%F
)


echo %date% - Data taken from %csvfile% at %date%>> "C:\ptlspg\logs\Log.txt"
echo open 52.228.42.17> temp.txt
echo [username]>> temp.txt
echo [password]>> temp.txt
echo bin>> temp.txt
echo cd /[directory path if not root directory]>> temp.txt
echo put %outfile%>> temp.txt
echo quit>> temp.txt
rem Start FTP command with script
ftp -s:temp.txt
rem Deletes the file
del temp.txt
echo %date% - %csvfile% sent to ftp://52.228.42.17/>> "C:\ptlspg\logs\Log.txt"
:END
