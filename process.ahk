; http://ahkscript.org/boards/viewtopic.php?f=5&t=3443

#SingleInstance force
#NoEnv
SetTitleMatchMode 2
SetWorkingDir %A_ScriptDir%

Gui, -AlwaysOnTop +Caption -ToolWindow +Border -Resize
Gui, Add, listview,x10 r30 w300 vLst gLst +AltSubmit, ProcessName|ProcessID
gosub, LoadProcessList
Gui, 1:Show, Autosize, ProcessList
return

GuiEscape:
GuiClose:
  ExitApp
return

Lst:
    if (A_GuiEvent = "DoubleClick" ) {
        LV_GetText(xNam,A_EventInfo,1)
        LV_GetText(xPid,A_EventInfo,2)
        msgbox % "Pid`t" xpid  "`nName`t" xNam
    }
    if (A_GuiEvent = "RightClick" ) {
        LV_GetText(xNam,A_EventInfo,1)
        LV_GetText(xPid,A_EventInfo,2)
        MsgBox, 36, , Pid : %xPid%`nName :  %xNam%`n`nEnd process?
        ifMsgBox,Yes
        {
            if (SafeProcessKill(xPid))
{
                MsgBox, 64, , Process Successfully ended.
Reload ; Added
}
            else
                MsgBox, 48, , Failure : Could not end the process
        }
    }
return

SafeProcessKill(p) {
    WinClose,ahk_pid %p%
    WinWaitClose,ahk_pid %p%,,1
    if (ErrorLevel) ; Force kill
    {
        MsgBox, 36, , The process refuses to close.`nForce kill?
        ifMsgBox,No
            return 0
        Process,Close,%p%
        return ErrorLevel
    }
    return 1
}

LoadProcessList:
 GuiControl, -Redraw, Lst
  LV_Delete()
  for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
  {    
    lv_add("", Process.Name, process.processID)
  }
  LV_ModifyCol()
  LV_ModifyCol(2,"50 Integer")
  GuiControl, +Redraw, Lst
return