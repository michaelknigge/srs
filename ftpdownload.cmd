@echo off

if [%1]==[] goto :error
if [%2]==[] goto :error
if [%3]==[] goto :error

SET DATASET=V130.SRC

echo open %1 > ftpdownload.in
echo %2 >> ftpdownload.in
echo %3 >> ftpdownload.in
echo cd %DATASET% >> ftpdownload.in
echo ascii >> ftpdownload.in
echo prompt >> ftpdownload.in
echo quote site SBDATACONN=(IBM-037,ISO8859-1) >> ftpdownload.in
echo lcd source >> ftpdownload.in
echo mget * >> ftpdownload.in
echo quit >> ftpdownload.in

ftp -s:ftpdownload.in
goto :eof

:error
echo Parameter missing - specify host, username and password

