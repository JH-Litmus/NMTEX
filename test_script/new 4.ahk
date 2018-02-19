Filedelete, %A_ScriptDir%\save\Ispect_report.txt
Filedelete, %A_ScriptDir%\save\reason_spect.txt
Filedelete, %A_ScriptDir%\save\ispect_def.txt	

InputBox, findings, Enter I-131 uptake regions,,

; ## 보험관련 ##
if findings not contains 0,2,4,5,6	
{
	if ddd > 30
		fileappend, Increased uptake in paranasal`, medial orbital`, and/or oral regions.`n, %A_ScriptDir%\save\Ispect_report.txt
	else
		fileappend, Negative.`n, %A_ScriptDir%\save\Ispect_report.txt
}

; ## Anterior neck ##
if InStr(findings,"5")	{
	ANeck := ["Focal uptake", "Multifocal uptake"]
	A := ANeck[1]		
	If	InStr(findings, "55")	A := ANeck[2]
	fileappend, %A% in the anterior neck.`n, %A_ScriptDir%\save\Ispect_report.txt	
}

; ## Lateral neck ##
if InStr(findings, "4") or InStr(findings,"6")	{
	CNL := ""
	InputBox, CNL, Enter Cervical LN Locations,,		
	LRNeck := ["Rt. lateral","Lt. lateral", "the bilateral"]
	L := LRNeck[1]
	If not InStr(findings, "4")	
		L := LRNeck[2]
	If InStr(findings, "46") 
		L := LRNeck[3]
	if InStr(findings,"5") or InStr(findings,"55")	{
		filedelete, %A_ScriptDir%\save\Ispect_report.txt
			loop	{
				sleep 10
				IfNotExist, %A_ScriptDir%\save\Ispect_report.txt
					break
			}
		fileappend, Multifocal uptakes in the anterior and %L% neck.`n, %A_ScriptDir%\save\Ispect_report.txt		
	}
	else
		fileappend, Radioiodine accumulation in %L% neck.`n, %A_ScriptDir%\save\Ispect_report.txt
}

; ## Upper mediastinum ##
If InStr(findings,"2")	{
	mark3 := "+"
	fileappend, Radioiodine accumulation in the upper mediastinum.`n, %A_ScriptDir%\save\Ispect_report.txt
	MNL := ""
	InputBox, MNL, Enter Mediastinal LN stations,,
}	
else
	fileappend, Negative.`n, %A_ScriptDir%\save\Ispect_report.txt

; ## Distant metastasis ##
If InStr(findings,"0")	{
	mark4 := "+"
	InputBox, meta, Enter Describe distant uptake [No Period],,
	InputBox, meta_imp, Enter Impression [No Period],,
	fileappend, %meta%`n, %A_ScriptDir%\save\Ispect_report.txt
}
else
	fileappend, Negative`n, %A_ScriptDir%\save\Ispect_report.txt	

; ## Salivary ##
If InStr(findings,"3")
	fileappend, Positive.`n, %A_ScriptDir%\save\Ispect_report.txt
else	
	fileappend, Negative.`n, %A_ScriptDir%\save\Ispect_report.txt	

; ## Stomach ##
If InStr(findings,".")
	fileappend, Positive.`n, %A_ScriptDir%\save\Ispect_report.txt
else	
	fileappend, Negative.`n, %A_ScriptDir%\save\Ispect_report.txt

	
; ## Retrieving Lab ##########

	IfWinExist, Patient Jacket ahk_class SunAwtDialog
				WinActivate
		WinWaitActive, Patient Jacket ahk_class SunAwtDialog
		
	MouseClick, left, 800, 135
		send	1{enter}
		sleep	100
	MouseClick, left, 1260, 100
	MouseClick, left, 1260, 100
		sleep 200
	MouseClick, left, 800, 175
		sleep 500
	MouseClick, left, 800, 175
		
		send	^c
		fileappend, %Clipboard%, %A_ScriptDir%\save\ispect_def.txt
		sleep 100
		FileReadLine, ddd01, %A_ScriptDir%\save\ispect_def.txt, 1
			
		StringReplace, ddd02, ddd01, %A_SPACE%,,All
			StringGetPos, pos1, ddd02, mCi
			StringGetPos, pos2, ddd02, Iodine
		
		pos2 += 6
		StringLeft, ddd03, ddd02, pos1
		StringTrimLeft, ddd, ddd03, pos2
		
		IfWinExist, 통합결과 조회[ExamRsltIntgView]
			WinActivate	
		WinWaitActive, 통합결과 조회[ExamRsltIntgView]

		MouseClick, left, 260, 235
		sleep 500
		MouseClick, left, 480, 140
		sendinput	{end}
		sendinput	{Shift down}
		sendinput	{left}{left}{left}{down}{down}
		sendinput	{shift up}
		send	^c
		runWait, %A_ScriptDir%\lib\col_change.rexec,,hide

	IfWinExist, report - 메모장 ahk_class Notepad
	   WinActivate
	else
		run notepad %A_ScriptDir%\sav\report.txt
	WinWaitActive, report - 메모장 ahk_class Notepad
	
	
;## Array ##########
Array := [] 
Loop, Read, %A_ScriptDir%\save\Ispect_report.txt	
{
    Array.Push(A_LoopReadLine)
}

for index, element in Array
{
    line%index% := Array[A_index]
}
	
; ## Reason for SPECT/CT ##########
If line1 not contains negative	
	fileappend, indeterminate radioiodine uptake in the head and neck areas`n,%A_ScriptDir%\save\reason_spect.txt
if line2 not contains negative
	fileappend, I-131 accumulation in the upper mediastinum`n,%A_ScriptDir%\save\reason_spect.txt	
if line3 not contains negative
	fileappend, %line3%`n,%A_ScriptDir%\save\reason_spect.txt

reason_spect := [] 
Loop, Read, %A_ScriptDir%\save\reason_spect.txt	
{
    reason_spect.Push(A_LoopReadLine)
}

for index, element in reason_spect	
{
    reason%index% := reason_spect[A_index]
}

if reason_spect.Length() = 1	
	reason_spect := reason1
if reason_spect.Length() = 2	
	reason_spect := % reason1 . " and " . reason2
if reason_spect.Length() = 3	
	reason_spect := % reason3 . ", " . reason2 . ", and " . reason1
	
; ## Writing Down ##########
	IfWinExist, report - 메모장 ahk_class Notepad
	   WinActivate
	else
		run notepad %A_ScriptDir%\sav\report.txt
	WinWaitActive, report - 메모장 ahk_class Notepad

if	ddd > 50	{	; high dose
sendinput	Radioactive I-131 therapy and whole body I-131 scan for thyroid cancer was performed using %ddd% mCi of I-131.{enter}{enter}Post RAIT I-131 WBS revealed{enter}
sendinput	` Neck uptake: %line1% {enter}
sendinput	` Upper mediastinal uptake: %line2% {enter}
sendinput	` Distant metastasis: %line3%. {enter}
sendinput	` Salivary gland uptake: %line4% {enter}
sendinput	` Stomach uptake: %line5% {enter}
sendinput	{enter}
sendinput 	Stimulated Tg Responsiveness {enter}
sendinput	^v
sendinput 	{enter 2}
sendinput	Advise SPECT/CT for accurate localization and better characterization of %reason_spect% as benign or malignant in LN and distant metastasis.{enter}
sendinput	{enter	3}

sendinput	Regional SPECT/CT was performed for accurate localization and better characterization of %reason_spect% as benign or malignant in LN and distant metastasis.{enter}{enter}I-131 SPECT/CT revealed{enter}
sendinput	` Thyroid bed uptake
	if findings contains 5,55
		sendinput	({+}){enter}` ` ` : Benign uptake, i.e. remnant thyroid tissue.{enter}
	else	
		sendinput	({-}){enter}
sendinput	` Regional neck LN uptake
	if findings contains 4,6
		sendinput	({+}),
	else	
		sendinput	({-}),
sendinput	` and upper mediastinal LN uptake
	if findings contains 2
	{
		sendinput	({+}){enter}
		if	CNL = ""
			sendinput	` ` ` : %MNL%{enter}
		sendinput	` ` ` : %CNL%, %MNL%{enter}
	}
	else	
		sendinput	({-}){enter}
sendinput 	` Liver uptake (-) {enter}
sendinput	` Distant metastasis{space} 
	if findings contains 0
		sendinput	({+}){enter}` ` ` :%meta_imp%{enter}
	else	
		sendinput	({-}){enter}
sendinput	` Salivary gland uptake{space} 
	if findings contains 3
		sendinput	({+}){enter}		
	else	
		sendinput	({-}){enter}
sendinput	` Stomach uptake{space}
	if findings contains .
		sendinput	({+}){enter}
	else	
		sendinput	({-}){enter}
sendinput	` Other findings: 
	if (findings not contains 0,2,4,5,6) and (ddd > 30)
		sendinput	{enter}` ` ` Benign retention in nasolacrimal duct, nasal secretion, or prosthetic denture.{enter}
	else
		sendinput 	` None. {enter}
sendinput	{enter}
sendinput 	Stimulated Tg Responsiveness {enter}
sendinput	^v
sendinput 	{enter 2}
Sendinput	Advise clinical correlation and follow-up with FDG PET/CT scan 6 months later. 
 sendinput 	{enter 2}

return