unit TreeSecurity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  COMObj, Enterprise01_TLB, CheckLst, Grids, ValEdit, RepTreeIF, EnterToTab;

type
  TfrmSecurity = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lblInfo: TLabel;
    vleUserRights: TValueListEditor;
    btnHideAll: TButton;
    btnShowAll: TButton;
    btnPrintAll: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure vleUserRightsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure btnHideAllClick(Sender: TObject);
    procedure btnShowAllClick(Sender: TObject);
    procedure btnPrintAllClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MaxSizeX : LongInt;
    MinSizeY : LongInt;

    FRTSecurity : IReportSecurity;

    Procedure SetRTSecurity (Value : IReportSecurity);

    // Sets all user permissions status's to the specified string
    procedure SetStatii (Const NewStatus : ShortString);

    // Control the minimum size that the form can resize to - works better than constraints
    procedure WMGetMinMaxInfo(var message  :  TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public
    { Public declarations }
    Property RTSecurity : IReportSecurity Read FRTSecurity Write SetRTSecurity;
  end;

// Displays the Group/Report Security dialog for defining user permissions
Function DisplayUserSecurity (Const ReportSecurity : IReportSecurity) : Boolean;

implementation

{$R *.dfm}

uses
  GlobalTypes, CTKUtil, IIFFuncs;

Const
  // The textual descriptions for the users permissions for groups and reports,
  // if blank the entry is ignored by the dialog
  PermissionsText : Array [TReportType, TReportPermissionType] Of ShortString =
                      (
                       ('Hide Group',  'Show Group',                 ''),
                       ('Hide Report', 'Allow Editing and Printing', 'Allow Printing Only')
                      );

//=========================================================================

// Displays the Group/Report Security dialog for defining user permissions
Function DisplayUserSecurity (Const ReportSecurity : IReportSecurity) : Boolean;
Begin // DisplayUserSecurity
  With TfrmSecurity.Create(Application.MainForm) Do
  Begin
    Try
      RTSecurity := ReportSecurity;
      Result := (ShowModal = mrOK);
    Finally
      Free;
    End; // Try..Finally
  End; // With TfrmSecurity.Create(Application.MainForm)
End; // DisplayUserSecurity

//=========================================================================

procedure TfrmSecurity.FormCreate(Sender: TObject);
begin
  FRTSecurity := NIL;

  ClientHeight := 173;
  ClientWidth := 459;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  //MinSizeX := (Width - ClientWidth) + 300;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 173;      // captions into account
  MaxSizeX := Width;
end;

//------------------------------

procedure TfrmSecurity.FormDestroy(Sender: TObject);
begin
  FRTSecurity := NIL;
end;

//------------------------------

procedure TfrmSecurity.FormResize(Sender: TObject);
begin
  btnOK.Left := ClientWidth - btnOK.Width - 5;
  btnCancel.Left := btnOK.Left;
  btnHideAll.Left := btnOK.Left;
  btnShowAll.Left := btnOK.Left;
  btnPrintAll.Left := btnOK.Left;

  vleUserRights.Height := ClientHeight - vleUserRights.Top - 5;
  vleUserRights.Width := btnOK.Left - vleUserRights.Left - 5;

  lblInfo.Width := vleUserRights.Width;
end;

//------------------------------

// Control the minimum size that the form can resize to - works better than constraints
procedure TfrmSecurity.WMGetMinMaxInfo(var message : TWMGetMinMaxInfo);
begin // WMGetMinMaxInfo
  If (MaxSizeX <> 0) Then
    with message.MinMaxInfo^ do
    begin
      ptMinTrackSize.X:=MaxSizeX;  // Use maxsize to disable horizontal resizing
      ptMinTrackSize.Y:=MinSizeY;

      ptMaxTrackSize.X:=MaxSizeX;
      ptMaxTrackSize.Y:=Trunc(Screen.Height * 0.9);
    end; // with message.MinMaxInfo^

  message.Result:=0;

  Inherited;
end; // WMGetMinMaxInfo

//-------------------------------------------------------------------------

// Use custom code instead of component as the component can't handle
// the Value List Editor correctly and I don't want to add 100k+ into
// the component
procedure TfrmSecurity.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If (Shift = []) And (Key = VK_RETURN) And (ActiveControl = vleUserRights) Then
  Begin
    If (vleUserRights.Row < (vleUserRights.RowCount - 1)) Then
    Begin
      // Move down a row
      Key := VK_DOWN;
    End // If (vleUserRights.Row < (vleUserRights.RowCount - 1)
    Else
    Begin
      // Last Row - Move to next control
      PostMessage(Handle,wm_NextDlgCtl,0,0);
      Key:=0;
    End; // Else
  End; // If (Shift = []) And (Key = VK_RETURN) And (ActiveControl = vleUserRights)
end;

procedure TfrmSecurity.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If ((Key = #13) Or (Key = #10)) And (ActiveControl = vleUserRights) Then
  Begin
    Key := #0;
  End; // If ((Key = #13) Or (Key = #10)) And ReplaceEntersForControl(ActiveControl)
end;

//-------------------------------------------------------------------------

procedure TfrmSecurity.vleUserRightsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
  sCurrValue : ShortString;
  iCurrIdx, iStartIdx, I : SmallInt;
begin
  If (vleUserRights.Row >= 0) And (vleUserRights.Row < vleUserRights.RowCount) Then
  Begin
    With vleUserRights.ItemProps[vleUserRights.Row] Do
    Begin
      If (PickList.Count > 0) Then
      Begin
        // Determine the start point of the search - if the typed character matches
        // the current row then start from the next row, else start from 0. Also
        // start from 0 if on the last row
        sCurrValue := vleUserRights.Cells[1, vleUserRights.Row];
        iCurrIdx := PickList.IndexOf(sCurrValue);
        If (iCurrIdx >= 0) And (iCurrIdx < (PickList.Count - 1)) And ((sCurrValue+' ')[1] = Chr(Key)) Then
          iStartIdx := iCurrIdx + 1
        Else
          iStartIdx := 0;

        For I := iStartIdx To (PickList.Count - 1) Do
        Begin
          If (PickList.Strings[I][1] = Chr(Key)) Then
          Begin
            vleUserRights.Cells[2, vleUserRights.Row] := PickList.Strings[I];
            Break;
          End; // If (PickList.Strings[I][1] = Chr(Key))
        End; // For I
      End; // If (PickList.Count > 0)
    End; // With vleUserRights.ItemProps[vleUserRights.Row].PickList
  End; // If (vleUserRights.Row >= 0) And (vleUserRights.Row < vleUserRights.RowCount) en
end;

//-------------------------------------------------------------------------

Procedure TfrmSecurity.SetRTSecurity (Value : IReportSecurity);
Var
  iPerm   : TReportPermissionType;
  iUser   : SmallInt;
  lHeight : LongInt;
Begin // SetRTSecurity
  FRTSecurity := Value;

  If (FRTSecurity.rsType = rtGroup) Then
  Begin
    Caption := 'Report Group Security: ';
    lblInfo.Caption := 'The users shown below can see the section of the Report Tree containing this Group, use the list to set the Group permissions for each user:-'
  End // If (FRTSecurity.rsType = rtGroup)
  Else
  Begin
    Caption := 'Report Security: ';
    lblInfo.Caption := 'The users shown below can see the section of the Report Tree containing this Report, use the list to set the Report permissions for each user:-'
  End; // Else
  Caption := Caption + Trim(FRTSecurity.rsReportCode) + ' - ' + Trim(FRTSecurity.rsReportDesc);

  btnPrintAll.Visible := (FRTSecurity.rsType = rtReport);

  If (FRTSecurity.rsPermittedUserCount > 0) Then
  Begin
    vleUserRights.Strings.Clear;

    For iUser := 0 To (FRTSecurity.rsPermittedUserCount - 1) Do
    Begin
      vleUserRights.Strings.Add (FRTSecurity.rsPermittedUsers[iUser].ursName + '=' + PermissionsText[FRTSecurity.rsType, FRTSecurity.rsPermittedUsers[iUser].ursPermission]);

      If (vleUserRights.RowCount = 1) Then
      Begin
        With vleUserRights.ItemProps[0] Do
        Begin
          EditStyle := esPickList;
          ReadOnly := True;
          For iPerm := Low(TReportPermissionType) To High(TReportPermissionType) Do
          Begin
            If (PermissionsText[FRTSecurity.rsType, iPerm] <> '') Then
            Begin
              PickList.Add(PermissionsText[FRTSecurity.rsType, iPerm]);
            End; // If (PermissionsText[FRTSecurity.rsType, iPerm] <> '')
          End; // For iPerm
        End; // With ItemProps[0]
      End // If (vleUserRights.RowCount = 1)
      Else
      Begin
        With vleUserRights.ItemProps[vleUserRights.RowCount - 1] Do
        Begin
          EditStyle := esPickList;
          ReadOnly := True;
          PickList.Assign(vleUserRights.ItemProps[0].PickList);
        End; // With vleUserRights.ItemProps[vleUserRights.RowCount - 1]
      End; // Else
    End; // For iUser

    vleUserRights.Row := 0;
    vleUserRights.Col := 1;

    // Intelligently? set the height
    lHeight := (vleUserRights.DefaultRowHeight * vleUserRights.RowCount) + vleUserRights.RowCount + 3;
    If (lHeight > (Screen.Height * 0.7)) Then lHeight := Trunc(Screen.Height * 0.7);
    Height := Self.Height + (lHeight - vleUserRights.Height);
//    If (Height < MinSizeY) Then Height := MinSizeY;
  End; // If (FRTSecurity.rsPermittedUserCount > 0)
End; // SetRTSecurity

//-------------------------------------------------------------------------

procedure TfrmSecurity.btnOKClick(Sender: TObject);
Var
  iPermission : TReportPermissionType;
  iRow        : SmallInt;
  bOneVisible : Boolean;
begin
  // Run through the list copying the permissions back into the object
  // and then save them, ensure at least one user can see the item
  bOneVisible := False;
  If (vleUserRights.RowCount > 0) Then
  Begin
    For iRow := 0 To (vleUserRights.RowCount - 1) Do
    Begin
      // Identify the permission type
      For iPermission := High(TReportPermissionType) DownTo Low(TReportPermissionType) Do
      Begin
        If (PermissionsText[FRTSecurity.rsType, iPermission] = vleUserRights.Cells[1, iRow]) Then
        Begin
          Break;
        End; //
      End; // For iPermission

      FRTSecurity.rsPermittedUsersByName [vleUserRights.Cells[0, iRow]].ursPermission := iPermission;

      If (iPermission <> rptHidden) Then bOneVisible := True;
    End; // For iRow

    If bOneVisible Then
    Begin
      // Save the changes any errors will be handled within the Save method
      FRTSecurity.Save;

      ModalResult := mrOK;
    End // If bOneVisible
    Else
      MessageDlg ('At least one user must be allowed to see each Group and Report',
                  mtError, [mbOK], 0);
  End; // If (vleUserRights.RowCount > 0)
end;

//-------------------------------------------------------------------------


// Sets all user permissions status's to the specified string
procedure TfrmSecurity.SetStatii (Const NewStatus : ShortString);
Var
  iRow : SmallInt;
begin
  If (vleUserRights.RowCount > 0) Then
  Begin
    For iRow := 0 To (vleUserRights.RowCount - 1) Do
    Begin
      vleUserRights.Cells[1, iRow] := NewStatus;
    End; // For iRow
  End; // If (vleUserRights.RowCount > 0)
end;

//------------------------------

procedure TfrmSecurity.btnHideAllClick(Sender: TObject);
begin
  SetStatii (PermissionsText[FRTSecurity.rsType, rptHidden]);
end;

//------------------------------

procedure TfrmSecurity.btnShowAllClick(Sender: TObject);
begin
  SetStatii (PermissionsText[FRTSecurity.rsType, rptShowEdit]);
end;

//------------------------------

procedure TfrmSecurity.btnPrintAllClick(Sender: TObject);
begin
  SetStatii (PermissionsText[FRTSecurity.rsType, rptPrintOnly]);
end;

//-------------------------------------------------------------------------

end.
