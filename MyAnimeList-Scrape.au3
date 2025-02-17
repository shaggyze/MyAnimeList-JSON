;MyAnimeList-Scrape by ShaggyZE
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=mal.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Comment=MyAnimeList-Scrape
#AutoIt3Wrapper_Res_Description=MyAnimeList-Scrape
#AutoIt3Wrapper_Res_Fileversion=0.0.0.26
#AutoIt3Wrapper_Res_LegalCopyright=ShaggyZE
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#region Includes
#include-once
#include <AutoItConstants.au3>
#include <Inet.au3>
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
Global $szText, $szText, $szText1 = "", $szURL, $source, $sValue1, $sValue2, $szDelay, $Username, $Template, $Method, $anime_id, $ids, $manga_id, $manga_ids, $id, $data, $read, $read2, $readtags[0], $parseStr
Global $parseStr2, $o, $mode, $sURL_Status, $latest_anime_id, $latest_manga_id, $image, $title, $titleeng, $titleraw, $sComboData = "", $Filtered = "False", $FilterText, $AllFilterText, $tag, $tags
Global $Total, $Loop, $n, $sec = @SEC, $aETTF
Global $oIE = _IECreateEmbedded()
Global $version = "0.0.0.26"
Local $hGUI = GUICreate("MyAnimeList-Scrape v" & $version & "                                                        To Pause or Close Click the MAL Icon in your System Tray at the Bottom Right", 900, 470, -1, -1, -1)
Local $hSysMenu = _GUICtrlMenu_GetSystemMenu($hGUI)
_GUICtrlMenu_DeleteMenu($hSysMenu, $SC_CLOSE, False)
_GUICtrlMenu_DeleteMenu($hSysMenu, $SC_MAXIMIZE, False)
GUISetIcon("mal.ico")
$REGKEY="HKEY_CURRENT_USER\Software\ShaggyZE\MyAnimeList-Scrape\"
$Username=REGREAD($REGKEY,"Username")
$Template=REGREAD($REGKEY,"Template")
;GUI Frontend
$ButtonS = GUICtrlCreateButton("Start", 5, 5, 65, 20)
GUICtrlSetTip(-1, "Click to Start/Stop")
$UsernameINP = GUICtrlCreateInput($Username, 80, 5, 100, 20)
GUICtrlSetState (-1,$GUI_Disable)
GUICtrlSetTip(-1, "Your MAL Username")
GUICtrlCreateLabel("Output", 225, 10, 65, 20)
GUICtrlSetTip(-1, "This is where your CSS code will be")
$Progress = GUICtrlCreateLabel("", 5, 40, 215, 20, $SS_CENTER, $WS_EX_TOPMOST)
GUICtrlSetTip(-1, "")
GUICtrlCreateLabel("Delay", 5, 60, 65, 20)
GUICtrlSetTip(-1, "Milliseconds between Scraping MyAnimeList.net")
$DelayINP = GUICtrlCreateInput("3000", 5, 80, 40, 20)
GUICtrlSetTip(-1, "Milliseconds between Scraping MyAnimeList.net")
$OutputCHK = GUICtrlCreateCheckbox("Halt Output UI", 80, 80, 100, 20)
GUICtrlSetTip(-1, "Output only to mal.css")
GUICtrlCreateLabel("Template", 5, 110, 65, 20)
GUICtrlSetTip(-1, "CSS Template")
$TemplateINP = GUICtrlCreateInput($Template, 5, 130, 220, 20)
GUICtrlSetTip(-1, "CSS Template")
GUICtrlCreateLabel("Method", 5, 160, 65, 20)
GUICtrlSetTip(-1, "Method of scraping Data for CSS")
$MethodCMB = GUICtrlCreateCombo("MAL-Anime", 5, 180, 150, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
GUICtrlSetData(-1, "MAL-Manga|User-Anime|User-Manga")
GUICtrlSetTip(-1, "Method of scraping Data for CSS")
GUICtrlCreateLabel("Start and Finish", 5, 210, 80, 20)
GUICtrlSetTip(-1, "ID# from Start to Finsh")
$FromINP = GUICtrlCreateInput("1", 5, 230, 40, 20)
GUICtrlSetTip(-1, "Start ID#")
$ToINP = GUICtrlCreateInput("", 45, 230, 40, 20)
GUICtrlSetTip(-1, "Finish ID#")
GUICtrlCreateLabel("Filter", 90, 210, 100, 20)
GUICtrlSetTip(-1, "Filter output CSS")
$ButtonAdd = GUICtrlCreateButton("Add", 90, 230, 30, 20)
GUICtrlSetTip(-1, "Add filter to list")
$FilterINP = GUICtrlCreateInput("", 120, 230, 40, 20)
GUICtrlSetTip(-1, "Filter to be added (case-sensitive)")
$FilterCMB = GUICtrlCreateCombo("", 165, 230, 60, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
GUICtrlSetTip(-1, "List of filters")
$OutputINP = GUICtrlCreateEdit("Newly generated code will be output here.", 225, 25, 675, 445, $ES_MULTILINE)
GUICtrlSetStyle($OutputINP, $WS_VSCROLL)
;_GUICtrlEdit_SetReadOnly(ControlGetHandle($hGUI,"",$OutputINP),True)
GUICtrlSetTip(-1, "Newly generated code will be output here")
$AntiSpamCHK = GUICtrlCreateCheckbox("Show Anti-Spam", 5, 260, 95, 20)
GUICtrlSetTip(-1, "Anti-Spam")
$GUIActiveX = GUICtrlCreateObj($oIE, 12.5, 280, 200, 180)
GUICtrlSetState($GUIActiveX, $GUI_HIDE)
$szFile1 = "scrape.txt"
$szFile2 = "mal.txt"
$szFile3 = "scrape.html"
$szFile4 = "jikan.html"
$szFile5 = "jikan.txt"
$x = @DesktopWidth - 200
$y = @DesktopHeight - 62.5
GUISetState(@SW_SHOW, $hGUI)
FileWrite($szFile4, "null")
_GetLastestID("anime")

GUIRegisterMsg($WM_COMMAND, "_MY_WM_COMMAND")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		;Start
		Case $ButtonS

			If GUICtrlRead($ButtonS) = "Start" Then
            GUICtrlSetData($ButtonS, "Stop (close)")
			$Method = GUICtrlRead($MethodCMB)
			$Username = GUICtrlRead($UsernameINP)
			$Template = GUICtrlRead($TemplateINP)
			If $Username = "" Then
				$Username = "ShaggyZE"
				GUICtrlSetData($UsernameINP, $Username)
				REGWRITE($REGKEY,"Username","REG_SZ",GUICtrlRead($UsernameINP))
			EndIf
			If $Template = "" Then
				$Template = "#tags-[ID]:after {font-family: Finger Paint; content: '[DESC]';}"
				GUICtrlSetData($TemplateINP, $Template)
				REGWRITE($REGKEY,"Template","REG_SZ",GUICtrlRead($TemplateINP))
			EndIf
			If $Method = "MAL-Anime" Then
				$sValue1 = GUICtrlRead($FromINP)
				$sValue2 = GUICtrlRead($ToINP)
				If $sValue1 = "" Then $sValue1 = "1" And GUICtrlSetData($FromINP, 1)
				If $sValue2 = "" Then _GetLastestID("anime")
				FileDelete($szFile2)
				$Template = GUICtrlRead($TemplateINP)
				_GetAllFilterText()
				$szText = '/* Generated by MyAnimeList-Scrape https://github.com/shaggyze/MyAnimeList-Scrape' & @CRLF & 'Template=' & $Template & @CRLF & 'Filter=' & $AllFilterText & @CRLF & '*/'
				FileWrite($szFile2, $szText)
				ToolTip("Scraping MAL data...", $x, $y)
				Sleep(GUICtrlRead($DelayINP))
				_ScrapeMAL("anime")
				FileDelete($szFile1)
				FileDelete($szFile3)
			ElseIf $Method = "MAL-Manga" Then
				$sValue1 = GUICtrlRead($FromINP)
				$sValue2 = GUICtrlRead($ToINP)
				If $sValue1 = "" Then $sValue1 = "1" And GUICtrlSetData($FromINP, 1)
				If $sValue2 = "" Then _GetLastestID("manga")
				FileDelete($szFile2)
				$Template = GUICtrlRead($TemplateINP)
				_GetAllFilterText()
				$szText = '/* Generated by MyAnimeList-Scrape https://github.com/shaggyze/MyAnimeList-Scrape' & @CRLF & 'Template=' & $Template & @CRLF & 'Filter=' & $AllFilterText & @CRLF & '*/'
				FileWrite($szFile2, $szText)
				ToolTip("Scraping MAL data...", $x, $y)
				Sleep(GUICtrlRead($DelayINP))
				_ScrapeMAL("manga")
				FileDelete($szFile1)
				FileDelete($szFile3)
			ElseIf $Method = "User-Anime" Then
				$data = ""
				$o = 0
				FileDelete($szFile2)
				$Template = GUICtrlRead($TemplateINP)
				_GetAllFilterText()
				$szText = '/* Generated by MyAnimeList-Scrape https://github.com/shaggyze/MyAnimeList-Scrape' & @CRLF & 'Template=' & $Template & @CRLF & 'Filter=' & $AllFilterText & @CRLF & '*/'
				FileWrite($szFile2, $szText)
				GUICtrlSetData($OutputINP, "Gathering IDs...This may take awhile depending on the size of the list.")
				ToolTip("Gathering IDs...", $x, $y)
				_GetJSON("anime")
				ToolTip("", $x, $y)
				$mode = ""
				FileDelete($szFile1)
				FileDelete($szFile3)
			ElseIf $Method = "User-Manga" Then
				$data = ""
				$o = 0
				FileDelete($szFile2)
				$Template = GUICtrlRead($TemplateINP)
				_GetAllFilterText()
				$szText = '/* Generated by MyAnimeList-Scrape https://github.com/shaggyze/MyAnimeList-Scrape' & @CRLF & 'Template=' & $Template & @CRLF & 'Filter=' & $AllFilterText & @CRLF & '*/'
				FileWrite($szFile2, $szText)
				GUICtrlSetData($OutputINP, "Gathering IDs...This may take awhile depending on the size of the list.")
				ToolTip("Gathering IDs...", $x, $y)
				_GetJSON("manga")
				ToolTip("", $x, $y)
				$mode = ""
				FileDelete($szFile1)
				FileDelete($szFile3)
			EndIf
			EndIf
		Case $ButtonAdd
			$sComboSel = GUICtrlRead($FilterCMB)
			$sComboData = GUICtrlRead($FilterINP)
			If Not $sComboData = "" Then
				If Not StringIsSpace($sComboData) Then
					If Not StringInStr($sComboSel, "|" & $sComboData) Then
						$sComboSel &= "|" & $sComboData
						GUICtrlSetData($FilterCMB, $sComboData)
						_GUICtrlComboBox_SetCurSel($FilterCMB, _GUICtrlComboBox_GetCount($FilterCMB)-1)
						GUICtrlSetData($FilterINP, "")
					EndIf
				EndIf
			EndIf
		Case $MethodCMB
			$Method = GUICtrlRead($MethodCMB)
			If $Method = "MAL-Anime" Then
				_GetLastestID("anime")
				GUICtrlSetState ($UsernameINP,$GUI_Disable)
				GUICtrlSetState ($FromINP,$GUI_Enable)
				GUICtrlSetState ($ToINP,$GUI_Enable)
			ElseIf $Method = "MAL-Manga" Then
				_GetLastestID("manga")
				GUICtrlSetState ($UsernameINP,$GUI_Disable)
				GUICtrlSetState ($FromINP,$GUI_Enable)
				GUICtrlSetState ($ToINP,$GUI_Enable)
			ElseIf $Method = "User-Anime" Then
				GUICtrlSetState ($UsernameINP,$GUI_Enable)
				GUICtrlSetState ($FromINP,$GUI_Disable)
				GUICtrlSetState ($ToINP,$GUI_Disable)
			ElseIf $Method = "User-Manga" Then
				GUICtrlSetState ($UsernameINP,$GUI_Enable)
				GUICtrlSetState ($FromINP,$GUI_Disable)
				GUICtrlSetState ($ToINP,$GUI_Disable)
			EndIf
		Case $AntiSpamCHK
			If GUICtrlRead($AntiSpamCHK) = 1 Then
				GUICtrlSetState($GUIActiveX, $GUI_SHOW)
			Else
				GUICtrlSetState($GUIActiveX, $GUI_HIDE)
			EndIf
		Case Else
			REGWRITE($REGKEY,"Username","REG_SZ",GUICtrlRead($UsernameINP))
			REGWRITE($REGKEY,"Template","REG_SZ",GUICtrlRead($TemplateINP))
			;MsgBox(0,"",$nMsg)
	EndSwitch
WEnd

Func _GetAllFilterText()
If _GUICtrlComboBox_GetCount($FilterCMB) >= 1 Then
	For $FilterLoop = 0 to _GUICtrlComboBox_GetCount($FilterCMB)-1
		_GUICtrlComboBoxEx_GetItemText($FilterCMB,$FilterLoop,$FilterText)
		If $FilterLoop = _GUICtrlComboBox_GetCount($FilterCMB)-1 Then
			$AllFilterText &= $FilterText
		Else
			$AllFilterText &= $FilterText & ","
		EndIf
	Next
EndIf
EndFunc   ;==>_GetAllFilterText

Func _GetLastestID($list)
If $list = "anime" Then
	$szURL = "https://myanimelist.net/anime.php?o=9&c%5B0%5D=a&c%5B1%5D=d&cv=2&w=1"
Else
	$szURL = "https://myanimelist.net/manga.php?o=9&c%5B0%5D=a&c%5B1%5D=d&cv=2"
EndIf
$source = _INetGetSource($szURL)
FileDelete($szFile3)
FileWrite($szFile3, $source)
$read = FileRead($szFile3)
$readtags = _StringBetween($read, '<div id="sarea', '">')
If IsArray($readtags) Then
	If $readtags[0] = "" Then $readtags[0] = "1"
	$sValue2 = $readtags[0]
	GUICtrlSetData($ToINP, $readtags[0])
Else
	MsgBox(0,"Error","Failed to get latest " & $list & " ID#" & @CRLF & "Check if you are online and MAL is working.")
	If $list = "anime" Then
		GUICtrlSetData($ToINP, "60000")
	Else
		GUICtrlSetData($ToINP, "150000")
	EndIf
	ShellExecute ($szURL)
EndIf
EndFunc   ;==>_GetLastestID

Func _REGCHK()
If $Username = "" Then
	$Username = "ShaggyZE"
	GUICtrlSetData($UsernameINP, $Username)
	REGWRITE($REGKEY,"Username","REG_SZ",GUICtrlRead($UsernameINP))
EndIf
If $Template = "" Then
	$Template = "#tags-[ID]:after {font-family: Finger Paint; content: '[DESC]';}"
	GUICtrlSetData($TemplateINP, $Template)
	REGWRITE($REGKEY,"Template","REG_SZ",GUICtrlRead($TemplateINP))
EndIf
EndFunc   ;==>_REGCHK

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

Func Parse1($sTemp,$key)
$res = StringRegExp($sTemp, '\W' & $key & '\W+([^"]+)', 3)
Global $array1[UBound($res)][1]
For $i = 0 to UBound($res)-1
	$array1[$i][0] = $res[$i]
Next
;_ArrayDisplay($array1)
EndFunc   ;==>Parse

Func _getData($o,$list)
While $data = ""
	$Username = GUICtrlRead($UsernameINP)
	$URL = "https://myanimelist.net/" & $list & "list/" & $Username & "/load.json?status=7&offset=" & $o
	Sleep(GUICtrlRead($DelayINP))
	$data = _INetGetSource($URL)
	ConsoleWrite("data = " & $data & @CRLF)
WEnd
EndFunc   ;==>getData

Func _ScrapeMAL($list)
GUICtrlSetData($OutputINP, "")
_BeginTime()
$Total = Number($sValue2) - Number($sValue1)
While Number($sValue1) <= Number($sValue2)
_CurrentTime()
	$id = $sValue1
	GUICtrlSetData($Progress, $sValue1 & " of " & $sValue2 & " - " & $aETTF[1])
	$szURL = "https://myanimelist.net/" & $list & "/" & $id
    _CheckURLStatus()
	If $sValue1 = $sValue2 Then
			GUICtrlSetState($OutputCHK, 4)
			GUICtrlSetData($ButtonS, "Done (close)")
	EndIf
	If $sURL_Status = "200" Then
		ToolTip($sValue1 & " of " & $sValue2 & " - " & $aETTF[1], $x, $y)
		Sleep(GUICtrlRead($DelayINP))
		$source = _INetGetSource($szURL)
		FileDelete($szFile3)
		FileWrite($szFile3, $source)
		If Not StringInStr($Template,"[IMGURL]") = 0 Or Not StringInStr($Template,"[TITLE2]") = 0 Or Not StringInStr($Template,"[TITLEENG]") = 0 Or Not StringInStr($Template,"[TITLERAW]") = 0 Then
			$source2 = _INetGetSource("https://api.jikan.moe/v3/" & $list & "/" & $id)
			FileDelete($szFile4)
			FileWrite($szFile4, $source2)
			Sleep(2000)
		EndIf
		While FileGetSize($szFile4) = 0
			If Not StringInStr($Template,"[IMGURL]") = 0 Or Not StringInStr($Template,"[TITLE2]") = 0 Or Not StringInStr($Template,"[TITLEENG]") = 0 Or Not StringInStr($Template,"[TITLERAW]") = 0 Then
				Sleep (6000)
				$source2 = _INetGetSource("https://api.jikan.moe/v3/" & $list & "/" & $id)
				FileDelete($szFile4)
				FileWrite($szFile4, $source2)
			EndIf
		WEnd
		$read = FileRead($szFile3)
		$szText1 = @CRLF & $Template
		If Not StringInStr($Template,"[IMGURL]") = 0 Then $image = _GetJIKAN('"image_url":"', '",', $list, $id)
		If Not StringInStr($Template,"[TITLE2]") = 0 Then $title = _GetJIKAN('"title":"', '",', $list, $id)
		If Not StringInStr($Template,"[TITLEENG]") = 0 Then $titleeng = _GetJIKAN('"title_english":"', '",', $list, $id)
		If Not StringInStr($Template,"[TITLERAW]") = 0 Then $titleraw = _GetJIKAN('"title_japanese":"', '",', $list, $id)
		$titleraw = Execute("'" & StringRegExpReplace($titleraw, "(\\u([[:xdigit:]]{4}))","' & ChrW(0x$2) & '") & "'")
		For $tagsIndex = 1 to IniRead("maltags.ini","tags","count","")
			$readtags = _StringBetween($read, IniRead("maltags.ini",$tagsIndex,"before",""), IniRead("maltags.ini",$tagsIndex,"after",""))
			If IsArray($readtags) Then
				_FileWriteFromArray($szFile1, $readtags)
				$parseStr =  FileRead($szFile1,FileGetSize($szFile1))
				If $parseStr = "" Then ExitLoop
				_ParseHTML($id)
				$szText1 = StringReplace($szText1, "[DEL]", "")
				$szText1 = StringReplace($szText1, "[ID]", $id)
				$szText1 = StringReplace($szText1, "[TYPE]", $list)
				$szText1 = StringReplace($szText1, "[TITLE2]", $title)
				$szText1 = StringReplace($szText1, "[TITLEENG]", $titleeng)
				$szText1 = StringReplace($szText1, "[TITLERAW]", $titleraw)
				$szText1 = StringReplace($szText1, "[IMGURL]", $image)
				$szText1 = StringReplace($szText1, "[" & IniRead("maltags.ini",$tagsIndex,"name","") & "]", $parseStr)
			EndIf
		Next
		For $tagsIndex = 1 to IniRead("maltags.ini","tags","count","")
			$szText1 = StringReplace($szText1, "[" & IniRead("maltags.ini",$tagsIndex,"name","") & "]", IniRead("maltags.ini",$tagsIndex,"notfound",""))
		Next
		_FormatTEXT()
		If _GUICtrlComboBox_GetCount($FilterCMB) >= 1 Then
			For $FilterLoop = 0 to _GUICtrlComboBox_GetCount($FilterCMB)-1
				_GUICtrlComboBoxEx_GetItemText($FilterCMB,$FilterLoop,$FilterText)
				If StringInStr($szText1,$FilterText,1) Then $Filtered="True"
			Next
			If $Filtered="True" Then FileWrite($szFile2, $szText1)
		Else
			FileWrite($szFile2, $szText1)
		EndIf
		$Filtered="False"
	ElseIf $sURL_Status = "500" Then
		$sValue1 = $sValue1 - 1
		;MsgBox($MB_OK + $MB_ICONINFORMATION, 'SUCCESS', '$sURL_Status=' & $sURL_Status)
	EndIf
	$read2 = FileRead($szFile2)
	If GUICtrlRead($OutputCHK) = 4 Then GUICtrlSetData($OutputINP, $read2)
	If Not $sURL_Status = "" Then $sValue1 = $sValue1 + 1
WEnd
_EndTime()
ToolTip("", $x, $y)
EndFunc   ;==>_ScrapeMAL

Func _ScrapeJSON($id, $list, $tag)
Sleep(GUICtrlRead($DelayINP))
$source = _INetGetSource($szURL)
FileDelete($szFile3)
FileWrite($szFile3, $source)
If Not StringInStr($Template,"[IMGURL]") = 0 Or Not StringInStr($Template,"[TITLE2]") = 0 Or Not StringInStr($Template,"[TITLEENG]") = 0 Or Not StringInStr($Template,"[TITLERAW]") = 0 Then
$source2 = _INetGetSource("https://api.jikan.moe/v3/" & $list & "/" & $id)
FileDelete($szFile4)
FileWrite($szFile4, $source2)
Sleep(2000)
EndIf
While FileGetSize($szFile4) = 0
If Not StringInStr($Template,"[IMGURL]") = 0 Or Not StringInStr($Template,"[TITLE2]") = 0 Or Not StringInStr($Template,"[TITLEENG]") = 0 Or Not StringInStr($Template,"[TITLERAW]") = 0 Then
Sleep (6000)
$source2 = _INetGetSource("https://api.jikan.moe/v3/" & $list & "/" & $id)
FileDelete($szFile4)
FileWrite($szFile4, $source2)
EndIf
WEnd
$read = FileRead($szFile3)
$szText1 = @CRLF & $Template
If Not StringInStr($Template,"[IMGURL]") = 0 Then $image = _GetJIKAN('"image_url":"', '",', $list, $id)
If Not StringInStr($Template,"[TITLE2]") = 0 Then $title = _GetJIKAN('"title":"', '",', $list, $id)
If Not StringInStr($Template,"[TITLEENG]") = 0 Then $titleeng = _GetJIKAN('"title_english":"', '",', $list, $id)
If Not StringInStr($Template,"[TITLERAW]") = 0 Then $titleraw = _GetJIKAN('"title_japanese":"', '",', $list, $id)
$titleraw = Execute("'" & StringRegExpReplace($titleraw, "(\\u([[:xdigit:]]{4}))","' & ChrW(0x$2) & '") & "'")
For $tagsIndex = 1 to IniRead("maltags.ini","tags","count","")
$readtags = _StringBetween($read, IniRead("maltags.ini",$tagsIndex,"before",""), IniRead("maltags.ini",$tagsIndex,"after",""))
If IsArray($readtags) Then
	_FileWriteFromArray($szFile1, $readtags)
	$parseStr =  FileRead($szFile1,FileGetSize($szFile1))
	If $parseStr = "" Then ExitLoop
	_ParseHTML($id)
	$szText1 = StringReplace($szText1, "[DEL]", "")
	$szText1 = StringReplace($szText1, "[ID]", $id)
	$szText1 = StringReplace($szText1, "[TYPE]", $list)
	$szText1 = StringReplace($szText1, "[TITLE2]", $title)
	$szText1 = StringReplace($szText1, "[TITLEENG]", $titleeng)
	$szText1 = StringReplace($szText1, "[TITLERAW]", $titleraw)
	$szText1 = StringReplace($szText1, "[IMGURL]", $image)
	$tag = StringReplace($tag, "is_rewatching", "")
	$tag = StringReplace($tag, "is_rereading", "")
	$tag = StringReplace($tag, "\", "")
	$tag = StringReplace($tag, "'", "\'")
	$szText1 = StringReplace($szText1, "[TAGS]", $tag)
	$szText1 = StringReplace($szText1, "[" & IniRead("maltags.ini",$tagsIndex,"name","") & "]", $parseStr)
EndIf
Next
For $tagsIndex = 1 to IniRead("maltags.ini","tags","count","")
	$szText1 = StringReplace($szText1, "[" & IniRead("maltags.ini",$tagsIndex,"name","") & "]", IniRead("maltags.ini",$tagsIndex,"notfound",""))
Next
_FormatTEXT()
If _GUICtrlComboBox_GetCount($FilterCMB) >= 1 Then
	For $FilterLoop = 0 to _GUICtrlComboBox_GetCount($FilterCMB)-1
		_GUICtrlComboBoxEx_GetItemText($FilterCMB,$FilterLoop,$FilterText)
		If StringInStr($szText1,$FilterText,1) Then $Filtered="True"
	Next
	If $Filtered="True" Then FileWrite($szFile2, $szText1)
Else
	FileWrite($szFile2, $szText1)
EndIf
$Filtered="False"
$read2 = FileRead($szFile2)
If GUICtrlRead($OutputCHK) = 4 Then GUICtrlSetData($OutputINP, $read2)
EndFunc   ;==>_ScrapeJSON

Func _GetJSON($list)
Local $count = 0
Do
	$data = ""
	_getData($o,$list)
	If Not $mode = "" Or $data = "[]" Then _BuildCSS($list)
	;GUICtrlSetData($OutputINP, $data)


	Parse($data,$list & "_id")
	Parse1($data,"tags")
	If Not IsArray($array) Then ExitLoop 1
	;_ArrayDisplay($array1)
	For $gather = 0 to UBound($array) - 1
		$id = $array[$gather][0]
		$tag = $array1[$gather][0]
		If $id  = "" Then ExitLoop 2
		If $count = 0 Then
			$ids = $id
			$tags = $tag
		Else
			$ids = $ids & "," & $id
			$tags = $tags & ";" & $tag
		EndIf
		$count += 1
		If @error Then ExitLoop 2
	Next

	$o += 300
	ToolTip("Gathering IDs " & $o, $x, $y)
	If @error Then ExitLoop 1
Until $data = "[]"
EndFunc   ;==>_GetJSON

Func _BuildCSS($list)
$mode = "building"
_BeginTime()
If $list = "anime" Then
	Local $anime_ids_array = StringSplit($ids,",")
	Local $tags_array = StringSplit($tags,";")
	$Total = UBound($anime_ids_array)
	For $scrape = 1 to $Total - 1
		GUICtrlSetData($Progress, $scrape & " of " & ($Total - 1) & " - " & $aETTF[1])
		ToolTip($scrape & " of " & ($Total - 1) & " - " & $aETTF[1], $x, $y)
		_CurrentTime()
		If $scrape = $Total - 2 Then GUICtrlSetState($OutputCHK, 4)
		$szURL = "https://myanimelist.net/anime/" & $anime_ids_array[$scrape]
		_CheckURLStatus()
		If $sURL_Status = "200" Then
			_ScrapeJSON($anime_ids_array[$scrape],"anime",$tags_array[$scrape])
		Else
			$scrape = $scrape - 1
		EndIf
	Next
	If $scrape = $Total Then
		$mode = ""
		_EndTime()
		GUICtrlSetData($ButtonS, "Done (close)")
	EndIf
ElseIf $list = "manga" Then
	Local $manga_ids_array = StringSplit($ids,",")
	Local $tags_array = StringSplit($tags,";")
	$Total = UBound($manga_ids_array)
	For $scrape = 1 to $Total - 1
		GUICtrlSetData($Progress, $scrape & " of " & ($Total - 1) & " - " & $aETTF[1])
		ToolTip($scrape & " of " & ($Total - 1) & " - " & $aETTF[1], $x, $y)
		_CurrentTime()
		If $scrape = $Total - 2 Then GUICtrlSetState($OutputCHK, 4)
		$szURL = "https://myanimelist.net/manga/" & $manga_ids_array[$scrape]
		_CheckURLStatus()
		If $sURL_Status = "200" Then
			_ScrapeJSON($manga_ids_array[$scrape],"manga",$tags_array[$scrape])
		Else
			$scrape = $scrape - 1
		EndIf
	Next
	If $scrape = $Total Then
		$mode = ""
		_EndTime()
		GUICtrlSetData($ButtonS, "Done (close)")
	EndIf
EndIf
EndFunc   ;==>_BuildCSS

Func _GetJIKAN($before, $after, $list, $id)
$read2 = FileRead($szFile4)
$readtags2 = _StringBetween($read2, $before, $after)
If IsArray($readtags2) Then
_FileWriteFromArray($szFile5, $readtags2)
$parseStr2 = FileRead($szFile5,FileGetSize($szFile5))
$parseStr2 =  StringReplace($parseStr2, @LF, "")
$parseStr2 =  StringReplace($parseStr2, @CR, "")
$parseStr2 =  StringReplace($parseStr2, @CRLF, "")
$parseStr2 =  StringReplace($parseStr2, "\/", "/")
ElseIf $readtags2 = "null" Then
	If $before = '"title":"' Then Exit
	If $before = '"title_english":"' Then $parseStr2 = "N/A"
	If $before = '"title_japanese":"' Then $parseStr2 = "N/A"
EndIf
Return $parseStr2
EndFunc   ;==>_BuildCSS

Func _CheckURLStatus()
$sURL_Status = _ULRNotifier(_URL_CheckStatus($szURL))
;MsgBox($MB_OK + $MB_ICONINFORMATION, 'SUCCESS', '$sURL_Status=' & $sURL_Status)
If $sURL_Status = "403" Then
	;ShellExecute($szURL)
	While $sURL_Status = "403"
		_IENavigate($oIE, $szURL)
		_IELoadWait($oIE, 5000, 10000)
		$oLinks = _IETagNameGetCollection($oIE, "button")
		For $oLink In $oLinks
		If String($oLink.type) = "submit" Then
		  _IEAction($oLink, "click")
          ExitLoop
		EndIf
		Next
		_IELoadWait($oIE, 5000, 10000)
		Sleep (20000)
		$sURL_Status = _ULRNotifier(_URL_CheckStatus($szURL))
	WEnd
ElseIf $sURL_Status = "500" Then
	ShellExecute($szURL)
	Sleep (20000)
	;MsgBox($MB_OK + $MB_ICONINFORMATION, 'FAILED', '$sURL_Status=' & $sURL_Status)
EndIf
EndFunc

Func _URL_CheckStatus($sURL)
    _URLChecker_COMErrDescripion("")
    Local $oErrorHandler = ObjEvent("AutoIt.Error", "_URLChecker_COMErrFunc")
    #forceref $oErrorHandler

    Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")

    $oHTTP.Open("HEAD", $sURL, False)
    If @error Then Return SetError(1, @error, '')

    $oHTTP.Send()
    Local $iError = @error

    Local $sStatus = $oHTTP.Status
    If @error Then Return SetError(3, @error, $sStatus)

    If $iError Then Return SetError(2, $iError, $sStatus)

    Return $sStatus
EndFunc   ;==>_URL_CheckStatus

Func _URLChecker_COMErrFunc($oError)
    _URLChecker_COMErrDescripion($oError.description)

    Return ; you can comment/dlete this return to show full error descripition

    ConsoleWrite(@ScriptName & " (" & $oError.scriptline & ") : ==> COM Error intercepted !" & @CRLF & _
            @TAB & "$oError.number is: " & @TAB & @TAB & "0x" & Hex($oError.number) & @CRLF & _
            @TAB & "$oError.windescription:" & @TAB & $oError.windescription & @CRLF & _
            @TAB & "$oError.description is: " & @TAB & $oError.description & @CRLF & _
            @TAB & "$oError.source is: " & @TAB & @TAB & $oError.source & @CRLF & _
            @TAB & "$oError.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
            @TAB & "$oError.helpcontext is: " & @TAB & $oError.helpcontext & @CRLF & _
            @TAB & "$oError.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
            @TAB & "$oError.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
            @TAB & "$oError.retcode is: " & @TAB & "0x" & Hex($oError.retcode) & @CRLF & @CRLF)
EndFunc   ;==>_URLChecker_COMErrFunc

Func _URLChecker_COMErrDescripion($sDescription = Default)
    Local Static $sDescription_static = ''
    If $sDescription <> Default Then $sDescription_static = $sDescription
    Return $sDescription_static
EndFunc   ;==>_URLChecker_COMErrDescripion

Func _ULRNotifier($vResult, $iError = @error, $iExtended = @extended)
    If $iError Then ConsoleWrite( _
            "! @error = " & $iError & "  @extended = " & $iExtended & " $vResult = " & $vResult & @CRLF & _
            "! " & _URLChecker_COMErrDescripion() & @CRLF _
            )
    Return SetError($iError, $iExtended, $vResult)
EndFunc   ;==>_ULRNotifier

 Func _MY_WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
	Local $iIDFrom = BitAND($wParam, 0xFFFF) ; LoWord - this gives the control which sent the message
	Local $iCode = BitShift($wParam, 16)     ; HiWord - this gives the message that was sent
	;MsgBox(0,"message",$iIDFrom & " " & $iCode)
		Switch $iIDFrom
		Case 3
			If GUICtrlRead($ButtonS) = "Stop (close)" or GUICtrlRead($ButtonS) = "Done (close)" Then
				$cMsg = MsgBox (4, "Closing" ,"Would you like to open " & $szFile2 & "?")
				If $cMsg = 6 Then
					ShellExecute($szFile2)
				EndIf
				Exit
			EndIf
		Case 18
			If GUICtrlRead($AntiSpamCHK) = 1 Then
				GUICtrlSetState($GUIActiveX, $GUI_SHOW)
			Else
				GUICtrlSetState($GUIActiveX, $GUI_HIDE)
			EndIf
	EndSwitch
 EndFunc   ;==>_MY_WM_COMMAND

 Func _ParseHTML($id)
$parseStr =  StringReplace($parseStr, @CRLF, " ")
$parseStr =  StringReplace($parseStr, @LF, "")
$parseStr =  StringReplace($parseStr, @CR, "")
$parseStr =  StringReplace($parseStr, ' - MyAnimeList.net ', "")
$parseStr =  StringReplace($parseStr, ' | Manga', "")
$parseStr =  StringReplace($parseStr, ' | Light Novel', "")
$parseStr =  StringReplace($parseStr, ' | Doujinshi', "")
$parseStr =  StringReplace($parseStr, '"', '')
$parseStr =  StringReplace($parseStr, "'", '')
$parseStr =  StringReplace($parseStr, "\u2019", "'")
$parseStr =  StringReplace($parseStr, "<br />", "")
$parseStr =  StringReplace($parseStr, "<i>", "")
$parseStr =  StringReplace($parseStr, "</i>", "")
$parseStr =  StringReplace($parseStr, "<b>", "")
$parseStr =  StringReplace($parseStr, "</b>", "")
$parseStr =  StringReplace($parseStr, "</a>", "")
$parseStr =  StringReplace($parseStr, "</span>", "")
$parseStr =  StringReplace($parseStr, "&quot;", '\"')
$parseStr =  StringReplace($parseStr, "&eacute;", "é")
$parseStr =  StringReplace($parseStr, "&euml;", "é")
$parseStr =  StringReplace($parseStr, "&auml;", "ä")
$parseStr =  StringReplace($parseStr, "Å", "o")
$parseStr =  StringReplace($parseStr, "â€•", "―")
$parseStr =  StringReplace($parseStr, "&amp;", "&")
$parseStr =  StringReplace($parseStr, "&rsquo;", "")
$parseStr =  StringReplace($parseStr, "&#039;", "")
$parseStr =  StringReplace($parseStr, "&#x27;", "")
$parseStr =  StringReplace($parseStr, "&mdash;", "-")
$parseStr =  StringReplace($parseStr, "<span style=font-size: 90%;>", " ")
$parseStr =  StringReplace($parseStr, "<span style=font-size: 90%;><b>", " ")
$parseStr =  StringReplace($parseStr, "</b></span>", "")
$parseStr =  StringReplace($parseStr, "/moreinfo>", " ")
$parseStr =  StringReplace($parseStr, "<!--link-->" & $id & "/", "")
$parseStr =  StringReplace($parseStr, " <a href=/dbchanges.php?aid=" & $id & "&t=synopsis>here.", "")
$parseStr =  StringReplace($parseStr, "<a href=http://myanimelist.net/manga/" & $id & "/-/moreinfo rel=nofollow>", "")
$parseStr =  StringReplace($parseStr, "<a href=http://myanimelist.net/anime/" & $id & "/-/moreinfo rel=nofollow>", "")
$parseStr =  StringReplace($parseStr, "<a href=https://myanimelist.net/manga/" & $id & "/-/moreinfo rel=nofollow>", "")
$parseStr =  StringReplace($parseStr, "<a href=https://myanimelist.net/anime/" & $id & "/-/moreinfo rel=nofollow>", "")
 EndFunc   ;==>_ParseHTML

Func _FormatTEXT()
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Action<a href=/anime/genre/1/Action title=Action>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Adventure<a href=/anime/genre/2/Adventure title=Adventure>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Comedy<a href=/anime/genre/4/Comedy title=Comedy>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Fantasy<a href=/anime/genre/10/Fantasy title=Fantasy>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Romance<a href=/anime/genre/22/Romance title=Romance>","")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Drama<a href=/anime/genre/8/Drama title=Drama>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Sci-Fi<a href=/anime/genre/24/Sci-Fi title=Sci-Fi>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Horror<a href=/anime/genre/14/Horror title=Horror>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Supernatural<a href=/anime/genre/37/Supernatural title=Supernatural>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Girls Love<a href=/anime/genre/26/Girls_Love title=Girls Love>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Slice of Life<a href=/anime/genre/36/Slice_of_Life title=Slice of Life>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Mystery<a href=/anime/genre/7/Mystery title=Mystery>", "")

$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Avant Garde<a href=/anime/genre/5/Avant_Garde title=Avant Garde>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Award Winning<a href=/anime/genre/46/Award_Winning title=Award Winning>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Boys Love<a href=/anime/genre/28/Boys_Love title=Boys Love>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Gourmet<a href=/anime/genre/47/Gourmet title=Gourmet>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Sports<a href=/anime/genre/30/Sports title=Sports>","")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Suspense<a href=/anime/genre/41/Suspense title=Suspense>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Work Life<a href=/anime/genre/48/Work_Life title=Work Life>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Ecchi<a href=/anime/genre/9/Ecchi title=Ecchi>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Erotica<a href=/anime/genre/49/Erotica title=Erotica>", "")
$szText1 = StringReplace($szText1, "<span itemprop=genre style=display: none>Hentai<a href=/anime/genre/12/Hentai title=Hentai>", "")

$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Action            <a href=/manga/genre/1/Action title=Action>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Adventure            <a href=/manga/genre/2/Adventure title=Adventure>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Comedy            <a href=/manga/genre/4/Comedy title=Comedy>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Fantasy            <a href=/manga/genre/10/Fantasy title=Fantasy>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Romance            <a href=/manga/genre/22/Romance title=Romance>                ","")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Drama            <a href=/manga/genre/8/Drama title=Drama>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Sci-Fi            <a href=/manga/genre/24/Sci-Fi title=Sci-Fi>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Horror            <a href=/manga/genre/14/Horror title=Horror>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Supernatural            <a href=/manga/genre/37/Supernatural title=Supernatural>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Girls Love            <a href=/manga/genre/26/Girls_Love title=Girls Love>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Slice of Life            <a href=/manga/genre/36/Slice_of_Life title=Slice of Life>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Mystery            <a href=/manga/genre/7/Mystery title=Mystery>                ", "")

$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Avant Garde            <a href=/manga/genre/5/Avant_Garde title=Avant Garde>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Award Winning            <a href=/manga/genre/46/Award_Winning title=Award Winning>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Boys Love            <a href=/manga/genre/28/Boys_Love title=Boys Love>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Gourmet            <a href=/manga/genre/47/Gourmet title=Gourmet>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Sports            <a href=/manga/genre/30/Sports title=Sports>                ","")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Suspense            <a href=/manga/genre/41/Suspense title=Suspense>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Work Life            <a href=/manga/genre/48/Work_Life title=Work Life>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Ecchi            <a href=/manga/genre/9/Ecchi title=Ecchi>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Erotica            <a href=/manga/genre/49/Erotica title=Erotica>                ", "")
$szText1 = StringReplace($szText1, "                   <span itemprop=genre style=display:none>Hentai            <a href=/manga/genre/12/Hentai title=Hentai>                ", "")

$szText1 = StringReplace($szText1, "                    ", "")
$szText1 = StringReplace($szText1, "                   ", "")
$szText1 = StringReplace($szText1, "        ", "")
$szText1 = StringReplace($szText1, "   ", " ")
$szText1 = StringReplace($szText1, "  ", " ")
$szText1 = StringReplace($szText1, "  ", "")
EndFunc   ;==>_FormatTEXT

Func _EstimatedTime(ByRef $a, $iCurrentCount = "", $iTotalCount = "")
    If $iCurrentCount & $iTotalCount = "" Then ; initialize
        $a = ""
        Dim $a[12]
        $a[5] = TimerInit() ; handle for TimerDiff()
        $a[0] = "00:00:00"
        $a[1] = "00:00:00"
        $a[2] = _NowCalc() ; starting date and time
        $a[3] = ""
        $a[4] = "0"
    Else
        If $iTotalCount = 0 Then Return False
        If $iCurrentCount > $iTotalCount Then $iCurrentCount = $iTotalCount
        _TicksToTime(Int(TimerDiff($a[5])), $a[6], $a[7], $a[8])
        _TicksToTime(Int((TimerDiff($a[5]) / $iCurrentCount) * ($iTotalCount - $iCurrentCount)), $a[9], $a[10], $a[11])
        $a[0] = StringFormat("%02i:%02i:%02i", $a[6], $a[7], $a[8]) ; elapsed time
        $a[1] = StringFormat("%02i:%02i:%02i", $a[9], $a[10], $a[11]) ; estimated total time
        $a[3] = _DateAdd("s", Int((TimerDiff($a[5]) / $iCurrentCount) * ($iTotalCount) / 1000), $a[2]) ; estimated date and time of completion
        $a[4] = Int($iCurrentCount / $iTotalCount * 100) ; percentage done
    EndIf
    Return True
EndFunc   ;==>_EstimatedTime

Func _BeginTime()
	_EstimatedTime($aETTF) ; called with just the data holder to init. it
	ProgressOn("Progress", "Scraping MAL", $aETTF[4] & "%","50","50",BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
	$Loop = "0"
EndFunc    ;==>_BeginTime

Func _CurrentTime()
	$Loop += 1
	$n = $Total - $Loop
	_EstimatedTime($aETTF, $Total - $n, $Total)
	ProgressSet($aETTF[4], $Loop & " of " & ($Total -1) & " - " & $aETTF[4] & "% - " & $aETTF[1] & " remains" & @CRLF & "Started on  " & $aETTF[2] & @CRLF & "Finished at " & $aETTF[3])
EndFunc   ;==>_CurrentTime

Func _EndTime()
	ProgressOff()
	GUICtrlSetData($Progress, ($Total - 1) & " of " & ($Total - 1) & " - 00:00:00")
EndFunc   ;==>_EndTime