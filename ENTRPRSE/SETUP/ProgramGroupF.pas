unit ProgramGroupF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, ComCtrls;

type
  TfrmSelectProgramGroup = class(TSetupTemplate)
    edtGroup: TEdit;
    lstExistingGroups: TListBox;
    procedure lstExistingGroupsClick(Sender: TObject);
  private
    { Private declarations }
    Function ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
  end;

function SelectGroup (var DLLParams: ParamRec): LongBool; StdCall;

implementation

{$R *.dfm}

Uses Brand, CompUtil, ProgramGroups;

//=========================================================================

function SelectGroup (var DLLParams: ParamRec): LongBool;
var
  frmSelectProgramGroup   : TfrmSelectProgramGroup;
  ExistingGroups          : TProgramGroups;
  DlgPN, W_Group, WiseStr : String;
Begin // SelectGroup
  Result := False;

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', WiseStr);
  Application.HelpFile := IncludeTrailingPathDelimiter(WiseStr) + 'SETUP.HLP';

  frmSelectProgramGroup := TfrmSelectProgramGroup.Create(Application);
  Try
    With frmSelectProgramGroup Do
    Begin
      // Load in the existing program groups for the user to select from
      ExistingGroups := TProgramGroups.Create;
      Try
        lstExistingGroups.Items.Assign(ExistingGroups.ProgramGroups);
      Finally
        FreeAndNIL(ExistingGroups);
      End; // Try..Finally

      // Load in the default/previous group
      GetVariable(DLLParams, 'V_GROUP', W_Group);
      edtGroup.Text := W_Group;

      ShowModal;

      Case ExitCode Of
        { Back }
        'B' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));

        { Next }
        'N' : Begin
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                { Save details to Wise Script }
                SetVariable(DLLParams,'V_GROUP', edtGroup.Text);
              End;

        { Exit Installation }
        'X' : SetVariable(DLLParams,'DIALOG','999')
      End; { If }
    End; // With frmWelcome
  Finally
    FreeAndNIL(frmSelectProgramGroup);
  End;
End; // SelectGroup

//=========================================================================

procedure TfrmSelectProgramGroup.lstExistingGroupsClick(Sender: TObject);
begin
  inherited;

  If (lstExistingGroups.ItemIndex >= 0) Then
  Begin
    edtGroup.Text := lstExistingGroups.Items[lstExistingGroups.ItemIndex];
  End; // If (lstExistingGroups.ItemIndex >= 0)
end;

//-------------------------------------------------------------------------

function TfrmSelectProgramGroup.ValidOk(VCode: Char): Boolean;
begin
  If (VCode = 'N') Then
  Begin
    // Check that the group is set
    Result := (edtGroup.Text <> '');
    If (Not Result) Then
    Begin
      MessageDlg ('The Group Name for the Icons must be set', mtError, [mbOk], 0);
    End; // If (Not Result)
  End // If (VCode = 'N')
  Else
    Result := True;
end;

//=========================================================================

end.
