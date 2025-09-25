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

sub ErrPage(byval code as integer)
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
    	end code
    elseif code = 100 then
        PrintError(GetResource(WRONG_NUMBER))
		print    	
    	end code    	
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
        end 0
    case DISP_CHANGE_BADDUALVIEW
        PrintError(GetResource(dcBADDUALVIEW))
        end 102
    case DISP_CHANGE_BADFLAGS
        PrintError(GetResource(dcBADFLAGS))
        end 103
    case DISP_CHANGE_BADMODE
        PrintError(GetResource(dcBADMODE))
        end 104
    case DISP_CHANGE_BADPARAM
        PrintError(GetResource(dcBADPARAM))
        end 105
    case DISP_CHANGE_FAILED
        PrintError(GetResource(dcFAILED))
        end 106
    case DISP_CHANGE_NOTUPDATED
        PrintError(GetResource(dcNOTUPDATED))
        end 107
    case DISP_CHANGE_RESTART
        PrintError(GetResource(dcRESTART))
        end 108
    case else
        PrintError(GetResource(dcUNKNOWN))
        end 150
end select



