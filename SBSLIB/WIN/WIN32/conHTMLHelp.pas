unit conHTMLHelp;
{Unit to translate WinHelp requests into HTML Help and call the API.}
{Functions from "Abstracting Runtime Queries from Code" article on Irongut's Delphi Pages
 Written by Dave Murray, October 2001. Irongut's Delphi Pages : http://www.paranoia.clara.net
 (C) 2001 - 2003 Conspiracy Software <conspiracysoftware@hotmail.com>}

interface

uses
    Windows, Messages, SysUtils, Forms;

const
    {commands to pass to HtmlHelp(), see HTML Help API Reference}
    HH_DISPLAY_TOPIC        = $0000; {open help topic}
    HH_HELP_FINDER          = $0000; {compatibility, use HH_DISPLAY_TOPIC}
    HH_DISPLAY_TOC          = $0001; {select Contents tab in nav pane}
    HH_DISPLAY_INDEX        = $0002; {select Index + search for keyword}
    HH_DISPLAY_SEARCH       = $0003; {select Search tab in nav pane}
    HH_SET_WIN_TYPE         = $0004;
    HH_GET_WIN_TYPE         = $0005;
    HH_GET_WIN_HANDLE       = $0006;
    HH_ENUM_INFO_TYPE       = $0007;
    HH_SET_INFO_TYPE        = $0008;
    HH_SYNC                 = $0009;
    HH_RESERVED1            = $000A; {not currently implemented}
    HH_RESERVED2            = $000B; {not currently implemented}
    HH_RESERVED3            = $000C; {not currently implemented}
    HH_KEYWORD_LOOKUP       = $000D;
    HH_DISPLAY_TEXT_POPUP   = $000E; {display string resource/text popup}
    HH_HELP_CONTEXT         = $000F; {display topic for context number}
    HH_TP_HELP_CONTEXTMENU  = $0010; {text popup, like HELP_CONTEXTMENU}
    HH_TP_HELP_WM_HELP      = $0011; {text popup, like HELP_WM_HELP}
    HH_CLOSE_ALL            = $0012; {close all windows opened by caller}
    HH_ALINK_LOOKUP         = $0013; {ALink version of HH_KEYWORD_LOOKUP}
    HH_GET_LAST_ERROR       = $0014; {not currently implemented}
    HH_ENUM_CATEGORY        = $0015;
    HH_ENUM_CATEGORY_IT     = $0016;
    HH_RESET_IT_FILTER      = $0017;
    HH_SET_INCLUSIVE_FILTER = $0018;
    HH_SET_EXCLUSIVE_FILTER = $0019;
    HH_INITIALIZE           = $001C;
    HH_UNINITIALIZE         = $001D;
    HH_PRETRANSLATEMESSAGE  = $00FD;
    HH_SET_GLOBAL_PROPERTY  = $00FC;

function HtmlHelp(hwndCaller: THandle; pszFile: PChar;
    uCommand: cardinal; dwData: longint): THandle; stdcall;

implementation

function HtmlHelp(hwndCaller: THandle; pszFile: PChar;
    uCommand: cardinal; dwData: longint): THandle; stdcall;
    external 'hhctrl.ocx' name 'HtmlHelpA'; {external API call}

type
    TconHTMLHelp = class(TObject) {encapsulates function}
        function ApplicationHelp(Command: Word; Data: Longint;
            var CallHelp: Boolean): Boolean;
    end; {TconHTMLHelp..}

function TconHTMLHelp.ApplicationHelp(Command: Word; Data: Longint;
    var CallHelp: Boolean): Boolean;
{translates WinHelp commands to HTMLHelp commands + calls API}
var
    HCommand : word;
begin
    {make sure VCL doesn't activate WinHelp + function succeeds}
    CallHelp := false;
    result := true;
    {translate WinHelp > HTMLHelp}
    case Command of
        HELP_CONTENTS : begin
            HCommand :=  HH_DISPLAY_TOC;
            Data := 0;
            end; {HELP_CONTENTS..}
        HELP_CONTEXT : HCommand := HH_HELP_CONTEXT;
        HELP_CONTEXTPOPUP : HCommand := HH_HELP_CONTEXT;
        HELP_FINDER : HCommand := HH_DISPLAY_TOPIC;
        HELP_KEY : HCommand := HH_DISPLAY_INDEX;
        HELP_QUIT : begin
        HCommand :=  HH_CLOSE_ALL;
        Data := 0;
        end; {HELP_QUIT..}
    else begin {default}
        HCommand := HH_DISPLAY_TOPIC;
        Data := 0;
        end; {default..}
    end; {case Command..}
    {call HTML Help API}

// MH 14/03/07: Modified as this was causing the window calling the help to go to the back when the
// help window was closed.
//    HtmlHelp(Application.MainForm.Handle, PChar(Application.HelpFile),
//            HCommand, Data);

// PR 23/08/07 In some circumstances, Screen.ActiveForm may be nil. Modified to check for this and use
// Application.MainForm if necessary.
    if Assigned(Screen.ActiveForm) then
      HtmlHelp(Screen.ActiveForm.Handle, PChar(Application.HelpFile),
               HCommand, Data)
    else
      HtmlHelp(Application.MainForm.Handle, PChar(Application.HelpFile),
              HCommand, Data);


end; {function TconHTMLHelp.ApplicationHelp}

var
   hhHelper: TconHTMLHelp;

initialization
    {create object + assign event handler}
    hhHelper := TconHTMLHelp.Create;
    Application.OnHelp := hhHelper.ApplicationHelp;
finalization
    {free event handler + object}
    Application.OnHelp := nil;
    hhHelper.Free;
end.