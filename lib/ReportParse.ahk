/*
; 1 exam_title
; 2 ref_ser
; 3 req_phy
; 45 pat_namek
; 5 pat_namee
; 6 Pat_id
; 7 dob
; 8 gender
; 9 exam_date
; 10 acc_num
; 11 hx
*/

ReportParse() 
{
	filedelete, %A_ScriptDir%\save\ReportPanel.txt
	clipboard=""
	
	Send	^a
	send	^c
	fileappend, %Clipboard%, %A_ScriptDir%\save\ReportPanel.txt
	sendinput	^v
	
	loop{
		sleep 10		
		IfExist, %A_ScriptDir%\save\ReportPanel.txt
		break
		}
					
	FileReadLine, XLINE, %A_ScriptDir%\save\ReportPanel.txt, 4 ; exam_title, ref_ser, exam_status
		if XLINE = ""
			return
		StringGetPos, pos_ref, XLINE, Referring
		StringGetPos, pos_status, XLINE, Exam Status
		
		pos_ref -= 5
		StringLeft, exam01, XLINE, pos_ref
			StringTrimLeft, exam_title, exam01, 17
		
		pos_status -= 5
		StringLeft, ref01, XLINE, pos_status
		StringtrimLeft, ref02, ref01, pos_ref
			StringTrimLeft, ref_ser, ref02, 25
			
	FileReadLine, XLINE, %A_ScriptDir%\save\ReportPanel.txt, 5 ; req_phy
		StringGetPos, pos_datesch, Xline, Date
				
		pos_datesch -= 5
		StringLeft, exam01, XLINE, pos_datesch
			StringTrimLeft, req_phy, exam01, 23
			
	FileReadLine, XLINE, %A_ScriptDir%\save\ReportPanel.txt, 7 ; pat_namek, pat_namee, Pat_id
		StringGetPos, pos_id, XLINE, Patient ID
			
		pos_id -= 30
		StringLeft, exam01, XLINE, pos_id
		StringTrimLeft, exam02, exam01, 15
		StringGetPos, pos_slash, exam02, `/
		
		pos_slash += 2
			StringTrimLeft, pat_namek, exam02, pos_slash
		
		pos_slash -= 3
			StringLeft, pat_namee, exam02, pos_slash
		
		pos_id += 43
		StringtrimLeft, exam01, XLINE, pos_id
		StringTrimRight, pat_id, exam01, 1
	
	FileReadLine, XLINE, %A_ScriptDir%\save\ReportPanel.txt, 8 ; dob, gender, exam_date
		StringReplace, exam01, XLINE, %A_Space%,,All
		StringTrimLeft, exam02, exam01, 10
			StringRight, exam_date, exam02, 10
			StringLeft, dob, exam02, 10
		StringTrimLeft, exam03, exam02, 14
			StringTrimRight, gender, exam03, 21
			
	FileReadLine, XLINE, %A_ScriptDir%\save\ReportPanel.txt, 9 ; acc_num
		StringReplace, exam01, XLINE, %A_Space%,,All
			StringTrimLeft, acc_num, exam01, 7
	
	FileReadLine, XLINE, %A_ScriptDir%\save\ReportPanel.txt, 11 ; hx
		StringReplace, exam01, XLINE, %A_Space%,,All
			StringTrimLeft, hx, exam01, 14
		
		
	Array := [exam_title,ref_ser,req_phy,pat_namek,pat_namee,Pat_id,dob,gender,exam_date,acc_num,hx]

	return Array
		
}