DetectHiddenWindows,On

; ---------------------------------
; Ctrl+Alt+W 快捷打开网易云音乐
^!w::
Process,Exist,cloudmusic.exe
if (%ErrorLevel% == 0){
	Run "C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe"
	WinWait,ahk_class DesktopLyrics
	WinMove,,,,A_ScreenHeight-64
}
else
{
	Run, taskkill /PID %ErrorLevel% /F,,Hide
	Sleep, 500
	CoordMode,Pixel,Screen
	CoordMode,Mouse,Screen
	MouseGetPos, MX, MY
	WinGetPos, Task_X, Task_Y, Task_W, Task_H, ahk_class Shell_TrayWnd
	ImageSearch, X, Y, Task_X, Task_Y/3, A_ScreenWidth, A_ScreenHeight, cloud_music_icon.bmp
	MouseMove, X, Y
	MouseMove, MX, MY
	CoordMode,Pixel,Relative
	CoordMode,Mouse,Relative
}
return

old_win_class =  
$!d::
Process,Exist,cloudmusic.exe
if (%ErrorLevel% != 0){
	if WinActive("ahk_class OrpheusBrowserHost"){
		WinHide,ahk_class OrpheusBrowserHost
		WinActivate, ahk_class %old_win_class%
	}else{
		WinGetActiveTitle, old_win_title
		WinGetClass, old_win_class, A
		WinShow,ahk_class OrpheusBrowserHost
		WinActivate,ahk_class OrpheusBrowserHost
	}
}else{
	Send !d
}
return

; ---------------------------------------------
; Ctrl+Alt+Q 快捷打开QQ，如果QQ已在运行，则退出 
^!q::
Process,Exist,TIM.exe
if (%ErrorLevel% == 0){
	Run "C:\Program Files (x86)\Tencent\TIM\Bin\QQScLauncher.exe"
}else{
	Run, taskkill /PID %ErrorLevel% /F,,Hide
	Sleep, 500
	CoordMode,Pixel,Screen
	CoordMode,Mouse,Screen
	MouseGetPos, MX, MY
	WinGetPos, Task_X, Task_Y, Task_W, Task_H, ahk_class Shell_TrayWnd

	Loop, tim_icon\*.bmp
	{
		ImageSearch, X, Y, Task_X, Task_Y/3, A_ScreenWidth, A_ScreenHeight, %A_LoopFileFullPath%
		if(%ErrorLevel% == 0){
			break
		}
	}

	MouseMove, X, Y
	MouseMove, MX, MY
	CoordMode,Pixel,Relative
	CoordMode,Mouse,Relative
}
return

; --------------------------------------------------------------
; Ctrl+Shift+T 在当前目录打开cmder（支持SublimeText和资源管理器）
$^+t::
Process,Exist,explorer.exe
if (%ErrorLevel% != 0){
	if WinActive("ahk_class CabinetWClass"){
		path := getExplorerPath()	
		Run ,cmder "%path%"
		return
	}
	if WinActive("ahk_class WorkerW"){
		Run ,cmder %A_Desktop%
		return
	}
}
Process,Exist,sublime_text.exe
if (%ErrorLevel% != 0){
	if WinActive("ahk_class PX_WINDOW_CLASS"){
		WinGetTitle, title, ahk_class PX_WINDOW_CLASS
		StringGetPos,pos,title,\,r
		StringLeft, folder, title, %pos%
		Run ,cmder "%folder%"
		return
	}
}
Process,Exist,studio64.exe
if (%ErrorLevel% != 0){
	if WinActive("ahk_class SunAwtFrame"){
		WinGetTitle, title, ahk_class SunAwtFrame
		StringGetPos,pos1,title,],l
		StringLeft, folder, title, %pos1%
		StringGetPos,pos2,folder,[,l
		StringRight, folder, folder, pos1-pos2-1
		Run ,cmder " %folder% "
		return
	}
}
Process,Exist,webstorm.exe
if (%ErrorLevel% != 0){
	if WinActive("ahk_class SunAwtFrame"){
		WinGetTitle, title, ahk_class SunAwtFrame
		StringGetPos,pos1,title,],l
		StringLeft, folder, title, %pos1%
		StringGetPos,pos2,folder,[,l
		StringRight, folder, folder, pos1-pos2-1
		Run ,cmder " %folder% "
		return
	}
}
Send ^+t
return

; --------------------------------------------
; Ctrl+Shift+Y 在资源管理器中打开当前目录
^+y::
Process,Exist,sublime_text.exe
if (%ErrorLevel% != 0){
	if WinActive("ahk_class PX_WINDOW_CLASS"){
		WinGetTitle, title, ahk_class PX_WINDOW_CLASS
		SearchText = \
		StringGetPos,pos,title,%SearchText%,r
		StringLeft, path, title, %pos%
		IfWinExist, ahk_class CabinetWClass, %path%
		{
			WinActivate
		}else{
			Run ,explorer %path%
		}
		return
	}
}
if (WinActive("ahk_class SunAwtFrame")){
	WinGetTitle, title
	SearchText = ]
	StringGetPos,lpos,title,%SearchText%,l
	StringLeft, title, title, %lpos%
	split = [
	StringSplit, titles,title, %split%
	path = %titles2%
	IfWinExist, ahk_class CabinetWClass, %path%
	{
		WinActivate
	}else{
		Run ,explorer %path%
	}
}
return

getExplorerPath(){
	IfWinExist, ahk_class CabinetWClass
	{
		ControlGetText,address,ToolbarWindow323,ahk_class CabinetWClass
		StringLen, length, address
		StringRight, path, address, length-4
		return path
	}
	return
}
	
; Ctrl+BackSpace 删除单词
#IF WinActive("ahk_class Notepad")
Ctrl & BackSpace::Send ^+{left}{BackSpace}
#IF

; Shift+Enter 另起新行
Shift & Enter::Send {End}{Enter}

; Ctrl+D 删除一行
$^d::
if (WinActive("ahk_class PX_WINDOW_CLASS")){
	send ^l{delete}
	return
}

if (WinActive("ahk_class Notepad")
 or WinActive("ahk_class ApplicationFrameWindow") 
 or WinActive("ahk_class Qt5QWindowIcon")){
	send {home 2}{Shift down}{end}{right}{Shift up}{delete}
}else{
	send, ^d
}
return

; 单击左边的Ctrl键会将剪切板中非文本内容转化为文本，比如文件转化为文件的路径
Ctrl::
Clipboard = %Clipboard%

StringLeft showText,Clipboard,300
showlen := StrLen(showText)
totallen := StrLen(Clipboard)
if(showlen < totallen)
{
	showText := showText "`n`n......`n" totallen " more"
}
ToolTip, %showText%
Sleep,1000
tooltip
return 

; Alt+C关闭当前窗口
$!c::
if (WinActive("ahk_class Progman") or WinActive("ahk_class WorkerW")){
	send {Shift down}{F10 down}vd{F10 up}{Shift up}
}else if(WinActive("ahk_class Chrome_WidgetWin_1")){
	send {Ctrl down}w{Ctrl up}
}else{
	WinClose,A
}
return

XButton1::
AppsKey::
CoordMode,Mouse,Screen
MouseGetPos,mouseX,mouseY
CoordMode,Mouse,Relative
Run ,pythonw skyutils\main.py %mouseX% %mouseY%
return

^ESC::
Send, ^{vkc0sc029}
Return
