unit WStationSetupF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, TEditVal;

type
  TfrmWorkstationSetup = class(TSetupTemplate)
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DisplayWorkstationSetupQuery (var DLLParams: ParamRec): LongBool; StdCall;

implementation

{$R *.dfm}

Uses Brand, CompUtil;

//=========================================================================

function DisplayWorkstationSetupQuery (var DLLParams: ParamRec): LongBool;
var
  frmWorkstationSetup      : TfrmWorkstationSetup;
  DlgPN, W_PrevPC, WiseStr : String;
Begin // DisplayWorkstationSetupQuery
  Result := False;

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', WiseStr);
  Application.HelpFile := IncludeTrailingPathDelimiter(WiseStr) + 'SETUP.HLP';

  frmWorkstationSetup := TfrmWorkstationSetup.Create(Application);
  Try
    With frmWorkstationSetup Do
    Begin
      // Load in the default/previous group
      ModifyCaptions ('<APPTITLE>', Branding.pbProductName, [InstrLbl]);

      ShowModal;

      Case ExitCode Of
        { Back }
        'B' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));

        { Next }
        'N' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

        { Exit Installation }
        'X' : SetVariable(DLLParams,'DIALOG','999')
      End; { If }
    End; // With frmWorkstationSetup
  Finally
    FreeAndNIL(frmWorkstationSetup);
  End;
End; // DisplayWorkstationSetupQuery

//=========================================================================

end.
