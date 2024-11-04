#include "windows.bi"
#include "win/winuser.bi"
#include Once "win/winbase.bi"

Declare Sub ErrPage(ByVal index As Integer)

Type HorizontalPixels 
    h As Integer
End Type

Type VerticalPixels  
    v As Integer
End Type

Type ColourDepth     
    b As Integer
End Type

Type RefreshFrequncy  
    f as Integer
End Type


Type DisplaySettings
    Public : 
        Declare Constructor()
        Declare Function Set(f As RefreshFrequncy) As Long
        Declare Function Set(b As ColourDepth) As Long
        Declare Function Set(b As ColourDepth, f As RefreshFrequncy) As Long
        Declare Function Set(h As HorizontalPixels, v As VerticalPixels) As Long
        Declare Function Set(h As HorizontalPixels, v As VerticalPixels, b As ColourDepth) As Long
        Declare Function Set(h As HorizontalPixels, v As VerticalPixels, f As RefreshFrequncy) As Long
        Declare Function Set(h As HorizontalPixels, v As VerticalPixels, b As ColourDepth, f As RefreshFrequncy) As Long
    Private : 
        dm As DEVMODE
End Type

Constructor DisplaySettings()
    memset @This.dm, 0, SizeOf(This.dm)
    This.dm.dmSize = SizeOf(This.dm)
End Constructor

Function DisplaySettings.Set(f As RefreshFrequncy) As Long
    With This
        .dm.dmDisplayFrequency = f.f
        .dm.dmFields = DM_DISPLAYFREQUENCY    
        Return ChangeDisplaySettings(@.dm, CDS_UPDATEREGISTRY)
    End With
End Function

Function DisplaySettings.Set(b As ColourDepth) As Long
    With This
        .dm.dmBitsPerPel = b.b
        .dm.dmFields = DM_BITSPERPEL
        Return ChangeDisplaySettings(@.dm, CDS_UPDATEREGISTRY)
    End With

End Function

Function DisplaySettings.Set(b As ColourDepth, f As RefreshFrequncy) As Long
    With This
        .dm.dmBitsPerPel = b.b
        .dm.dmDisplayFrequency=f.f
        .dm.dmFields = DM_BITSPERPEL Or DM_DISPLAYFREQUENCY
        Return ChangeDisplaySettings(@.dm, CDS_UPDATEREGISTRY)
    End With

End Function


Function DisplaySettings.set(h As HorizontalPixels, v As VerticalPixels) As Long
    With This
        .dm.dmPelsWidth = h.h
        .dm.dmPelsHeight = v.v
        .dm.dmFields = DM_PELSWIDTH Or DM_PELSHEIGHT
        Return ChangeDisplaySettings(@.dm, CDS_UPDATEREGISTRY)
    End With

End Function

Function DisplaySettings.set(h As HorizontalPixels, v As VerticalPixels, b As ColourDepth) As Long
    With This
        .dm.dmPelsWidth = h.h
        .dm.dmPelsHeight = v.v
        .dm.dmBitsPerPel=b.b
        .dm.dmFields = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL
        Return ChangeDisplaySettings(@.dm, CDS_UPDATEREGISTRY)
    End With
End Function

Function DisplaySettings.Set(h As HorizontalPixels, v As VerticalPixels, f As RefreshFrequncy) As long
    With This
        .dm.dmPelsWidth = h.h
        .dm.dmPelsHeight = v.v
        .dm.dmDisplayFrequency=f.f
        .dm.dmFields = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_DISPLAYFREQUENCY
        Return ChangeDisplaySettings(@.dm, CDS_UPDATEREGISTRY)
    End With

End Function


Function DisplaySettings.set(h As HorizontalPixels, v As VerticalPixels, b As ColourDepth, f As RefreshFrequncy) As Long
    With This
        .dm.dmPelsWidth        = h.h
        .dm.dmPelsHeight       = v.v
        .dm.dmBitsPerPel       = b.b
        .dm.dmDisplayFrequency = f.f
        .dm.dmFields           = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL Or DM_DISPLAYFREQUENCY
        Return ChangeDisplaySettings(@.dm, CDS_UPDATEREGISTRY)
    End With
End Function



Dim position As Integer, arg As String
Dim As DisplaySettings ds = DisplaySettings()
Dim As Integer hPixels, vPixels,bitColour,Frequncy
'解析参数
position = 1
do
    arg = command(position)
    If (Len(arg) = 0) Then '如果无参数就退出循环
        Exit Do
    End If
    
    Select Case Left(arg, 1)
        Case "h"
            hPixels = Type(Int(Val(Mid(arg, 2)))) ' 提取水平分辨率 (hXXXX)
        Case "v"
            vPixels = Type(Int(Val(Mid(arg, 2)))) ' 提取垂直分辨率 (vXXXX)
        Case "b"
            bitColour = Type(Int(Val(Mid(arg, 2)))) ' 提取色深 (bXX)
        Case "f"
            Frequncy = Type(Int(Val(Mid(arg, 2)))) ' 提取刷新率 (fXX)
        Case Else
            ErrPage 1
    End Select
    
    
    position += 1
loop

if (position = 1) then
    ErrPage 0
End If

If (hPixels = 0) Xor (vPixels = 0) Then 
    ErrPage(1)
ElseIf hPixels <> 0 And vPixels <> 0 Then
    If bitColour <> 0 And Frequncy <> 0 Then
        Dim As HorizontalPixels h = Type(hPixels)
        Dim As VerticalPixels v = Type(vPixels)
        Dim As ColourDepth b = Type(bitColour)
        Dim As RefreshFrequncy f = Type(Frequncy)
        Print ds.set(h,v,b,f)
    ElseIf bitColour = 0 And Frequncy <> 0 Then
        Dim As HorizontalPixels h = Type(hPixels)
        Dim As VerticalPixels v = Type(vPixels)
        Dim As RefreshFrequncy f = Type(Frequncy)
        Print ds.set(h, v, f)
    ElseIf bitColour <> 0 And Frequncy = 0 Then
        Dim As HorizontalPixels h = Type(hPixels)
        Dim As VerticalPixels v = Type(vPixels)
        Dim As ColourDepth b = Type(bitColour)
        Print ds.set(h, v, b)
    Else bitColour = 0 And Frequncy = 0
        Dim As HorizontalPixels h = Type(hPixels)
        Dim As VerticalPixels v = Type(vPixels)
        Print ds.set(h, v)        
    End If
Else
        If bitColour <> 0 And Frequncy <> 0 Then
        Dim As HorizontalPixels h = Type(hPixels)
        Dim As VerticalPixels v = Type(vPixels)
        Dim As ColourDepth b = Type(bitColour)
        Dim As RefreshFrequncy f = Type(Frequncy)
        Print ds.set(h,v,b,f)
    ElseIf bitColour = 0 And Frequncy <> 0 Then
        Dim As HorizontalPixels h = Type(hPixels)
        Dim As VerticalPixels v = Type(vPixels)
        Dim As RefreshFrequncy f = Type(Frequncy)
        Print ds.set(h, v, f)
    ElseIf bitColour <> 0 And Frequncy = 0 Then
        Dim As HorizontalPixels h = Type(hPixels)
        Dim As VerticalPixels v = Type(vPixels)
        Dim As ColourDepth b = Type(bitColour)
        Print ds.set(h, v, b)
    Else bitColour = 0 And Frequncy = 0
        Dim As HorizontalPixels h = Type(hPixels)
        Dim As VerticalPixels v = Type(vPixels)
        Print ds.set(h, v)        
    End If    
End If

'Dim As DisplaySettings ds       = DisplaySettings()
'Dim As RefreshFrequncy Frequncy = Type(165)


sleep


Sub ErrPage(ByVal index As Integer)
    print "A command line program to change the screen resolution, colour depth and"
    print "refresh frequency in Windows 98, Me, 2000 and XP. May/may not work with Win 95."
    print ""
    print "         SETRES hXXXX vXXXX [bXX] [fXX]"
    print ""
    print "hXXXX = Horizontal size of screen in pixels          Not optional. 640 minimum"
    print "vXXXX = Vertical size of screen in pixels            Not optional. 480 minimum"
    print "  bXX = Bit (colour) depth such as 8, 16 24, 32      Optional"
    print "  fXX = Refresh frequncy in Hertz, e.g. 60, 75, 85    Optional."
    print ""
    print "EXAMPLES:"
    print "         SETRES h1024 v768"
    print "         SETRES h800 v600 b24"
    print "         SETRES h1280 v1024 b32 f75"
    print ""
    print "WARNING: SETRES does not check the capabilities of your hardware. Windows"
    print "         is supposed to  reject unsupported settings but do not rely on this."
    print "         If you specify unsupported settings, and in the event of hardware"
    print "         damage, I WILL NOT ACCEPT RESPONSIBILITY.  "
    print ""
    if index = 0 then
        Print "ERROR: Wrong number of command line parameters supplied."
    else
        print "ERROR: Unrecognised parameter supplied"
    end if
    print "PRESS A KEY"
    sleep
    stop 1
end sub
