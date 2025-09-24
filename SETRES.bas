#define unicode
#include "windows.bi"
#include "lang.bi"
#include "string.bi"
#define INDENT space(8)
#define PrintError(text) color 12 : print text : color 7


dim position as integer, arg as string
dim as integer Argh, Argv, Argb, Argf
dim as DEVMODE dm
dim as long result = -10

function GetResource(byval uID as UINT) as string
    dim buffer as wstring * 256
    dim result as long
    result = LoadString(GetModuleHandle(NULL), uID, @buffer, 256)
    'print buffer
    return str(buffer)
end function

sub ErrPage(byval index as integer)
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
    if index = 1 then
    	'print "错误： 提供的参数无法识别"
        PrintError(GetResource(UNRECOGNISED))
		print
    	stop index
    elseif index = 0 then
    	'print "错误： 提供的命令行参数数量错误。"
        PrintError(GetResource(WRONG_NUMBER))
		print    	
    	stop index    	
    EndIf
end sub


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
            ErrPage 1
    end select    
    position += 1
loop
if (position = 1) then
    ErrPage 0
end if

'Initialize
memset @dm, 0, sizeof(dm)
dm.dmSize = sizeof(dm)

'Submit changes
if (Argh=-1) xor (Argv=-1) then
    ErrPage 0
elseif Argh <> -1 and Argv <> -1 then 'with "h" and "v" args
    if Argb <> -1 and Argf <> -1 then
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmBitsPerPel       = Argb
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL or DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    elseif Argb = -1 and Argf <> -1 then
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_PELSWIDTH or DM_PELSHEIGHT or DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    elseif Argb <> -1 and Argf = -1 then
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmBitsPerPel       = Argb
        dm.dmFields           = DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    else Argb = -1 and Argf = -1
        dm.dmPelsWidth        = Argh
        dm.dmPelsHeight       = Argv
        dm.dmFields           = DM_PELSWIDTH or DM_PELSHEIGHT
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    end if
else                                                'Without "h" and "v" args
    if Argb <> -1 and Argf <> -1 then
        dm.dmBitsPerPel       = Argb
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_BITSPERPEL or DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    elseif Argb = -1 and Argf <> -1 then
        dm.dmDisplayFrequency = Argf
        dm.dmFields           = DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    elseif Argb <> -1 and Argf = -1 then
        dm.dmBitsPerPel       = Argb
        dm.dmFields           = DM_DISPLAYFREQUENCY
        result = ChangeDisplaySettings(@dm, CDS_UPDATEREGISTRY)
    end if
    
end if 

select case result
    case DISP_CHANGE_SUCCESSFUL
        print GetResource(dcSUCCESSFUL)
    case DISP_CHANGE_BADDUALVIEW
        print GetResource(dcBADDUALVIEW)
    case DISP_CHANGE_BADFLAGS
        print GetResource(dcBADFLAGS)
    case DISP_CHANGE_BADMODE
        print GetResource(dcBADMODE)
    case DISP_CHANGE_BADPARAM
        print GetResource(dcBADPARAM)
    case DISP_CHANGE_FAILED
        print GetResource(dcFAILED)
    case DISP_CHANGE_NOTUPDATED
        print GetResource(dcNOTUPDATED)
    case DISP_CHANGE_RESTART
        print GetResource(dcRESTART)
    case else
        print GetResource(dcUNKNOWN)
end select



