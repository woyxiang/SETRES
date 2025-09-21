#define unicode
#include "windows.bi"
#include "lang.bi"
#include "String.bi"
#define INDENT Space(8)

Declare Sub ErrPage(Byval index As Integer)
Dim position As Integer, arg As String
Dim As Integer Argh, Argv, Argb, Argf
Dim As DEVMODE dm
Dim As Long result = -10

Function GetResource(Byval uID As UINT) As Long
    Dim buffer As Wstring * 256
    Dim result As Long
    result = LoadString(GetModuleHandle(NULL), uID, @buffer, 256)
    Print buffer
    Return result
End Function

'Initialize arg variables
Argh = -1
Argv = -1
Argb = -1
Argf = -1


'Parsing args
position = 1
Do
	arg = Command(position)
    If (Len(arg) = 0) Then 'Exit parsing If no args
        Exit Do
    End If
    
    Select Case Left(arg, 1)
        Case "h"
            Argh = Abs(Int(Val(Mid(arg, 2))))
        Case "v"
            Argv = Abs(Int(Val(Mid(arg, 2))))
        Case "b"
            Argb = Abs(Int(Val(Mid(arg, 2))))
        Case "f"
            Argf = Abs(Int(Val(Mid(arg, 2))))
        Case Else
            ErrPage 1
    End Select    
    position += 1
Loop
If (position = 1) Then
    ErrPage 0
End If

'Initialize
memset @dm, 0, Sizeof(dm)
dm.dmSize = Sizeof(dm)

'Submit changes
If (Argh=-1) Xor (Argv=-1) Then
    ErrPage 0
Elseif Argh <> -1 And Argv <> -1 Then 'With "h" And "v" args
    If Argb <> -1 And Argf <> -1 Then
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmBitsPerPel       = Argb
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL Or DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    Elseif Argb = -1 And Argf <> -1 Then
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    Elseif Argb <> -1 And Argf = -1 Then
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmBitsPerPel       = Argb
        dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    Else Argb = -1 And Argf = -1
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    End If
Else                                                'Without "h" And "v" args
    If Argb <> -1 And Argf <> -1 Then
        dm.dmBitsPerPel       = Argb
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_BITSPERPEL Or DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    Elseif Argb = -1 And Argf <> -1 Then
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    Elseif Argb <> -1 And Argf = -1 Then
        dm.dmBitsPerPel       = Argb
        dm.dmFields           = DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    End If
    
End If 

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
    Print
    GetResource ABOUT_ME
    Print 
    GetResource USAGE
    Print INDENT;"SETRES h<XXXX> v<XXXX> [f<XX>] [b<XX>]"
    Print INDENT;"SETRES f<XX> [b<XX>]"
    Print
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
    	'Print "错误： 提供的参数无法识别"
        GetResource UNRECOGNISED
		Print
    	Stop index
    Elseif index = 0 Then
    	'Print "错误： 提供的命令行参数数量错误。"
        GetResource WRONG_NUMBER
		Print    	
    	Stop index    	
    EndIf
End Sub


