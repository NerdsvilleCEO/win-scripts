@echo off
:START
set continue=""
rem: Begin Port Forward script 

rem 1. We need  to know the host we will be accepting connections on
set /p inbound="Enter host:port for connection to listen on: "

rem 2. We need to know the host the connections will be forwarded to
set /p connection="Enter host:port for connection to be forwarded to: "

rem 3. We must split the input by the given colon and store in a variable
rem Adapted from: https://superuser.com/questions/228794/how-to-extract-part-of-a-string-in-windows-batch-file
rem Date: 12/23/2019
for /f "tokens=1,2 delims=:" %%a in ("%inbound%") do (
    set inbound_ip=%%a
    set inbound_port=%%b
)

for /f "tokens=1,2 delims=:" %%a in ("%connection%") do (
    set connection_ip=%%a
    set connection_port=%%b
)

echo Received Inbound IP: %inbound_ip%
echo Received Inbound Port: %inbound_port%
echo Received Forward IP: %connection_ip%
echo Received Forward Port: %connection_port%

rem 4. Ask for confirmation that the settings are valid
set /p continue="Are these settings valid? (Y/n)"

rem Figure out a better way to do this, this is to get around the lack of the OR construct
if %continue% == "" (
    set continue="Y"
)

if %continue% == "Y" (
    rem Setting rules
    echo Setting rules...
    netsh interface portproxy add v4tov4 listenaddress=%inbound_ip% listenport=%inbound_port% connectaddress=%connection_ip% connectport=%connection_port%
    echo Done, enjoy
) else (
    rem Skipping rules setting
    goto :START 
)