ReportSend() 
{
	filedelete, %A_ScriptDir%\save\Report*.txt
	clipboard=""
	
	Send	^a
	send	^c
	fileappend, %Clipboard%, %A_ScriptDir%\save\ReportPanel.txt
	fileappend, `$, %A_ScriptDir%\save\ReportPanel.txt
	sendinput	^v
		
	L = 14
	Loop
	{		
		FileReadLine, RLINE,  %A_ScriptDir%\save\ReportPanel.txt, L
		If InStr(RLINE, "$")
			break
		FileAppend, %RLINE%`n, %A_ScriptDir%\save\ReportCopy.txt
		L +=1		
	}	
	FileRead, clipboard, %A_ScriptDir%\save\ReportCopy.txt
		
	FileReadLine, XLINE, %A_ScriptDir%\save\ReportPanel.txt, 7 ; pat_namek, pat_namee, Pat_id
		StringGetPos, pos_id, XLINE, Patient ID
		pos_id += 13
		StringtrimLeft, exam01, XLINE, pos_id
		StringTrimRight, pat_id, exam01, 1
	
	FileReadLine, XLINE, %A_ScriptDir%\save\ReportPanel.txt, 9 ; acc_num
		StringReplace, exam01, XLINE, %A_Space%,,All
		StringTrimLeft, acc_num, exam01, 7
	Array := [Pat_id, acc_num]	
	return Array		
}