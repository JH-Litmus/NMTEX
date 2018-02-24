CompDate()
{
	mouseclick, left,,
	filedelete,  %A_ScriptDir%\save\DateOCR.txt
	filedelete,  %A_ScriptDir%\save\*.jpg
	
	; ## Capture position ##
	x1 = %Mon1Left%
	y1 = %Mon1Top%
		if InStr(ExTitle,"PET")	
			y1 +=1070		
		else
			y1 +=150		
	x2 := x1 + 700
	y2 := y1 + 35
	
	; ## Capture, inversion, OCR-Read ##
	runWait, "boxcutter" -c %x1%`,%y1%`,%x2%`,%y2% %A_ScriptDir%\save\cap.png,%A_ScriptDir%\ext\boxcutter\,hide
	runWait, "magick" convert %A_ScriptDir%\save\cap.png -colors 2 -monochrome %A_ScriptDir%\save\cap.jpg,%MAG_HOME%,hide
	runWait, "tesseract" --psm 7 --oem 0 %A_ScriptDir%\save\cap.jpg %A_ScriptDir%\save\DateOCR,%OCR_HOME%,hide
	
	; ## Extracting Date \##
	FileReadLine, oldd, %A_ScriptDir%\save\DateOCR.txt, 1
	mark1 = )
	mark2 = ,
	StringGetPos, pos1, oldd, %mark1%, R1
	StringGetPos, pos2, oldd, %mark2%, R1
	pos1 += 2
	pos2 += 6
	StringLeft, oldd1, oldd, pos2
	StringTrimLeft, CompDate, oldd1, pos1
	
	return CompDate
}