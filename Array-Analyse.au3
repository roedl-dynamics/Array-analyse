#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
; Script Start - Add your code below here
Opt ("MustDeclareVars",1)
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <File.au3>
#include <FileConstants.au3>

Global $Fenster = GUICreate("Array Analyse",400,400)
Global $eingabeFeld = GUICtrlCreateInput("",30,30,230,30)
Global $buttonDialog = GUICtrlCreateButton("...",300,30,70,30 )
Global $eingabeButton = GUICtrlCreateButton("Berechnungen druchführen",30,100,340,50)
Global $Liste = GUICtrlCreateList("", 30,170, 340,200)
Global $werte ;das Array in dem die Werte gespeichert werden

GUISetState(@SW_SHOWNA)
While 1
	Local $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $buttonDialog
			arrayAuslesen()
		Case $eingabeButton
			arrayBefuellen()
	EndSwitch
WEnd

; Methoden
Func groessterWert()
	Local $highest = $werte[0]
    For $i = 1 to $werte[0]
		If $werte[$i] > $highest then
			$highest = $werte[$i]
		EndIf
	Next
	;$highest = Round($highest,3)
	GUICtrlSetData($Liste,"höchster Wert: "&$highest)
EndFunc

Func kleinsterWert()
	Local $smallest = $werte[0]
	For $i = 1 to $werte[0]
		If $werte[$i] < $smallest then
			$smallest = $werte[$i]
		EndIf
	Next
	;$smallest = Round($smallest,3)
	GUICtrlSetData($Liste,"kleinster Wert: "&$smallest)
EndFunc

Func summe()
	Local $i
	Local $summe = 0
	For $i = 1 to $werte[0]
		;$summe = $summe+$werte[$i]
		Local $zeilenwert = $werte[$i]
		$zeilenwert = StringReplace($zeilenwert,",",".")
		$summe = $summe + Number($zeilenwert)
		$summe = Round($summe,3)
		ConsoleWrite("$zeilenwert="&$zeilenwert&@CRLF)
		ConsoleWrite("$summe="&$summe&@CRLF)
		ConsoleWrite("i="&$i&@CRLF)
	Next
	GUICtrlSetData($Liste,"Summe: "&$summe)
EndFunc

Func mittelWert()
	Local $mittelWert
	Local $summe = 0
	For $i = 1 to $werte[0]
		;$summe = $summe+$werte[$i]
		Local $zeilenwert = $werte[$i]
		$zeilenwert = StringReplace($zeilenwert,",",".")
		$summe = $summe + Number($zeilenwert)
		$summe = Round($summe,3)
		ConsoleWrite("$zeilenwert="&$zeilenwert&@CRLF)
		ConsoleWrite("$summe="&$summe&@CRLF)
		ConsoleWrite("i="&$i&@CRLF)
	Next
	$mittelWert = Round($summe/UBound($werte),3)
	;$mittelWert = Round($mittelWert,3)
	GUICtrlSetData($Liste,"Mittelwert: "&$mittelWert)
EndFunc

Func arrayAuslesen ()
	Local $dateiPfad = FileOpenDialog("Wählen sie eine CSV-Datei aus", @WindowsDir & "\", "CSV(*.csv)", BitOR($FD_FILEMUSTEXIST, $FD_MULTISELECT))
	_FileReadToArray($dateiPfad,$werte) ; ließt die Datei in ein Array aus
	;_ArrayDisplay($werte)
	For $zeile = 1 To Ubound($werte)-1
		Local $zahl = StringSplit($werte[$zeile],";")
	Next
	GUICtrlSetData($eingabeFeld,$dateiPfad)
EndFunc

Func arrayBefuellen()
	Local $dateiPfad = GUICtrlRead($eingabeFeld)
	If $dateiPfad == "" Then
		GUICtrlSetData($Liste,"Fehler: es wurde kein Dateipfad angegeben")
	Else
		summe()
		mittelWert()
		groessterWert()
		kleinsterWert()
		gestutztMittel()
	EndIf
EndFunc

Func gestutztMittel()
	_ArraySort($werte)
	_ArrayDisplay($werte)
	Local $groesseArray = UBound($werte)
	;MsgBox(0,"ArrayGröße",$groesseArray)
	Local $x = Round($groesseArray * 0.2,0)
	;MsgBox(0,"Rausfallende werte(Anzahl): ",$x)
	Local $y = ($groesseArray-$x)-1 ; bestimmt die obere Grenze
	MsgBox(0,"Oberegrenze: ",$y)
	Local $summe = 0
	For $i = $x to $y
		MsgBox(0,"i:",$i)
		$summe = $summe+$werte[$i]
	Next
	MsgBox(0,"Summe: ",$summe)
	Local $anzahl = $groesseArray - 2*$x
	MsgBox(0,"Anzahl: ",$anzahl)
	Local $mittelGest = $summe-$anzahl
	MsgBox(0,"Gestutzter Mittelwert:",$mittelGest)
EndFunc