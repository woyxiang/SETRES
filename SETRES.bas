#cmdline "lang.rc"
#define unicode
#include "windows.bi"
#include "lang.bi"
#include "string.bi"
#include "crt.bi"
#define INDENT space(8)
'#define PrintError(text) color 12 : print text : color 7

sub PrintError(byref text as string)

    ' open err for input as #1
    '     print #1, text
    ' close #1
    ' Don't know why this won't work
    ' so I have to use fprintf

    dim originColor as ULong
    originColor = color()
    color 12
    fprintf(stderr, "%s", text)
    color loword(originColor), hiword(originColor)

end sub

dim shared as UINT originCodePage 
originCodePage = GetConsoleOutputCP()
SetConsoleOutputCP 936  '如果终端是utf8的话会中文会出现乱码，故主函数运行前要把代码页改成936

'theoretically the program will only exit from here.
sub shut(byval code as integer)
    #ifndef __VERSION__
        color 11
        print  __DATE_ISO__ & space(1) & __TIME__ & " compiled with fbc-" & __FB_VERSION__ 
        color 7
    #endIf
    SetConsoleOutputCP originCodePage
    if code <> 0 then
        end code
    end if
end sub


function GetResource(byval uID as UINT) as string
    dim buffer as wstring * 256
    dim result as long
    result = LoadString(GetModuleHandle(NULL), uID, @buffer, 256)
    'print buffer
    return str(buffer)
end function

sub ErrPage(byval code as integer)
    #ifdef __VERSION__ 
        print  
        print "        SETRES v" &  __VERSION__, "https://github.com/woyxiang/SETRES"
        print "==============================================================================="
    #endif
    print
    print GetResource(ABOUT_ME)
    print 
    print GetResource(USAGE)
    print INDENT;"SETRES h<XXXX> v<XXXX> [f<XX>] [b<XX>]"
    print INDENT;"SETRES f<XX> [b<XX>]"
    print
    print INDENT;"h<XXXX> = ";:print GetResource(hXXXX)
    print INDENT;"v<XXXX> = ";:print GetResource(vXXXX)
    print INDENT;"  b<XX> = ";:print GetResource(bXX)
    print INDENT;"  f<XX> = ";:print GetResource(fXX)
    print 
    print GetResource(EXAMPLES)
    print INDENT;"SETRES h1024 v768"
    print INDENT;"SETRES h800 v600 b24"
    print INDENT;"SETRES h1280 v1024 b32 f75"
    print INDENT;"SETRES f75"
    print 
    print GetResource(WARNING)
    print INDENT;:print GetResource(THE_WARNING)
    print 
    print 
    if code = 101 then
        PrintError(GetResource(UNRECOGNISED))
		print
    	shut code
    elseif code = 100 then
        PrintError(GetResource(WRONG_NUMBER))
		print    	
    	shut code    	
    EndIf
end sub

sub main()

    dim position as integer, arg as string
    dim as integer Argh, Argv, Argb, Argf
    dim as DEVMODE dm
    dim as long result = -10

    'Initialize arg variables
    Argh = -1
    Argv = -1
    Argb = -1
    Argf = -1


    'Parsing args
    position = 1
    do
        arg = command(position)
        if (len(arg) = 0) then 'exit parsing if no args
            exit do
        end if
        
        select case left(arg, 1)
            case "h"
                Argh = abs(int(val(mid(arg, 2))))
            case "v"
                Argv = abs(int(val(mid(arg, 2))))
            case "b"
                Argb = abs(int(val(mid(arg, 2))))
            case "f"
                Argf = abs(int(val(mid(arg, 2))))
            case else
                ErrPage 101
        end select    
        position += 1
    loop
    if (position = 1) then
        ErrPage 100
    end if

    'Initialize
    memset @dm, 0, sizeof(dm)
    dm.dmSize = sizeof(dm)

    'Submit changes
    if (Argh=-1) xor (Argv=-1) then
        ErrPage 100
    elseif Argh <> -1 and Argv <> -1 then            'with "h" and "v" args

        if Argb <> -1 and Argf <> -1 then            'h v b f args
            if Argb=0 or Argf=0 then ErrPage(100)
            dm.dmPelsWidth        = Argh
            dm.dmPelsHeight       = Argv
            dm.dmBitsPerPel       = Argb
            dm.dmDisplayFrequency = Argf
            dm.dmFields           = DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL or DM_DISPLAYFREQUENCY
            result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
        elseif Argb = -1 and Argf <> -1 then         'h v f args
            if Argf=0 then ErrPage(100)
            dm.dmPelsWidth        = Argh
            dm.dmPelsHeight       = Argv
            dm.dmDisplayFrequency = Argf
            dm.dmFields           = DM_PELSWIDTH or DM_PELSHEIGHT or DM_DISPLAYFREQUENCY
            result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
        elseif Argb <> -1 and Argf = -1 then         'h v b args
            if Argb=0 then ErrPage(100)
            dm.dmPelsWidth        = Argh
            dm.dmPelsHeight       = Argv
            dm.dmBitsPerPel       = Argb
            dm.dmFields           = DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL
            result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
        else Argb = -1 and Argf = -1                'h v args
            if Argh=0 or Argv=0 then ErrPage(100)
            dm.dmPelsWidth        = Argh
            dm.dmPelsHeight       = Argv
            dm.dmFields           = DM_PELSWIDTH or DM_PELSHEIGHT
            result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
        end if
    else                                                'Without "h" and "v" args
        if Argb <> -1 and Argf <> -1 then
            if Argb=0 or Argf=0 then ErrPage(100)       'b f args
            dm.dmBitsPerPel       = Argb
            dm.dmDisplayFrequency = Argf
            dm.dmFields           = DM_BITSPERPEL or DM_DISPLAYFREQUENCY
            result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
        elseif Argb = -1 and Argf <> -1 then            'only f arg
            if Argf=0 then ErrPage(100)
            dm.dmDisplayFrequency = Argf
            dm.dmFields           = DM_DISPLAYFREQUENCY
            result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
        elseif Argb <> -1 and Argf = -1 then            'only b arg
            if Argb=0 then ErrPage(100)
            dm.dmBitsPerPel       = Argb
            dm.dmFields           = DM_DISPLAYFREQUENCY
            result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
        end if
        
    end if 

    select case result
        case DISP_CHANGE_SUCCESSFUL
            print GetResource(dcSUCCESSFUL)
            shut 0
        case DISP_CHANGE_BADDUALVIEW
            PrintError(GetResource(dcBADDUALVIEW))
            shut 102
        case DISP_CHANGE_BADFLAGS
            PrintError(GetResource(dcBADFLAGS))
            shut 103
        case DISP_CHANGE_BADMODE
            PrintError(GetResource(dcBADMODE))
            shut 104
        case DISP_CHANGE_BADPARAM
            PrintError(GetResource(dcBADPARAM))
            shut 105
        case DISP_CHANGE_FAILED
            PrintError(GetResource(dcFAILED))
            shut 106
        case DISP_CHANGE_NOTUPDATED
            PrintError(GetResource(dcNOTUPDATED))
            shut 107
        case DISP_CHANGE_RESTART
            PrintError(GetResource(dcRESTART))
            shut 108
        case else
            PrintError(GetResource(dcUNKNOWN))
            shut 150
    end select

end sub

main()