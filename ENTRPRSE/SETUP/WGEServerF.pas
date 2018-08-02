unit WGEServerF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, TEditVal;

type
  TfrmWorkgroupServerWarning = class(TSetupTemplate)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DisplayWGEServerWarning (var DLLParams: ParamRec): LongBool; StdCall;

implementation

{$R *.dfm}

//=========================================================================

function DisplayWGEServerWarning (var DLLParams: ParamRec): LongBool;
var
  frmWorkgroupServerWarning : TfrmWorkgroupServerWarning;
  DlgPN, W_PrevPC, WiseStr : String;
Begin // DisplayWGEServerWarning
  Result := False;

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', WiseStr);
  Application.HelpFile := IncludeTrailingPathDelimiter(WiseStr) + 'SETUP.HLP';

  frmWorkgroupServerWarning := TfrmWorkgroupServerWarning.Create(Application);
  Try
    With frmWorkgroupServerWarning Do
    Begin
      // Load in the default/previous group
      GetVariable(DLLParams, 'WG_PREVSERVERPC', W_PrevPC);
      ModifyCaptions ('<WG_PREVSERVERPC>', W_PrevPC, [Label1]);

      ShowModal;

      Case ExitCode Of
        { Back }
        'B' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));

        { Next }
        'N' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

        { Exit Installation }
        'X' : SetVariable(DLLParams,'DIALOG','999')
      End; { If }
    End; // With frmWorkgroupServerWarning
  Finally
    FreeAndNIL(frmWorkgroupServerWarning);
  End;
End; // DisplayWGEServerWarning

//=========================================================================

end.
