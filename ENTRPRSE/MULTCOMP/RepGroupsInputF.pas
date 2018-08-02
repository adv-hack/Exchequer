unit RepGroupsInputF;

// Contains the Groups Report

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, TEditVal, TCustom, ExtCtrls, ANIMATE, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler, BorBtns;

type
  TfrmGroupsReportFilter = class(TForm)
    Bevel1: TBevel;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    Label81: Label8;
    edtGroupFrom: Text8Pt;
    Label82: Label8;
    edtGroupTo: Text8Pt;
    chkCompanyPaths: TBorCheck;
    chkShowPwords: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FFromGroup, FToGroup : ShortString;

    Procedure SetGroup (Index : Integer; Value : ShortString);
  public
    { Public declarations }
    Property FromGroup : ShortString Index 1 Read FFromGroup Write SetGroup;
    Property ToGroup : ShortString Index 2 Read FToGroup Write SetGroup;
  end;


// Prints the Groups Report
Procedure PrintGroupsReport (Const ParentForm : TForm; Const DefaultGroup : ShortString);


implementation

{$R *.dfm}

Uses GlobVar, VarConst, BtrvU2,
     GroupsFile,      // Definition of Groups.Dat (GroupF) and utility functions
     PrintToF,        // Generic Select Printer dialog
     RepGroups,       // Implementation of Groups Report
     RpDevice,        // RpDev printer info object and TSBSPrintSetupInfo structure
     SavePos,         // TBtrieveSavePosition
     BTKeys1U, BTSupU1;

//=========================================================================

// Prints the Groups Report
Procedure PrintGroupsReport (Const ParentForm : TForm; Const DefaultGroup : ShortString);
Var
  frmGroupsReportFilter : TfrmGroupsReportFilter;
  PrintJobInfo          : TSBSPrintSetupInfo;
Begin // PrintGroupsReport
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (GroupF, GetPosKey);
      SaveDataBlock (@GroupFileRec, SizeOf(GroupFileRec));

      //------------------------------

      frmGroupsReportFilter := TfrmGroupsReportFilter.Create(ParentForm);
      Try
        frmGroupsReportFilter.FromGroup := DefaultGroup;
        frmGroupsReportFilter.ToGroup := DefaultGroup;

        If (frmGroupsReportFilter.ShowModal = mrOk) Then
        Begin
          // Show Select Printer dialog
          If ShowPrintTo (ParentForm, 'Print Groups Report To', PrintJobInfo) Then
          Begin
            GenerateGroupsReport (ParentForm,
                                  PrintJobInfo,
                                  frmGroupsReportFilter.FromGroup,
                                  frmGroupsReportFilter.ToGroup,
                                  frmGroupsReportFilter.chkCompanyPaths.Checked,
                                  frmGroupsReportFilter.chkShowPwords.Checked);
          End;
        End; // If (frmGroupsReportFilter.ShowModal = mrOk)
      Finally
        FreeAndNIL(frmGroupsReportFilter);
      End; // Try..Finally

      //------------------------------

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (@GroupFileRec);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // PrintGroupsReport

//=========================================================================

procedure TfrmGroupsReportFilter.FormCreate(Sender: TObject);
begin
  // Define the maximum lengths of the Group From and To fields
  edtGroupFrom.MaxLength := GroupCodeLen;
  edtGroupTo.MaxLength := GroupCodeLen;
end;

//-------------------------------------------------------------------------

Procedure TfrmGroupsReportFilter.SetGroup (Index : Integer; Value : ShortString);
Begin // SetGroup
  Case Index Of
    1 : Begin
          FFromGroup := Trim(Value);
          edtGroupFrom.Text := FFromGroup;
        End;
    2 : Begin
          FToGroup := Trim(Value);
          edtGroupTo.Text := FToGroup;
        End;
  End; // Case Index
End; // SetGroup

//-------------------------------------------------------------------------

procedure TfrmGroupsReportFilter.btnOKClick(Sender: TObject);
Var
  OK : Boolean;
begin
  // Validate the From Group
  FFromGroup := FullGroupCodeKey(edtGroupFrom.Text);
  OK := (Trim(FFromGroup) = '') Or GroupCodeExists(FFromGroup);
  If (Not OK) Then
  Begin
    MessageDlg ('The From Group code is invalid', mtError, [mbOK], 0);
    If edtGroupFrom.CanFocus Then
    Begin
      edtGroupFrom.SetFocus;
    End; // If edtGroupFrom.CanFocus
  End; // If (Not OK)

  If OK Then
  Begin
    // Validate the To Group
    FToGroup := FullGroupCodeKey(edtGroupTo.Text);
    OK := (Trim(FToGroup) = '') Or GroupCodeExists(FToGroup);
    If (Not OK) Then
    Begin
      MessageDlg ('The To Group code is invalid', mtError, [mbOK], 0);
      If edtGroupTo.CanFocus Then
      Begin
        edtGroupTo.SetFocus;
      End; // If edtGroupTo.CanFocus
    End; // If (Not OK)
  End; // If OK

  If OK Then
  Begin
    // Check From Group <= To Group
    OK := (FFromGroup <= FToGroup) Or (Trim(FToGroup) = '');
    If (Not OK) Then
    Begin
      MessageDlg ('The To Group code must be the same as or alphabetically greater than the From Group code', mtError, [mbOK], 0);
      If edtGroupTo.CanFocus Then
      Begin
        edtGroupTo.SetFocus;
      End; // If edtGroupTo.CanFocus
    End; // If (Not OK)
  End; // If OK

  If OK Then
  Begin
    ModalResult := mrOK;
  End; // If OK
end;

//-------------------------------------------------------------------------

end.
