#define unicode
#include "windows.bi"
#include "lang.bi"
#include "string.bi"
#define INDENT space(8)

Declare Sub ErrPage(Byval index As Integer)
Dim position As Integer, arg As String
Dim As Integer Argh, Argv, Argb, Argf
Dim As DEVMODE dm
Dim As long result = -10

function GetResource(byval uID as UINT) as long
    dim buffer as wstring * 256
    dim result as long
    result = LoadString(GetModuleHandle(NULL), uID, @buffer, 256)
    print buffer
    return result
end function

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
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    ElseIf Argb = 0 And Argf <> 0 Then
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    ElseIf Argb <> 0 And Argf = 0 Then
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmBitsPerPel       = Argb
        dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    Else Argb = 0 And Argf = 0
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    End If
Else                                                'Without "h" and "v" args
    If Argb <> 0 And Argf <> 0 Then
        dm.dmBitsPerPel       = Argb
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_BITSPERPEL Or DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    ElseIf Argb = 0 And Argf <> 0 Then
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    ElseIf Argb <> 0 And Argf = 0 Then
        dm.dmBitsPerPel       = Argb
        dm.dmFields           = DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
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
        GetResource dcSUCCESSFUL
    Case DISP_CHANGE_BADDUALVIEW
        GetResource dcBADDUALVIEW
    Case DISP_CHANGE_BADFLAGS
        GetResource dcBADFLAGS
    Case DISP_CHANGE_BADMODE
        GetResource dcBADMODE
    Case DISP_CHANGE_BADPARAM
        GetResource dcBADPARAM
    Case DISP_CHANGE_FAILED
        GetResource dcFAILED
    Case DISP_CHANGE_NOTUPDATED
        GetResource dcNOTUPDATED
    Case DISP_CHANGE_RESTART
        GetResource dcRESTART
    Case Else
        GetResource dcUNKNOWN
End Select

Sub ErrPage(Byval index As Integer)
    print
    GetResource ABOUT_ME
    Print 
    GetResource USAGE
    Print INDENT;"SETRES h<XXXX> v<XXXX> [f<XX>] [b<XX>]"
    Print INDENT;"SETRES f<XX> [b<XX>]"
    print
    Print INDENT;"h<XXXX> = ";:GetResource hXXXX
    Print INDENT;"v<XXXX> = ";:GetResource vXXXX
    Print INDENT;"  b<XX> = ";:GetResource bXX
    Print INDENT;"  f<XX> = ";:GetResource fXX
    Print 
    GetResource EXAMPLES
    Print INDENT;"SETRES h1024 v768"
    Print INDENT;"SETRES h800 v600 b24"
    Print INDENT;"SETRES h1280 v1024 b32 f75"
    Print INDENT;"SETRES f75"
    Print 
    GetResource WARNING
    Print INDENT;:GetResource THE_WARNING
    Print 
    Print 
    If index = 1 Then
    	Print "错误： 提供的参数无法识别"
		Print ""
    	Stop index
    Elseif index = 0 Then
    	Print "错误： 提供的命令行参数数量错误。"
		Print ""    	
    	Stop index    	
    EndIf
End Sub


