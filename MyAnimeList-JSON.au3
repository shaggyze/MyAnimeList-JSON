;MyAnimeList-JSON by ShaggyZE
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=mal.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Comment=MyAnimeList-JSON
#AutoIt3Wrapper_Res_Description=MyAnimeList-JSON
#AutoIt3Wrapper_Res_Fileversion=0.0.0.14
#AutoIt3Wrapper_Res_LegalCopyright=ShaggyZE
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#region Includes
#include-once
#include <Inet.au3>
#include <Json.au3>
#include <Array.au3>
#include <String.au3>
#include <MsgBoxConstants.au3>
#include <GuiButton.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiComboBoxEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <IE.au3>
#include <Math.au3>
#include <GUIListView.au3>
#include <WinAPI.au3>
#include <File.au3>
#include <Misc.au3>
#include <vkConstants.au3>
#include <GUIScrollBars_Ex.au3>
#include <GuiScrollBars.au3>
#include <GuiScroll.au3>
#include <GUICtrl_SetResizing.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
#include <ColorConstants.au3>
#include <GUIMenu.au3>
#include <GuiEdit.au3>
#endregion Includes
Global $szText, $szText, $szURL, $szID, $sValue1, $sValue2, $szDelay, $Username, $CSS, $Method, $anime_id, $anime_ids, $manga_id, $manga_ids, $data, $o
Global $version = "0.0.0.14"
Local $hGUI = GUICreate("MyAnimeList-JSON v" & $version & "                                                          To Pause or Close Click the MAL Icon in your System Tray at the Bottom Right", 900, 430, -1, -1, -1)
Local $hSysMenu = _GUICtrlMenu_GetSystemMenu($hGUI)
_GUICtrlMenu_DeleteMenu($hSysMenu, $SC_CLOSE, False)
_GUICtrlMenu_DeleteMenu($hSysMenu, $SC_MAXIMIZE, False)
GUISetIcon(@ScriptDir & "\mal.ico")
;GUI Frontend
$ButtonS = GUICtrlCreateButton("Start", 5, 5, 45, 20)
GUICtrlSetTip(-1, "Click to Start")
$UsernameINP = GUICtrlCreateInput("ShaggyZE", 80, 5, 100, 20)
GUICtrlSetTip(-1, "Your Mal Username")
GUICtrlCreateLabel("Output", 225, 10, 65, 20)
GUICtrlSetTip(-1, "This is where your CSS code will be")
$Progress = GUICtrlCreateLabel("", 60, 40, 100, 20, $SS_CENTER, $WS_EX_TOPMOST)
GUICtrlSetTip(-1, "")
GUICtrlCreateLabel("Delay", 5, 60, 65, 20)
GUICtrlSetTip(-1, "Milliseconds between Scraping MyAnimeList.net")
$DelayINP = GUICtrlCreateInput("2000", 5, 80, 40, 20)
GUICtrlSetTip(-1, "Milliseconds between Scraping MyAnimeList.net")
GUICtrlCreateLabel("Template", 5, 110, 65, 20)
GUICtrlSetTip(-1, "CSS Template")
$TemplateINP = GUICtrlCreateInput("#tags-[ID]:after {font-family: Finger Paint; content: '[DESC]';}", 5, 130, 220, 20)
GUICtrlSetTip(-1, "CSS Template")
GUICtrlCreateLabel("Method", 5, 160, 65, 20)
GUICtrlSetTip(-1, "Method of scraping Data for CSS")
$methodCMB = GUICtrlCreateCombo("MAL-Anime", 5, 180, 150, 20)
GUICtrlSetData(-1, "MAL-Manga|load.json-Anime-MAL|load.json-Manga-MAL|load.json-Anime-Jikan|load.json-Manga-Jikan|load.json-Anime-JSON|load.json-Manga-JSON")
GUICtrlSetTip(-1, "Method of scraping Data for CSS")
GUICtrlCreateLabel("Start and Finish", 5, 210, 100, 20)
GUICtrlSetTip(-1, "ID# from Start to Finsh")
$FromINP = GUICtrlCreateInput("0", 5, 230, 40, 20)
GUICtrlSetTip(-1, "Start ID#")
$ToINP = GUICtrlCreateInput("49500", 45, 230, 40, 20)
GUICtrlSetTip(-1, "Finish ID#")
$OutputINP = GuiCtrlCreateEdit("Newly generated code will be output here.", 225, 25, 675, 405, $ES_MULTILINE)
GUICtrlSetStyle($OutputINP, $WS_VSCROLL)
_GUICtrlEdit_SetReadOnly(ControlGetHandle($hGUI,"",$OutputINP),True)
GUICtrlSetTip(-1, "Newly generated code will be output here.")
GUISetState(@SW_SHOW)
$szFile1 = "scrape.txt"
$szFile2 = "mal.css"
$szFile3 = "scrape.html"
$x = @DesktopWidth - 150
$y = @DesktopHeight - 62.5
GUISetState(@SW_SHOW, $hGUI)
While GUIGetMsg() <> $GUI_EVENT_CLOSE
Sleep(10)
	$nMsg = GUIGetMsg()

	Switch $nMsg
		;Exit
		Case $GUI_EVENT_CLOSE
			Exit (20)
		;Start
		Case $ButtonS
			$Method = GUICtrlRead($methodCMB)
			If $Method = "MAL-Anime" Then
				$sValue1 = GUICtrlRead($FromINP)
				$sValue2 = GUICtrlRead($ToINP)
				If $sValue1 = "" Then $sValue1 = "0" And GUICtrlSetData($FromINP, 0)
				If $sValue2 = "" Then $sValue2 = "49500" And GUICtrlSetData($ToINP, "49500")
				FileDelete($szFile2)
				$CSS = GUICtrlRead($TemplateINP)
				$szText = '/* Generated by MyAnimeList-JSON https://github.com/shaggyze/MyAnimeList-JSON' & @CRLF & 'Template=' & $CSS & '*/'
				FileWrite($szFile2, $szText)
				ToolTip("Scraping MAL data...", $x, $y)
				Sleep(2000)
				_ScrapeMAL("anime")
				FileDelete($szFile1)
				FileDelete($szFile3)
			ElseIf $Method = "MAL-Manga" Then
				$sValue1 = GUICtrlRead($FromINP)
				$sValue2 = GUICtrlRead($ToINP)
				If $sValue1 = "" Then $sValue1 = "0" And GUICtrlSetData($FromINP, 0)
				If $sValue2 = "" Then $sValue2 = "138900" And GUICtrlSetData($ToINP, "138900")
				FileDelete($szFile2)
				$CSS = GUICtrlRead($TemplateINP)
				$szText = '/* Generated by MyAnimeList-JSON https://github.com/shaggyze/MyAnimeList-JSON' & @CRLF & 'Template=' & $CSS & '*/'
				FileWrite($szFile2, $szText)
				ToolTip("Scraping MAL data...", $x, $y)
				Sleep(2000)
				_ScrapeMAL("manga")
				FileDelete($szFile1)
				FileDelete($szFile3)
			ElseIf $Method = "load.json-Anime-MAL" Then
				$data = ""
				$o = 0
				_ScrapeloadjsonAnimeMAL()
			ElseIf $Method = "load.json-Manga-MAL" Then
				$data = ""
				$o = 0
				_ScrapeloadjsonMangaMAL()
			EndIf
		Case Else
			;MsgBox(0,"",$nMsg)
	EndSwitch
WEnd


Func _ParseHTML($szID)
$parseStr =  FileRead($szFile1,FileGetSize($szFile1))
$parseStr =  StringReplace($parseStr, @LF, "")
$parseStr =  StringReplace($parseStr, @CR, "")
$parseStr =  StringReplace($parseStr, @CRLF, "")
$parseStr =  StringReplace($parseStr, '"', '')
$parseStr =  StringReplace($parseStr, "'", '')
$parseStr =  StringReplace($parseStr, "<br />", "")
$parseStr =  StringReplace($parseStr, "<i>", "")
$parseStr =  StringReplace($parseStr, "</i>", "")
$parseStr =  StringReplace($parseStr, "&quot;", '\"')
$parseStr =  StringReplace($parseStr, "&eacute;", "�")
$parseStr =  StringReplace($parseStr, "&euml;", "�")
$parseStr =  StringReplace($parseStr, "&auml;", "�")
$parseStr =  StringReplace($parseStr, "ō", "o")
$parseStr =  StringReplace($parseStr, "&amp;", "&")
$parseStr =  StringReplace($parseStr, "&rsquo;", "")
$parseStr =  StringReplace($parseStr, "&#039;", "")
$parseStr =  StringReplace($parseStr, "&#x27;", "")
$parseStr =  StringReplace($parseStr, "&mdash;", "-")
$szText1 = @CRLF & $CSS
$szText1 = StringReplace($szText1, "[ID]", $szID)
$szText1 = StringReplace($szText1, "[DESC]", $parseStr)
FileWrite($szFile2, $szText1)
EndFunc   ;==>_ParseHTML

Func Parse($sTemp,$key)
$res = StringRegExp($sTemp, '\W' & $key & '\W+(\d+)\W+\W+([^"]+)', 3)
Global $array[UBound($res)/2][2]
For $i = 0 to UBound($res)-1
   If Mod($i, 2) = 0 Then
       $array[$i/2][0] = $res[$i]
   Else
       $array[($i-1)/2][1] = $res[$i]
EndIf
Next
;_ArrayDisplay($array)
EndFunc   ;==>Parse

Func _getData($o,$list)
While $data = ""
	$Username = GUICtrlRead($UsernameINP)
	$URL = "https://myanimelist.net/" & $list & "list/" & $Username & "/load.json?status=7&offset=" & $o
	Sleep(5000)
	$data = _INetGetSource($URL)
	ConsoleWrite("data = " & $data & @CRLF)
WEnd
EndFunc   ;==>getData

Func _ScrapeMAL($list)
GUICtrlSetData($OutputINP, "")
ToolTip("Scanning from " & $sValue1 & " to " & $sValue2, $x, $y)
Sleep (2000)
While $sValue1 <= $sValue2
	$szID = $sValue1
	GUICtrlSetData($Progress, $sValue1 & " of " & $sValue2)
	$szURL = "https://myanimelist.net/" & $list & "/" & $szID
	ToolTip($szID & " Scanned.", $x, $y)
	Sleep(GUICtrlRead($DelayINP))
    $source = _INetGetSource($szURL)
    FileDelete($szFile3)
	FileWrite(@ScriptDir & "\" & $szFile3, $source)
    Local $read = FileRead(@ScriptDir & "\" & $szFile3)
	If $list = "anime" then
	    Local $readtitle = _StringBetween($read, '<p itemprop="description">', '</p>')
    If IsArray($readtitle) Then
		_FileWriteFromArray(@ScriptDir & '\' & $szFile1, $readtitle)
		_ParseHTML($szID)
    Else
		Local $readtitle = _StringBetween($read, 'Synopsis</h2></div>', '<')
		If IsArray($readtitle) Then
			_FileWriteFromArray(@ScriptDir & '\' & $szFile1, $readtitle)
			_ParseHTML($szID)
		EndIf
    EndIf
	ElseIf $list = "manga" then
    Local $readtitle = _StringBetween($read, '<span itemprop="description">', '</span>') ;read URL and title from file
    If IsArray($readtitle) Then
		_FileWriteFromArray(@ScriptDir & '\' & $szFile1, $readtitle)
		_ParseHTML($szID)
    Else
		Local $readtitle = _StringBetween($read, '</div>Synopsis</h2>', '<') ;read URL and title from file
		If IsArray($readtitle) Then
			_FileWriteFromArray(@ScriptDir & '\' & $szFile1, $readtitle)
			_ParseHTML($szID)
		EndIf
    EndIf
	EndIf
	Local $read2 = FileRead(@ScriptDir & "\" & $szFile2)
	GUICtrlSetData($OutputINP, $read2)
	$sValue1 = $sValue1 + 1
WEnd
EndFunc   ;==>_ScrapeMAL

Func _ScrapeloadjsonMAL($id,$list)
	$szURL = "https://myanimelist.net/" & $list & "/" & $id
	ToolTip($id & " Scanned.", $x, $y)
	Sleep(GUICtrlRead($DelayINP))
    $source = _INetGetSource($szURL)
	; check if source is spam triggered
    FileDelete($szFile3)
	FileWrite(@ScriptDir & "\" & $szFile3, $source)
    Local $read = FileRead(@ScriptDir & "\" & $szFile3)
	If $list = "anime" then
	Local $readtitle = _StringBetween($read, '<p itemprop="description">', '</p>')
    If IsArray($readtitle) Then
		_FileWriteFromArray(@ScriptDir & '\' & $szFile1, $readtitle)
		_ParseHTML($id)
    Else
		Local $readtitle = _StringBetween($read, 'Synopsis</h2></div>', '<')
		If IsArray($readtitle) Then
			_FileWriteFromArray(@ScriptDir & '\' & $szFile1, $readtitle)
			_ParseHTML($id)
		EndIf
    EndIf
	ElseIf $list = "manga" then
    Local $readtitle = _StringBetween($read, '<span itemprop="description">', '</span>') ;read URL and title from file
    If IsArray($readtitle) Then
		_FileWriteFromArray(@ScriptDir & '\' & $szFile1, $readtitle)
		_ParseHTML($id)
    Else
		Local $readtitle = _StringBetween($read, '</div>Synopsis</h2>', '<') ;read URL and title from file
		If IsArray($readtitle) Then
			_FileWriteFromArray(@ScriptDir & '\' & $szFile1, $readtitle)
			_ParseHTML($id)
		EndIf
    EndIf
	EndIf
	Local $read2 = FileRead(@ScriptDir & "\" & $szFile2)
	GUICtrlSetData($OutputINP, $read2)
EndFunc   ;==>_ScrapeloadjsonMAL

Func _ScrapeloadjsonAnimeMAL()
				FileDelete($szFile2)
				$CSS = GUICtrlRead($TemplateINP)
				$szText = '/* Generated by MyAnimeList-JSON https://github.com/shaggyze/MyAnimeList-JSON' & @CRLF & 'Template=' & $CSS & '*/'
				FileWrite($szFile2, $szText)
				ToolTip("Scraping MAL data...", $x, $y)

_GetloadjsonAnimeMAL()
				FileDelete($szFile1)
				FileDelete($szFile3)
EndFunc   ;==>_ScrapeloadjsonAnimeMAL

Func _ScrapeloadjsonMangaMAL()
				FileDelete($szFile2)
				$CSS = GUICtrlRead($TemplateINP)
				$szText = '/* Generated by MyAnimeList-JSON https://github.com/shaggyze/MyAnimeList-JSON' & @CRLF & 'Template=' & $CSS & '*/'
				FileWrite($szFile2, $szText)
				ToolTip("Scraping MAL data...", $x, $y)

_GetloadjsonMangaMAL()
				FileDelete($szFile1)
				FileDelete($szFile3)
EndFunc   ;==>_ScrapeloadjsonMangaMAL

Func _GetloadjsonAnimeMAL()
Local $count
While 1
	$data = ""
	_getData($o,"anime")
	If $data = "[]" Then ExitLoop 1
	;GUICtrlSetData($OutputINP, $data)
	Parse($data,"anime_id")
	If Not IsArray($array) Then ExitLoop 1
	;_ArrayDisplay($array)
	For $gather = 0 to UBound($array)-1
$anime_id = $array[$gather][0]
If $anime_id  = "" Then ExitLoop 2

$anime_ids = $anime_ids & $anime_id & ","
$count=$count + 1
    If @error Then ExitLoop 2
	Next
	$o += 300
ConsoleWrite($count & " " & $o & @CRLF)
ConsoleWrite($anime_ids & @CRLF)
If @error Then ExitLoop 1
WEnd
Local $anime_ids_array = StringSplit($anime_ids,",")
For $scrape = 1 to UBound($anime_ids_array)-1
	GUICtrlSetData($Progress, $scrape-1 & " of " & UBound($anime_ids_array)-2)
	_ScrapeloadjsonMAL($anime_ids_array[$scrape],"anime")
Next
EndFunc   ;==>_GetloadjsonAnimeMAL

Func _GetloadjsonMangaMAL()
Local $count
While 1
	$data = ""
	_getData($o,"manga")
	If $data = "[]" Then ExitLoop 1
	;GUICtrlSetData($OutputINP, $data)
	Parse($data,"manga_id")
	If Not IsArray($array) Then ExitLoop 1
	;_ArrayDisplay($array)
	For $gather = 0 to UBound($array)-1
$manga_id = $array[$gather][0]
If $manga_id  = "" Then ExitLoop 2

$manga_ids = $manga_ids & $manga_id & ","
$count=$count + 1
    If @error Then ExitLoop 2
	Next
	$o += 300
ConsoleWrite($count & " " & $o & @CRLF)
ConsoleWrite($manga_ids & @CRLF)
If @error Then ExitLoop 1
WEnd
Local $manga_ids_array = StringSplit($manga_ids,",")
For $scrape = 1 to UBound($manga_ids_array)-1
	GUICtrlSetData($Progress, $scrape-1 & " of " & UBound($manga_ids_array)-2)
	_ScrapeloadjsonMAL($manga_ids_array[$scrape],"manga")
Next
EndFunc   ;==>_GetloadjsonMangaMAL