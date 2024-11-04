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
'���ø��ĳɹ���
'DISP_CHANGE_BADDUALVIEW
'���ø���ʧ�ܣ���Ϊϵͳ֧�� DualView��
'DISP_CHANGE_BADFLAGS
'������һ����Ч�ı�־��
'DISP_CHANGE_BADMODE
'��֧��ͼ��ģʽ��
'DISP_CHANGE_BADPARAM
'��������Ч������ ����԰�����Ч��־���־��ϡ�
'DISP_CHANGE_FAILED
'��ʾ��������δͨ��ָ����ͼ��ģʽ��
'DISP_CHANGE_NOTUPDATED
'�޷�������д��ע���
'DISP_CHANGE_RESTART
'�����������������ʹͼ��ģʽ����������

Select Case result
    Case DISP_CHANGE_SUCCESSFUL
        Print "���ø��ĳɹ���"
    Case DISP_CHANGE_BADDUALVIEW
        print "���ø���ʧ�ܣ���Ϊϵͳ֧�� DualView��"
    Case DISP_CHANGE_BADFLAGS
        Print "������һ����Ч�ı�־��"
    Case DISP_CHANGE_BADMODE
        print "��֧��ͼ��ģʽ��"
    Case DISP_CHANGE_BADPARAM
        print "��������Ч������ ����԰�����Ч��־���־��ϡ�"
    Case DISP_CHANGE_FAILED
        print "��ʾ��������δͨ��ָ����ͼ��ģʽ��"
    Case DISP_CHANGE_NOTUPDATED
        print "�޷�������д��ע���"
    Case DISP_CHANGE_RESTART
        Print "�����������������ʹͼ��ģʽ����������"
    Case Else
        Print "δ֪����"
End Select

Sub ErrPage(Byval index As Integer)
    Print "һ��������Ļ�ֱ��ʡ�ɫ���ˢ��Ƶ�ʵ������г���"
    Print ""
    Print ""
    Print "         SETRES hXXXX vXXXX [bXX] [fXX]"
    Print ""
    Print "hXXXX = ��Ļ��ˮƽ�ߴ磨����          "
    Print "vXXXX = ��Ļ��ֱ�ߴ磨����             "
    Print "  bXX = ���أ�ɫ�ʣ���ȣ��� 8��16 24��32       "
    Print "  fXX = ˢ��Ƶ�ʣ����ȣ������� 60��75��85        "
    Print ""
    Print "����:"
    Print "         SETRES h1024 v768"
    Print "         SETRES h800 v600 b24"
    Print "         SETRES h1280 v1024 b32 f75"
    Print ""
    Print "���棺 SETRES �����Ӳ�����ܡ�Windows Ӧ�û�ܾ���֧�ֵ����ã���"
    Print "      �벻Ҫ������һ�㡣�����ָ���˲�֧�ֵ����ã�������Ӳ���𻵵�"
    Print "      ����£��ҽ����е����Ρ� "
    Print "         "
    Print ""
    If index = 1 Then
    	Print "���� �ṩ�Ĳ����޷�ʶ��"
		Print ""
    	Print "���������"
    	Sleep
    	Stop index
    Elseif index = 0 Then
    	Print "���� �ṩ�������в�����������"
		Print ""    	
    	Print "���������"
    	Sleep
    	Stop index    	
    EndIf
End Sub


