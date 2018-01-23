##### 1. 背景

对于键盘党来说，AutoHotkey 简直是必备神器，自从用上了就离不开了。当然再锋利的刀刃，也要看你会不会使，AutoHotkey的脚本语言/语法设计的是真的烂。可一旦一个顺手的脚本写成了，你就再也离不开它了。

##### 2. 安装AutoHotkey

下载地址：[AutoHotkey](https://autohotkey.com/)

##### 3. 第一个脚本
 1. 使用顺手的编辑器编写第一个脚本，文件命名为`temp.ahk`
```ahk
; 按下 Win+N 时，打开记事本
#n::Run Notepad
```
安装好AutoHotkey之后，双击文件`temp.ahk`，系统托盘便出现了AutoHotkey的小图标，这时脚本已经生效了，按下`Win+N`可以看到记事本启动。

##### 4. 是时候提高一波生产力了
脚本命名为`keys.ahk`
* 快捷运行/停止**网易云音乐**
```ahk
DetectHiddenWindows,On

; Ctrl+Alt+W 快捷打开/停止网易云音乐
^!w::
Process,Exist,cloudmusic.exe
if (%ErrorLevel% == 0){ ; 如果未运行，则启动
	Run "C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe"
	WinWait,ahk_class DesktopLyrics
	WinMove,,,,A_ScreenHeight-64 ; 将桌面歌词移动到合适的位置
} else { ; 已启动则停止
; 停止后，系统托盘中网易云的图标仍然还在，需要鼠标飘过才能消失
; 于是在系统托盘范围内寻找网易云图标的位置，并将鼠标移动过去，之后再移动回来
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
```
想听歌时：Ctrl+Alt+W
不想听了：Ctrl+Alt+W

* 在资源管理器中快捷打开**Cmder**
虽说在浏览文件时，可以通过右键菜单快捷得在当前目录打开Cmder，可用到右键，就要使用鼠标，手就要离开键盘，对于一个经常需要在终端下工作的程序员来说，这个不能忍，于是：
```ahk
; Ctrl+Shift+T 在当前目录打开cmder
$^+t::
Process,Exist,explorer.exe
if (%ErrorLevel% != 0){
	if WinActive("ahk_class CabinetWClass"){
		path := getExplorerPath()	
		Run ,cmder "%path%"
		return
	} ; 如果在桌面
	if WinActive("ahk_class WorkerW"){
		Run ,cmder %A_Desktop%
		return
	}
}
; 获取当前路径的函数
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
```
要在这个目录打命令？Ctrl+Shift+T，秒秒钟，一个 Cmder 准备就绪。

* 在Sublime Text中快捷打开**Cmder**
顺手的编辑器为Sublime Text，在Sublime Text中编辑完代码之后，通常需要打开终端编译运行刚刚的代码，常用的操作当然要方便又快捷，于是：
```ahk
; Ctrl+Shift+T 在当前编辑文件的目录打开cmder
$^+t::
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
```
* 统一常用快捷键
各种工具/IDE快捷键不尽相同，于是将几个最常用的快捷键统一如下：
```ahk
; Ctrl + BackSpace 删除单词
#IF WinActive("ahk_class Notepad")
Ctrl & BackSpace::Send ^+{left}{BackSpace}
#IF

; Shift + Enter 另起新行
Shift & Enter::Send {End}{Enter}

; Ctrl + D 删除一行
; 对Sublime Text特殊处理（PX_WINDOW_CLASS）
; 只支持常用的几个IDE/编辑器
; 在不支持的窗口上，原样发送 Ctrl + D 快捷键
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

; Alt+C关闭当前窗口
; 如果当前窗口是Chrome，则将快捷键映射为Ctrl + W，作用为关闭当前标签页，而不是关闭整个窗口
$!c::
if(WinActive("ahk_class Chrome_WidgetWin_1")){
	send {Ctrl down}w{Ctrl up}
}else{
	WinClose,A
}
return
```

##### 5. 设置开机运行
 1. 右键该脚本，创建快捷方式
 2. 
##### 6. 更多用法有待挖掘
##### 7. Github地址
