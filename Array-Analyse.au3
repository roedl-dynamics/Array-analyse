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
Global $zwischenWerte ;Array das die Werte aus der Datei zwischenspeichert um die Größe nicht mit einzusortieren

GUISetState(@SW_SHOWNA)
While 1
	Local $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $buttonDialog
			dateiAuslesen()
		Case $eingabeButton
			arrayBefuellen()
	EndSwitch
WEnd

; Methoden
Func groessterWert()
	Local $highest = $werte[0]
    For $i = 0 to UBound($werte)-1
		If $werte[$i] > $highest then
			$highest = $werte[$i]
		EndIf
		;ConsoleWrite("i: "&$i)
		;ConsoleWrite("höchster: "&$highest)
		;ConsoleWrite("wert: "&$werte[$i]& @CRLF)
	Next
	;$highest = Round($highest,3)
	GUICtrlSetData($Liste,"höchster Wert: "&$highest)
EndFunc

Func kleinsterWert()
	Local $smallest = $werte[0]
	For $i = 0 to UBound($werte)-1
		If $werte[$i] < $smallest then
			$smallest = $werte[$i]
		EndIf
	Next
	;$smallest = Round($smallest,3)
	GUICtrlSetData($Liste,"kleinster Wert: "&$smallest)
EndFunc

Func summe()
	;Local $i
	Local $summe = 0
	_ArrayDisplay($werte)
	For $i = 0 to UBound($werte)-1
		$summe = $summe + $werte[$i]
		ConsoleWrite("Summe: "&$summe&@CRLF)
		$summe = Round($summe,3)

		ConsoleWrite("$summe="&$summe&@CRLF)
		ConsoleWrite("i: "&$i&@CRLF)
	Next
	;GUICtrlSetData($Liste,"Summe: "&$summe)
	;ConsoleWrite("Summe: "&$summe)
	return $summe
EndFunc

Func mittelWert()
	Local $mittelWert
	Local $summe = summe()
	ConsoleWrite("Arraygröße"&UBound($werte)-1&@CRLF)
	$mittelWert = Round($summe/(UBound($werte)),3)
	;$mittelWert = Round($mittelWert,3)
	ConsoleWrite("Summe: "&$summe)
	;ConsoleWrite("Werte: " & UBound($werte)-1)
	;ConsoleWrite("Mittelwert:"& $mittelWert)
	GUICtrlSetData($Liste,"Mittelwert: "&$mittelWert)
EndFunc

;liest die werte aus der Ausgewählten Datei in das Array ein
Func dateiAuslesen()
	Local $dateiPfad = FileOpenDialog("Wählen sie eine CSV-Datei aus", @WindowsDir & "\", "CSV(*.csv)", BitOR($FD_FILEMUSTEXIST, $FD_MULTISELECT))
	Local $zwischenWerte
	_FileReadToArray($dateiPfad,$zwischenWerte) ; ließt die Datei in ein Array aus
	;_ArrayDisplay($zwischenWerte)
	For $zeile = 1	To Ubound($zwischenWerte)-1
		ConsoleWrite("zeile: "&$zeile)
		Local $zahl = StringSplit($zwischenWerte[$zeile],";")
	Next
	;Convertieren in Nummern
	For $n = 1 to UBound($zwischenWerte)-1
		$zwischenWerte[$n] = Number(StringReplace($zwischenWerte[$n],",","."))
	Next
	Local $grosse = UBound($zwischenWerte)-1
	Global $werte[$grosse]
	;zwischenwerte den Werten zuweisen ohne größe des Arrays
	For $i = 1 To UBound($zwischenWerte)-1
		$werte[$i-1] = $zwischenWerte[$i]
		;ConsoleWrite("i:"&$i)
	Next
	;_ArrayDisplay($werte)
	GUICtrlSetData($eingabeFeld,$dateiPfad)
EndFunc

Func arrayBefuellen()
	Local $dateiPfad = GUICtrlRead($eingabeFeld)
	If $dateiPfad == "" Then
		GUICtrlSetData($Liste,"Fehler: es wurde kein Dateipfad angegeben")
	Else
		GUICtrlSetData($Liste,"Summe: "& summe())
		mittelWert()
		groessterWert()
		kleinsterWert()
		gestutzMittel()
	EndIf
EndFunc

Func gestutzMittel()
	Local $ArrayGroesse = UBound($werte)-1
	;MsgBox(0,"Arraygröße",$ArrayGroesse)
	;MsgBox(0,"",$n)
	Local $x = UBound($werte)-1
	;_ArrayDisplay($werte)
	_ArraySort($werte)
	;_ArrayDisplay($werte)
	Local $startWert = Round($ArrayGroesse*0.1,0)
	;ConsoleWrite("Startwert: "&$startWert & @CRLF)
	Local $obereGrenze = $ArrayGroesse-$startWert
	Local $summe = 0
	For $i = $startWert to $obereGrenze
		;Local $zeilenwert = $werte[$i]
		;ConsoleWrite("Zeilenwert: "& $zeilenwert&@CRLF)
		;$zeilenwert = StringReplace($zeilenwert,",",".")
		;$summe = $summe + Number($zeilenwert)
		;$summe = $summe + Number($werte[i])
		$summe = $werte[$i] + $summe
		$summe = Round($summe,3)
	Next
	Local $anzahlBerucksichtigt = ($ArrayGroesse-(2*$startWert))+1
	Local $gestutzt = $summe/$anzahlBerucksichtigt
	$gestutzt = Round($gestutzt,3)
	;ConsoleWrite("Obergrenze: "&$obereGrenze &@CRLF)
	;ConsoleWrite("Summe: "&$summe &@CRLF)
	;ConsoleWrite("Anzahl: "&$anzahlBerucksichtigt)
	GUICtrlSetData($Liste,"Gestutztesmittel: "& $gestutzt & @CRLF)
	;_ArrayDisplay($werte)
EndFunc