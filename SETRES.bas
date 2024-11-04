#include "windows.bi"
#include "win/winuser.bi"
#include Once "win/winbase.bi"

Declare Sub ErrPage(Byval index As Integer)
Dim position As Integer, arg As String
Dim As Integer Argh, Argv, Argb, Argf
Dim As DEVMODE dm
Dim As long result = -10

'Parsing args
position = 1
Do
	arg = Command(position)
    If (Len(arg) = 0) Then 'Exit parsing If no args
        Exit Do
    End If
    
    Select Case Left(arg, 1)
        Case "h"
            Argh = Int(Val(Mid(arg, 2)))
        Case "v"
            Argv = Int(Val(Mid(arg, 2)))
        Case "b"
            Argb = Int(Val(Mid(arg, 2))) 
        Case "f"
            Argf = Int(Val(Mid(arg, 2))) 
        Case Else
            ErrPage 1
    End Select    
    position += 1
Loop
If (position = 1) Then
    ErrPage 0
End If

'Initialize
memset @dm, 0, SizeOf(dm)
dm.dmSize = SizeOf(dm)

'Submit changes
If (Argh=0) Xor (Argv=0) Then
    ErrPage 0
ElseIf Argh <> 0 And Argv <> 0 Then 'With "h" and "v" args
    If Argb <> 0 And Argf <> 0 Then
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmBitsPerPel       = Argb
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL Or DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, 0)
    ElseIf Argb = 0 And Argf <> 0 Then
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, 0)
    ElseIf Argb <> 0 And Argf = 0 Then
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmBitsPerPel       = Argb
        dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL
        result = ChangeDisplaySettings(@dm, 0)
    Else Argb = 0 And Argf = 0
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT
        result = ChangeDisplaySettings(@dm, 0)
    End If
Else                                                'Without "h" and "v" args
    If Argb <> 0 And Argf <> 0 Then
        dm.dmBitsPerPel       = Argb
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_BITSPERPEL Or DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, 0)
    ElseIf Argb = 0 And Argf <> 0 Then
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, 0)
    ElseIf Argb <> 0 And Argf = 0 Then
        dm.dmBitsPerPel       = Argb
        dm.dmFields           = DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, 0)
    End If
    
End If 

'Print result

'DISP_CHANGE_SUCCESSFUL
'设置更改成功。
'DISP_CHANGE_BADDUALVIEW
'设置更改失败，因为系统支持 DualView。
'DISP_CHANGE_BADFLAGS
'传入了一组无效的标志。
'DISP_CHANGE_BADMODE
'不支持图形模式。
'DISP_CHANGE_BADPARAM
'传入了无效参数。 这可以包括无效标志或标志组合。
'DISP_CHANGE_FAILED
'显示驱动程序未通过指定的图形模式。
'DISP_CHANGE_NOTUPDATED
'无法将设置写入注册表。
'DISP_CHANGE_RESTART
'必须重启计算机才能使图形模式正常工作。

Select Case result
    Case DISP_CHANGE_SUCCESSFUL
        Print "设置更改成功。"
    Case DISP_CHANGE_BADDUALVIEW
        print "设置更改失败，因为系统支持 DualView。"
    Case DISP_CHANGE_BADFLAGS
        Print "传入了一组无效的标志。"
    Case DISP_CHANGE_BADMODE
        print "不支持图形模式。"
    Case DISP_CHANGE_BADPARAM
        print "传入了无效参数。 这可以包括无效标志或标志组合。"
    Case DISP_CHANGE_FAILED
        print "显示驱动程序未通过指定的图形模式。"
    Case DISP_CHANGE_NOTUPDATED
        print "无法将设置写入注册表。"
    Case DISP_CHANGE_RESTART
        Print "必须重启计算机才能使图形模式正常工作。"
    Case Else
        Print "未知错误"
End Select

Sub ErrPage(Byval index As Integer)
    Print "一个更改屏幕分辨率、色深和刷新频率的命令行程序。"
    Print ""
    Print ""
    Print "         SETRES hXXXX vXXXX [bXX] [fXX]"
    Print ""
    Print "hXXXX = 屏幕的水平尺寸（像素          "
    Print "vXXXX = 屏幕垂直尺寸（像素             "
    Print "  bXX = 比特（色彩）深度，如 8、16 24、32       "
    Print "  fXX = 刷新频率（赫兹），例如 60、75、85        "
    Print ""
    Print "例子:"
    Print "         SETRES h1024 v768"
    Print "         SETRES h800 v600 b24"
    Print "         SETRES h1280 v1024 b32 f75"
    Print ""
    Print "警告： SETRES 不检查硬件功能。Windows 应该会拒绝不支持的设置，但"
    Print "      请不要依赖这一点。如果你指定了不支持的设置，并且在硬件损坏的"
    Print "      情况下，我将不承担责任。 "
    Print "         "
    Print ""
    If index = 1 Then
    	Print "错误： 提供的参数无法识别"
		Print ""
    	Print "任意键继续"
    	Sleep
    	Stop index
    Elseif index = 0 Then
    	Print "错误： 提供的命令行参数数量错误。"
		Print ""    	
    	Print "任意键继续"
    	Sleep
    	Stop index    	
    EndIf
End Sub


