unit BaseF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, StrUtils, EnterToTab;

type
  TfrmCommonBase = class(TForm)
    shBanner: TShape;
    lblBanner: TLabel;
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Procedure WMSysCommand(Var Message : TMessage); Message WM_SysCommand;
  public
    { Public declarations }
    Procedure ModifyCaptions (Const SearchText, ReplaceText : ShortString; Controls : Array of TControl);
  end;

var
  frmCommonBase: TfrmCommonBase;

implementation

{$R *.dfm}

Uses StrUtil, History;

Const
  CM_About   = $F0;

//=========================================================================

procedure TfrmCommonBase.FormCreate(Sender: TObject);
Var
  SysMenuH : HWnd;
begin
  SysMenuH:=GetSystemMenu(Handle,False);
  AppendMenu(SysMenuH,MF_SEPARATOR,0,'');
  AppendMenu(SysMenuH,MF_String,CM_About,'About...');
end;

//-------------------------------------------------------------------------

Procedure TfrmCommonBase.WMSysCommand(Var Message : TMessage);
Var
  MsgText : ANSIString;
Begin // WMSysCommand
  If (Message.WParam = CM_About) Then
  Begin
    MsgText := Application.Title + '  (' + ConversionVersion + ')'#13 + GetCopyrightMessage;
    Application.MessageBox (PCHAR(MsgText), 'About...', 0);
    Inherited
  End // If (Message.WParam = CM_About)
  Else If (Message.WParam = SC_MINIMIZE) Then
  Begin
    // This is needed to get the window to minimize to the task bar instead of the desktop
    Application.Minimize;
    Message.Result := 0;
  End // If (Message.WParam = SC_MINIMIZE)
  Else
    Inherited;
End; // WMSysCommand

//-------------------------------------------------------------------------

Procedure TfrmCommonBase.ModifyCaptions (Const SearchText, ReplaceText : ShortString; Controls : Array of TControl);
Var
  I : Integer;
Begin // ModifyCaptions
  For I := Low(Controls) To High(Controls) Do
  Begin
    If (Controls[I] Is TLabel) Then
      With Controls[I] As TLabel Do Caption := ANSIReplaceStr(Caption, SearchText, ReplaceText)
    Else If (Controls[I] Is TButton) Then
      With Controls[I] As TButton Do Caption := ANSIReplaceStr(Caption, SearchText, ReplaceText)
    Else If (Controls[I] Is TRadioButton) Then
      With Controls[I] As TRadioButton Do Caption := ANSIReplaceStr(Caption, SearchText, ReplaceText)
    Else If (Controls[I] Is TCheckBox) Then
      With Controls[I] As TCheckBox Do Caption := ANSIReplaceStr(Caption, SearchText, ReplaceText)
    {$IFNDEF ENTSETUP}
    Else
      ShowMessage ('TSetupTemplate.ModifyCaptions: Unknown Control Type "' + Controls[I].ClassName + '" for control ' + Controls[I].Name);
    {$ENDIF}
  End; // For I
End; // ModifyCaptions

//-------------------------------------------------------------------------

// Display message to allow AQTime to get the results - required for memory allocation profiler
//Procedure DisplayResultsMsg;
//Var
//  lpText, lpCaption: ANSIString;
//Begin // DisplayResultsMsg
//  lpCaption := '*** DEBUG ***';
//  lpText := 'Get Results Now';
//  MessageBox(0, PCHAR(lpText), PCHAR(lpCaption), MB_OK);
//End; //

//=========================================================================


Initialization
Finalization
  // Display message to allow AQTime to get the results - required for memory allocation profiler
  //DisplayResultsMsg;
end.
