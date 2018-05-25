@echo off

if [%1]==[] goto :error
if [%2]==[] goto :error
if [%3]==[] goto :error

SET DATASET=V130.SRC

echo open %1 > ftpupload.in
echo %2 >> ftpupload.in
echo %3 >> ftpupload.in
echo quote site RECFM=FB LRECL=80 BLKSIZE=27920 PDSTYPE=PDS TRK PRI=1 SEC=1 DIRECTORY=4 >> ftpupload.in
echo del %DATASET% >> ftpupload.in
echo mkdir %DATASET% >> ftpupload.in
echo cd %DATASET% >> ftpupload.in
echo ascii >> ftpupload.in
echo prompt >> ftpupload.in
echo quote site SBDATACONN=(IBM-037,ISO8859-1) >> ftpupload.in
echo lcd source >> ftpupload.in
echo mput * >> ftpupload.in
echo quit >> ftpupload.in

ftp -s:ftpupload.in
goto :eof

:error
echo Parameter missing - specify host, username and password

