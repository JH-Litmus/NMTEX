<<<<<<< HEAD
CompDate()
{
mouseclick, left,,
filedelete,  %A_ScriptDir%\save\*.jpg
filedelete,  %A_ScriptDir%\save\*.png

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
runWait, "boxcutter" -c %x1%`,%y1%`,%x2%`,%y2% %A_ScriptDir%\save\Cap.png,%A_ScriptDir%\ext\boxcutter\,hide
runWait, "magick" convert %A_ScriptDir%\save\cap.png -negate %A_ScriptDir%\save\cap.jpg,c:\Program Files\ImageMagick-7.0.7-Q16\,hide
runWait, "tesseract" --psm 7 --oem 0 %A_ScriptDir%\save\Cap.jpg %A_ScriptDir%\save\DateOCR,%OCR_HOME%,hide

; ## Extracting Date \##
FileReadLine, oldd, %A_ScriptDir%\save\DateOCR.txt, 1
mark1 = )
mark2 = ,
StringGetPos, pos1, oldd, %mark1%, R1
StringGetPos, pos2, oldd, %mark2%
pos1 += 2
pos2 += 6
StringLeft, oldd1, oldd, pos2
StringTrimLeft, CompDate, oldd1, pos1

return CompDate
}
=======
CompDate()
{
mouseclick, left,,
filedelete,  %A_ScriptDir%\save\*.jpg
filedelete,  %A_ScriptDir%\save\*.png

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
runWait, "boxcutter" -c %x1%`,%y1%`,%x2%`,%y2% %A_ScriptDir%\save\Cap.png,%A_ScriptDir%\ext\boxcutter\,hide
runWait, "magick" convert %A_ScriptDir%\save\cap.png -negate %A_ScriptDir%\save\cap.jpg,c:\Program Files\ImageMagick-7.0.7-Q16\,hide
runWait, "tesseract" --psm 7 --oem 0 %A_ScriptDir%\save\Cap.jpg %A_ScriptDir%\save\DateOCR,%OCR_HOME%,hide

; ## Extracting Date \##
FileReadLine, oldd, %A_ScriptDir%\save\DateOCR.txt, 1
mark1 = )
mark2 = ,
StringGetPos, pos1, oldd, %mark1%, R1
StringGetPos, pos2, oldd, %mark2%
pos1 += 2
pos2 += 6
StringLeft, oldd1, oldd, pos2
StringTrimLeft, CompDate, oldd1, pos1

return CompDate
}
>>>>>>> 8646a0be21dccc7f449c33bf17658726ad7f491f
