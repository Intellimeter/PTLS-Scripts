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
set db=ptls
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
echo ((select "Property", "SN", "Channel", "Time", "Utility", "Description", "Value", "Unit")>> %sqlfile%
echo union>> %sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch1 * i.mtpr, i.unit >> %sqlfile%
echo from accum a, info i where a.sn=i.sn and i.chan=1 and a.RealReadDate ^> "%stime%" and a.RealReadDate ^<= "%etime%" >> %sqlfile%
echo and hour(a.RealReadDate) = 0 >> %sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc )>> %sqlfile%
echo union >> %sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch2 * i.mtpr, i.unit >> %sqlfile%
echo from accum a, info i where a.sn=i.sn and i.chan=2 and a.RealReadDate ^> "%stime%" and a.RealReadDate ^<= "%etime%" >> %sqlfile%
echo and hour(a.RealReadDate) = 0 >> %sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc )>> %sqlfile%
echo union >> %sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch3 * i.mtpr, i.unit >> %sqlfile%
echo from accum a, info i where a.sn=i.sn and i.chan=3 and a.RealReadDate ^> "%stime%" and a.RealReadDate ^<= "%etime%" >> %sqlfile%
echo and hour(a.RealReadDate) = 0 >> %sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc )>> %sqlfile%
echo union >> %sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch4 * i.mtpr, i.unit >> %sqlfile%
echo from accum a, info i where a.sn=i.sn and i.chan=4 and a.RealReadDate ^> "%stime%" and a.RealReadDate ^<= "%etime%" >> %sqlfile%
echo and hour(a.RealReadDate) = 0 >> %sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc )>> %sqlfile%
echo union >> %sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch5 * i.mtpr, i.unit >> %sqlfile%
echo from accum a, info i where a.sn=i.sn and i.chan=5 and a.RealReadDate ^> "%stime%" and a.RealReadDate ^<= "%etime%" >> %sqlfile%
echo and hour(a.RealReadDate) = 0 >> %sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc )>> %sqlfile%
echo union >> %sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch6 * i.mtpr, i.unit >> %sqlfile%
echo from accum a, info i where a.sn=i.sn and i.chan=6 and a.RealReadDate ^> "%stime%" and a.RealReadDate ^<= "%etime%" >> %sqlfile%
echo and hour(a.RealReadDate) = 0 >> %sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc )>> %sqlfile%
echo union >> %sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch7 * i.mtpr, i.unit >> %sqlfile%
echo from accum a, info i where a.sn=i.sn and i.chan=7 and a.RealReadDate ^> "%stime%" and a.RealReadDate ^<= "%etime%" >> %sqlfile%
echo and hour(a.RealReadDate) = 0 >> %sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc )>> %sqlfile%
echo union >> %sqlfile%
echo (select "%pfx%", a.sn, i.chan, a.realreaddate, i.utility, i.descpt, a.tch8 * i.mtpr, i.unit >> %sqlfile%
echo from accum a, info i where a.sn=i.sn and i.chan=8 and a.RealReadDate ^> "%stime%" and a.RealReadDate ^<= "%etime%" >> %sqlfile%
echo and hour(a.RealReadDate) = 0 >> %sqlfile%
echo group by a.sn, a.readdate order by a.sn, a.readdate asc )) A>> %sqlfile%
echo INTO OUTFILE %outfile% FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '^"' LINES TERMINATED BY '\r\n' ;>> %sqlfile%

mysql.exe < %sqlfile%
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
