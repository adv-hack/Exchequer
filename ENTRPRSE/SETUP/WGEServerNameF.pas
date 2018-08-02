unit WGEServerNameF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, TEditVal;

type
  TfrmServerPCName = class(TSetupTemplate)
    Label1: TLabel;
    lstServerName: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


// Called from the WGEServer.Exe setup program to ask the user for the name of the
// Pervasive.SQL Workgroup Engine Server PC
function GetServerPCName (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses APIUtil;

// Called from the WGEServer.Exe setup program to ask the user for the name of the
// Pervasive.SQL Workgroup Engine Server PC.  Returns TRUE if successful else FALSE
function GetServerPCName (var DLLParams: ParamRec): LongBool;
Var
  frmServerPCName      : TfrmServerPCName;
  WG_ServerPC, ThisPC  : ANSIString;
Begin // GetServerPCName
  Result := False;

  frmServerPCName := TfrmServerPCName.Create(Application);
  Try
    // Import current Server PC Name from setup
    GetVariable(DLLParams, 'WG_SERVERPC', WG_ServerPC);

    frmServerPCName.lstServerName.Clear;
    frmServerPCName.lstServerName.Items.Add(WG_ServerPC);
    frmServerPCName.lstServerName.ItemIndex := 0;

    ThisPC := WinGetComputerName;
    If (Trim(UpperCase(ThisPC)) <> Trim(UpperCase(WG_ServerPC))) Then
      frmServerPCName.lstServerName.Items.Add(ThisPC);

    frmServerPCName.ShowModal;
    If (frmServerPCName.ExitCode = 'N') Then
    Begin
      SetVariable(DLLParams,'WG_SERVERPC',frmServerPCName.lstServerName.Text);

      Result := True;
    End; // If (frmServerPCName.ExitCode = 'N')
  Finally
    FreeAndNIL(frmServerPCName);
  End; // Try..Finally
End; // GetServerPCName
 


end.
