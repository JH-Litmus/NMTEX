#include %A_ScriptDir%\lib\CompDate.ahk
#include %A_ScriptDir%\lib\ReportParse.ahk
#include %A_ScriptDir%\lib\ReportSend.ahk

; ##### variables for ReportParse #####
	Global ExTitle			; Tile of the exam
	Global PTID				; Patient ID
	Global ACCN				; Accession Number

; ##### position of primary mon for PACS #####
	Global Mon1 			; monitor No. for old study for comparison
	Global Mon1Left
	Global Mon1Top
	FileReadLine, mon_num, C:\platinum\support\hardware.properties, 42
	StringRight, mon_num, mon_num, 1
	SysGet, Mon1, Monitor, %mon_num%

; ##### Paths for 1) Rscript, 2) Imagemagick, 3)Tesseract-OCR #####
	Global  R_HOME
	Global  MAG_HOME
	Global  OCR_HOME
	FileReadLine, R_HOME, %A_ScriptDir%\Paths.txt, 1
	FileReadLine, MAG_HOME, %A_ScriptDir%\Paths.txt, 2
	FileReadLine, OCR_HOME, %A_ScriptDir%\Paths.txt, 3

	; RegRead, path1, HKEY_LOCAL_MACHINE\SOFTWARE\R-core\R, InstallPath
	; RegRead, path2, HKEY_LOCAL_MACHINE\SOFTWARE\ImageMagick\Current\, Binpath
	 

^!f::
Return


; ##### Normal templates #####
::noo::
	sendinput	No other abnormal FDG uptake to suggest metastasis in the other regions.
	return

::sss:: 
	sendinput	Relatively preserved salivary gland function of both parotid and submandibular glands on this salivary gland scan using Tc-99m pertechnetate.  
	sendinput	` Advise clinical correlation.
	return

::bss::
	sendinput	Procedure:{enter}	
	sendinput	` 20 mCi of Tc-99m HDP was intravenously injected, and whole body and spot images were obtained 3 hours later. {Enter}
	sendinput	{Enter}
	sendinput	Findings:{enter}
	sendinput	` No osseous lesions suspicious for metastatic disease.{enter}
	sendinput	` Other findings: non-specific/degenerative periarticular uptake.{enter}
	sendinput	{enter}Impression:{enter}
	sendinput	` No scintigraphic evidence of bone metastasis.{enter}{enter}
return
		
; ##### Send PACS report to OCS #####
^!c::
	Array := ReportSend()
	PTID := Array[1]
	ACCN := Array[2]
	RunWait, c:\platinum\ocsweb.exe "%PTID%`,%ACCN%`,127.0.0.1", hide
	WinWaitActive	통합검사(MainMF)
	send	{tab}
	PTID =""
	ACCN = ""
return
		
; ##### reload #####
+!t::
	Reload
return

^!x::
	send !z
return
	
^!n:: 
	if WinExist("제목 없음 - 메모장")
		WinActivate
	else
		Run Notepad
return

; ##### close all tabs of pacs #####
F4:: 				
	loop
		WinClose
	until !WinExist("ahk_class SunAwtDialog")
return

; ##### inversion #####
!r::				
	send	!`;
return

; ##### reset to last saved #####
^!r::				
	send	!a
	send	^+l
return
	
; #######################################################
;	Report Writing
; #######################################################

^d:: 

	;ClipSaved := Clipboardall
	Array := ReportParse()
	ExTitle := Array[1]
	PTID := Array[6]
	ACCN := Array[10]

	MouseMove, 1458,830

	if InStr(ExTitle,"I-") 
		ISPECT(ExTitle)		
	else if InStr(ExTitle, "Lymphangiography")
	{
		sendinput	RI lymphangiography was performed after peritumoral injection of Tc-99m filtered tin colloid for the localization purpose of sentinel LN mapping. The others are not remarkable.
		sendinput	{enter}
	}        
	else if InStr(ExTitle,"131-Iodine")
	{
		StringReplace, ddd01, ExTitle, 131-Iodine,,All
		StringReplace, ddd02, ddd01, mCi Therapy,,All
		StringReplace, ddd, ddd02, %A_SPACE%,,All ; ddd = therapeutic dose
		
		k = 3rd and 7th days
		if ddd = 30
			k = 3rd day		
		sendinput	Radioactive I-131 therapy for thyroid cancer was performed using %ddd% mCi of I-131.{enter}
		sendinput	Whole body I-131 imaging will be acquired on the %k% after ingestion of I-131 capsule.{enter}	
		ddd=''
	}
	else if ExTitle = Whole body Bone scan
	{	
		CompDate := CompDate()
		sendinput	Procedure:{enter}	
		sendinput	` 20 mCi of Tc-99m HDP was intravenously injected, and whole body and spot images were obtained 3 hours later. {Enter}
		sendinput	{Enter}
		sendinput	Findings:{enter}
		sendinput   ` Comparison: previous WBBS (%CompDate%).{enter}	
		sendinput	` No osseous lesions suspicious for metastatic disease.{enter}
		sendinput	` Other findings: none. {enter}
		sendinput	{enter}Impression:{enter}
		sendinput	` No scintigraphic evidence of bone metastasis.{enter}{enter}{space}{up}{space}
		
		if InStr(Array[11], "Bonemetastasis") or InStr(Array[11], "metastasistobone")
			msgbox,0,,Caution: Known bone metastasis
	}
	else	if InStr(ExTitle, "PET-CT Whole Body")
	{
		CompDate := CompDate()
		sendinput	Procedure:{enter}
		sendinput	` 10 mCi of F-18 FDG was given to the patient intravenously. PET imaging using a standard protocol was performed from the neck to the proximal thighs. The obtained images were reconstructed into axial, sagittal, and coronal planes. Low-dose, non-contrast-enhanced CT scan was performed primarily for anatomic localization and attenuation correction.
		sendinput	{Enter}{Enter}
		sendinput	Findings:{enter}
		sendinput   ` Comparison: previous PET/CT (%CompDate%).{enter}
		sendinput	` No discernible FDG uptake to suggest tumor recurrence in this study.{enter}
		sendinput	` No definite metastatic lung nodule.{enter}{enter}
		sendinput	Impression:{enter}
		sendinput	` 1. No evidence of tumor recurrence.{enter}
		sendinput	` {enter}
	}
	else if ExTitle=Salivary Scan
	{	
		sendinput	Procedure:{enter}
		sendinput	` 10 mCi of Tc-99m pertechnetate was intravenously injected. Dynamic images of the salivary glands were obtained before and after the gustatory stimulation.
		sendinput	{Enter}{Enter}
		sendinput	Findings:{enter}
		sendinput	` Prominent Tc-99m pertechnetate uptake and prompt excretion after stimulation by both parotid and submandibular glands.{enter}
		sendinput	{Enter}
		sendinput	Impression:{Enter}
		sendinput	` Normal salivary function.{Enter}
		sendinput	{Enter}
	}
	else if ExTitle = Hepatobiliary scan(DISIDA scan)
	{
		sendinput	The patient was injected with 20 mCi of Tc-99m DISIDA intravenously. Dynamic images of the abdomen were obtained for an hour and multiple spot views of the abdomen were performed.
		sendinput	{Enter}{Enter}	
	}	
	else if ExTitle = [18F] FP-CIT  Brain positron emission computer tomography
	{
		sendinput	5 mCi of F-18 FP-CIT was given to the patient intravenously. PET imaging of the brain was performed using a standard protocol and reconstructed into axial, sagittal, and coronal planes.
		sendinput	{Enter}{Enter}
		sendinput	Normal DAT binding in the striatum.{enter}
	}
	else if ExTitle = Raynaud Scan
	{
		sendinput	Procedure:{enter}
		sendinput	` Raynaud scan was performed after IV injection of 20 mCi of Tc-99m pertenchnetate. Dynamic and serial delayed images were obtained for both chilled and ambient hands.
		sendinput	{Enter}{Enter}
		sendinput	Findings:{enter}
		sendinput	` Loss of initial peak.{enter}
		sendinput	` Significantly lower initial peak height and blood pool uptake in the chilled hand than in the ambient hand.
		sendinput	{Enter}{Enter}
		sendinput	Impression:{enter}
		sendinput	` Positive Raynaud's phenomenon.{enter}
	}
	else if ExTitle = 3-phase Bone scan
	{
		sendinput 	The patient was injected with 740 mCi of Tc-99m HDP intravenously. Dynamic blood flow and pool images were obtained right after the intravenous injection of the radiotracers. Delayed bone images were also acquired 2 to 3 hours later.
		sendinput	{Enter}{Enter}
	}
	else if InStr(ExTitle,"Limited") or Instr(ExTitle, "PET-CT Brain")
	{
		sendinput	10 mCi of F-18 FDG was given to the patient intravenously. PET imaging of the brain was performed using a standard protocol and reconstructed into axial, sagittal, and coronal planes.
		sendinput	{Enter}{Enter}
		sendinput	No abnormal increase or decrease in the regional cerebral and cerebellar glucose metabolism.
		sendinput	{enter}
	}
	else if ExTitle = Whole body Bone scan & SPECT-CT
	{
		sendinput	20 mCi of Tc-99m HDP was intravenously injected and whole body and spot images were obtained. SPECT/CT was performed for accurate localization and better characterization of increased uptake in the bilateral temopral areas.
		sendinput	{Enter}{Enter}
	}

;clipboard := ClipSaved
sleep 1000
loop	{
	send	{LCtrl}
	GetKeyState, state, LCtrl
    if state = U
        break
}
	
return



; #######################################################
;	ISPECT, I-131 SPECT FUNCTION
; #######################################################	
ISPECT(ExTitle)	
{
	; Filedelete, %A_ScriptDir%\save\ReportWBS.txt
	; Filedelete, %A_ScriptDir%\save\Reason4Spect.txt
	; Filedelete, %A_ScriptDir%\save\TherapyLine.txt
	
	Filedelete, %A_ScriptDir%\save\*.txt	
	InputBox, findings, Enter I-131 uptake regions,,

	; ## Anterior neck ##
	if InStr(findings,"5")	{
		ANeck := ["focal uptake", "multifocal uptake"]
		A := ANeck[1]		
		If	InStr(findings, "55")	
			A := ANeck[2]
		fileappend, %A% in the anterior neck.`n, %A_ScriptDir%\save\ReportWBS.txt	
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
			filedelete, %A_ScriptDir%\save\ReportWBS.txt
		loop	{
			sleep 10
		} until fileExist("%A_ScriptDir%\save\ReportWBS.txt")
		fileappend, Multifocal uptakes in the anterior and %L% neck.`n, %A_ScriptDir%\save\ReportWBS.txt		
		}
		else
			fileappend, Radioiodine accumulation in %L% neck.`n, %A_ScriptDir%\save\ReportWBS.txt
	}
	
	if findings not contains 4,5,6
		fileappend, negative.`n, %A_ScriptDir%\save\ReportWBS.txt

	; ## Upper mediastinum ##
	If InStr(findings,"2")	{
		fileappend, Radioiodine accumulation in the upper mediastinum.`n, %A_ScriptDir%\save\ReportWBS.txt
		MNL := ""
		InputBox, MNL, Enter Mediastinal LN stations,,
	}	
	else
		fileappend, negative.`n, %A_ScriptDir%\save\ReportWBS.txt

	; ## Distant metastasis ##
	If InStr(findings,"0")	{
		InputBox, meta, Enter Describe distant uptake [No Period],,
		InputBox, meta_imp, Enter Impression [No Period],,
		fileappend, %meta%`n, %A_ScriptDir%\save\ReportWBS.txt
	}
	else
		fileappend, negative.`n, %A_ScriptDir%\save\ReportWBS.txt	

	; ## Salivary ##
	If InStr(findings,"3")
		fileappend, positive.`n, %A_ScriptDir%\save\ReportWBS.txt
	else	
		fileappend, negative.`n, %A_ScriptDir%\save\ReportWBS.txt	

	; ## Stomach ##
	If InStr(findings,".")
		fileappend, positive.`n, %A_ScriptDir%\save\ReportWBS.txt
	else	
		fileappend, negative.`n, %A_ScriptDir%\save\ReportWBS.txt

		
	; ## Copy dose line on PACS ##
		IfWinExist, Patient Jacket ahk_class SunAwtDialog
			WinActivate
		Else
			send	^p
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
			sleep 100
		send	^c
		fileappend, %Clipboard%, %A_ScriptDir%\save\TherapyLine.txt
		FileReadLine, ddd01, %A_ScriptDir%\save\TherapyLine.txt, 1  
		StringReplace, ddd02, ddd01, %A_SPACE%,,All
		StringGetPos, pos1, ddd02, mCi
		StringGetPos, pos2, ddd02, Iodine
		pos2 += 6
		StringLeft, ddd03, ddd02, pos1
		StringTrimLeft, ddd, ddd03, pos2 ;## ddd ##
		if ddd=
			input, ddd, Enter the RAI dose.
	
	; ## Retrieving Lab ##########
		IfWinExist, 통합결과 조회[ExamRsltIntgView]
			WinActivate	
		WinWaitActive, 통합결과 조회[ExamRsltIntgView]

		MouseClick, left, 260, 235
			sleep 100
		MouseClick, left, 480, 140			
		send	{end}
		send	{Shift down}
		send	{left}{left}{left}{down}{down}
		send	{shift up}
		send	^c
		runWait, "Rscript.exe" %A_ScriptDir%\lib\ColumnReverse.Rexec,%R_HOME%,hide

	;## Reportlines Array ##########
	reportlines := [] 
	Loop, Read, %A_ScriptDir%\save\ReportWBS.txt	
	{
		reportlines.Push(A_LoopReadLine)
	}

	for index, element in reportlines
	{
		line%index% := reportlines[A_index]
	}
		
	; ## Reason for SPECT/CT ##########
	If findings contains 4,5,6
		fileappend, indeterminate radioiodine uptake in the head and neck areas`n,%A_ScriptDir%\save\Reason4Spect.txt
	If InStr(line1, "negative") and InStr(line2, "negative") and InStr(line3, "negative")
		fileappend, indeterminate radioiodine uptake in the head and neck areas`n,%A_ScriptDir%\save\Reason4Spect.txt
	If InStr(line2,2)
		fileappend, I-131 accumulation in the upper mediastinum`n,%A_ScriptDir%\save\Reason4Spect.txt	
	If InStr(findings,0)
		fileappend, %line3%`n,%A_ScriptDir%\save\Reason4Spect.txt
	
	reason_spect := [] 
	Loop, Read, %A_ScriptDir%\save\Reason4Spect.txt	
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
	IfWinExist, report - 메모장
	   WinActivate
	else
		run notepad %A_ScriptDir%\save\report.txt
	WinWaitActive, report - 메모장

	IfNotInString, ExTitle, therapy
	{
		ddd=5
		sendinput I-131 whole body scan for thyroid cancer was performed using 5 mCi of I-131.{enter}{enter}I-131 WBS revealed {enter}
		desc(findings, line1, line2, line3, line4, line5, CNL, MNL, meta_imp,ddd)
		sendinput	{enter}
		sendinput	Advise clinical correlation and follow-up. 
		sendinput 	{enter 2}
		return
	}
	
	if ddd =30		
	{
		sendinput	Radioactive I-131 therapy and whole body I-131 scan for thyroid cancer was performed using %ddd% mCi of I-131.{enter}{enter}Post-RAIT I-131 WBS revealed {enter}
		desc(findings, line1, line2, line3, line4, line5, CNL, MNL, meta_imp,ddd)		
		sendinput	{enter}
		sendinput	Advise clinical correlation and follow-up. 
		sendinput 	{enter 2}
		return
	}	
		
	if	ddd > 50	
	{	
		sendinput	Radioactive I-131 therapy and whole body I-131 scan for thyroid cancer was performed using %ddd% mCi of I-131.{enter}{enter}Post RAIT I-131 WBS revealed{enter}
		sendinput	` Head and Neck: {space}
		; ## 보험관련 ##
			if findings not contains 0,2,4,5,6	
			{
				line1 = negative
				sendinput	Increased uptake in paranasal`, medial orbital`, and/or oral regions.{enter}
			}
			else
				sendinput	%line1% {enter}			
		sendinput	` Mediastinum: %line2% {enter}
		sendinput 	` Liver: negative. {enter}
		sendinput	` Distant regions: %line3%{enter}
		sendinput	` Salivary gland: %line4% {enter}
		sendinput	` Stomach: %line5% {enter}
		sendinput	{enter}
		sendinput 	Stimulated Tg Responsiveness {enter}
		sendinput	^v
		sendinput	{enter}	
		sendinput	Advise SPECT/CT for accurate localization and better characterization of %reason_spect% as benign or malignant in LN and distant metastasis.{enter}
		sendinput	{enter	3}		
		sendinput	Regional SPECT/CT was performed for accurate localization and better characterization of %reason_spect% as benign or malignant in LN and distant metastasis.{enter}{enter}I-131 SPECT/CT revealed{enter}
		
		desc(findings, line1, line2, line3, line4, line5, CNL, MNL, meta_imp,ddd)
		
		sendinput	Advise clinical correlation and follow-up with FDG PET/CT scan 6 months later. 
		sendinput 	{enter 2}
		return
	}

}
	
		
; #######################################################
;	I-131 WBS/SPECT description
; #######################################################

desc(findings, line1, line2, line3, line4, line5, CNL, MNL, meta_imp,ddd)
{
	StringReplace, FNUM, findings, .,,all
	FNUM += 1
	sendinput	` Thyroid bed uptake{space}	
		if InStr(findings, "5") and (ddd<40)
			sendinput	({+}){enter}
		else if InStr(findings, "5")
				sendinput	({+}){enter}` ` ` : Benign uptake, i.e. remnant thyroid tissue.{enter}
		else	
			sendinput	({-}){enter}
	sendinput	` Regional neck LN uptake
		if findings contains 4,6
			sendinput	` ({+}),
		else	
			sendinput	` ({-}),
	sendinput	` and upper mediastinal LN uptake 
		if findings contains 2
		{
			sendinput	` ({+}){enter}
			if	findings not contains 4,6
				sendinput	` ` ` : %MNL%{enter}
			else
				sendinput	` ` ` : %CNL%, %MNL%{enter}
		}
		else	
			sendinput	` ({-}){enter}
	sendinput 	` Liver uptake (-) {enter}
	sendinput	` Distant metastasis{space} 
		if findings contains 0
			sendinput	({+}){enter}` ` ` : %meta_imp%{enter}
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
		if	ddd=30
			sendinput 	` none.{enter}			
		else if ddd=5
			sendinput 	` none.{enter}			
		else if findings not contains	 0,2,5,55
			sendinput	{enter}` ` ` Benign retention in nasolacrimal duct, nasal secretion, or prosthetic denture.{enter}
		else
			sendinput 	` none. {enter}
	sendinput	{enter}
	sendinput 	Stimulated Tg Responsiveness {enter}
	sendinput	^v
	sendinput	{enter}
	
	return
}