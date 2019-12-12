@echo off

set email_recp="[To: Email]"
set email_support="[CC: Email use ; for multiple emails]"
set email_subject="[Site Name] - Email CSV Error"

rem working directory
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set curtime=%%a:%%b)

set d="C:\ptlspg"
set dir=C:/ptlspg
cd %d%

set errfile=error.txt
set err="Error"

rem job information
set db=icidb
set logfile=log.txt
set emaillog=sendemail.log
set last_success=from_date.txt
rem --change --
set pfx=[Site Name]
set feq=[Frequency: Daily, Monthly, Custom]
set fln=%pfx%_%feq%

rem read last success date into a variable
if exist %d%/%last_success% (
set /p sdate=<%last_success%
) else (
set email_content="%last_success% file does not exist!"
cscript %d%\sendemail.vbs %email_support% %email_subject% %email_content%
exit /b %errorlevel%
)
set stime=%sdate%
set edate=%date%
set etime=%edate% 23:59:59
set csvfile=%fln%_%date%.csv

rem sql paramaters
set sqlfile=%feq%.sql
set outfile=%dir%/csv/%csvfile%
set ofile=%d%\csv\%csvfile%

rem purge csv output file if exist (Rerun sql script) and csv files older than 60 days
del %ofile%
cscript %d%\purgeFiles.vbs

echo use %db% ;> %sqlfile%
echo select * from>> %sqlfile%
echo ((select 'Property', 'Device', 'Utility', 'Suite', 'Time', 'Value', 'Unit')>> %sqlfile%
echo union>> %sqlfile%
echo (select (select "%pfx%") as property, p.deviceName as `device`, (select "Electric") as `utility`, substring(p.deviceName, 1, locate('ID', p.devicename)-2) as `suite`, >> %sqlfile%
echo from_unixtime(v.ts div 1000) as `time`, >> %sqlfile%
echo round(v.pointValue,2) as value, (select "kWh") as unit >> %sqlfile%
echo from datapoints p, pointvalues v >> %sqlfile%
echo where p.name = 'kWh' and p.id=v.dataPointId and >> %sqlfile%
echo v.ts ^> (unix_timestamp('%stime%') * 1000) and v.ts ^< (unix_timestamp('%etime%') * 1000) >> %sqlfile%
echo and hour(from_unixtime (v.ts div 1000)) = 0 >> %sqlfile%
echo group by property, suite, time order by suite)) A >> %sqlfile%
echo INTO OUTFILE ^"%outfile%^" FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '^"' LINES TERMINATED BY '\r\n' ;>> %sqlfile%

mysql.exe -u m2m2user -pm2m2pass < %sqlfile%

FOR /F "tokens=* USEBACKQ" %%F IN (`cscript %d%\countrows.vbs %ofile% //nologo`) DO (
SET var=%%F
)

IF %var% LEQ 2 (
REM Send error message to admin
set email_content="No row was extracted from the database for the csv file."
cscript %d%\sendemail.vbs %email_support% %email_subject% %email_content%
echo Error: No row is extracted from database for %csvfile% on %edate% %curtime%. >> %logfile%
GOTO END
)ELSE (
del %emaillog%
cscript %d%\sendemail.vbs %email_recp% "[Project Name] Report" "Please find the data in the attachment." "%ofile%"
)

rem check email log file if there is any error
type %emaillog% |findstr /r /c:%err% > %errfile%

for /f %%i in ("%errfile%") do set size=%%~zi
if %size% gtr 0 (
rem error in sending email
echo Error: %csvfile% cannot send email out on %edate% %curtime%. >> %logfile%
) else (
rem error not found and proceed
echo %etime%> %last_success%
echo Success: %csvfile% send out email successfully on %edate% %curtime%. >> %logfile%
)

:END
