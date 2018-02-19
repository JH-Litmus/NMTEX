
RunWait, c:\platinum\ocsweb.exe "%PTID%`,%ACCN%`,127.0.0.1",hide
WinWaitActive	통합검사(MainMF)
loop
	WinActivate, Centricity WS ahk_class SunAwtFrame
until	WinActive("Centricity WS")
MouseClick, left, ,
