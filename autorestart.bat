:loop
@echo Hit Enter In This Window To Restart Server Immediately, Keep This Window Open For Automatic 6 Hour Server Restarts.
start "Server" D:\SKOGENACADEMY\FXServer\run.cmd +exec server.cfg
timeout /t 21600
taskkill /f /im FXServer.exe
@echo Server Shutdown Successfully.
taskkill /F /FI "WindowTitle eq Server"
@echo Server Is Restarting Now.
goto loop