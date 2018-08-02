unit UcTestF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmUCountTest = class(TForm)
    lvUCounts: TListView;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lstCID: TComboBox;
    btnAddLoginRef: TButton;
    lvCompanies: TListView;
    lstWID: TComboBox;
    lstUID: TComboBox;
    btnLogout: TButton;
    btnResetCIDCounts: TButton;
    lvLicence: TListView;
    LabelSys: TLabel;
    lstSysId: TComboBox;
    Timer1: TTimer;
    btnRefresh: TButton;
    btnClose: TButton;
    btnAutoRefresh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAddLoginRefClick(Sender: TObject);
    procedure lvCompaniesDblClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure lvUCountsDblClick(Sender: TObject);
    procedure btnResetCIDCountsClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnAutoRefreshClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    Function GetSysId : Char;
    procedure LoadCompF(Const Mode : Byte);
    procedure LoadUserCounts;
  public
    { Public declarations }
  end;

var
  frmUCountTest: TfrmUCountTest;

implementation

{$R *.DFM}

Uses BtrvU2, GlobVar, VarConst, ETStrU, ETDateU, ETMiscU, BtKeys1U, BtSupU1,
     VarFPosU, UserSec, CompId, ChkComp, APIUtil;

procedure TfrmUCountTest.FormCreate(Sender: TObject);
begin
  lstWID.Text := WinGetComputerName;
  lstUID.Text := WinGetUserName;

  lstSysId.Items.Add ('U - Exchequer');
  lstSysId.Items.Add ('T - Toolkit');
  lstSysId.Items.Add ('R - Trade Counter');
  lstSysId.ItemIndex := 0;

  GroupBox1.Visible := FileExists ('C:\{9F7498F9-C695-4FDC-803B-08B07E416C9D}.TMP');

  LoadCompF(0);
end;

procedure TfrmUCountTest.LoadCompF(Const Mode : Byte);
Var
  KeyS           : Str255;
  LStatus, Res   : LongInt;
  oAnal          : SmallInt;
begin
  If (Mode = 0) Then Begin
    lvCompanies.Items.Clear;
    lstCID.Items.Clear;
  End; { If (Mode = 0) }
  lvUCounts.Items.Clear;

  { Load Company Records into listview }
  LStatus := Find_Rec(B_StepFirst, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
  While (LStatus = 0) Do Begin
    Case Company^.RecPFix Of
      cmCompDet   : If (Mode = 0) Then
                      With Company^.CompDet Do Begin
                        If (lstCID.Text = '') Then
                          lstCID.Text := IntToStr(CompId);

                        If (lstCID.Items.IndexOf (IntToStr(CompId) ) = -1) Then
                          lstCID.Items.Add (IntToStr(CompId));

                        oAnal := Company^.CompDet.CompAnal;
                        CheckCompanyDir (Company^.CompDet);
                        With lvCompanies.Items.Add, Company^.CompDet Do Begin
                          Caption := CompCode;
                          SubItems.Add (Trim(CompName));
                          SubItems.Add (IntToStr(CompId));
                          SubItems.Add (Format ('%d (%d)', [CompAnal, oAnal]));
                          SubItems.Add (IntToStr(CompUCount));
                          SubItems.Add (IntToStr(CompTKUCount));
                          SubItems.Add (IntToStr(CompTrdUCount));
                          SubItems.Add (Trim(CompPath));
                        End; { With lvCompanies... }
                      End; { With Company^.CompDet }

      cmSetup     : { Setup Record - Ignore } ;

      cmTKUserCount,
      cmTradeUserCount,
      cmUserCount : With lvUCounts.Items.Add, Company^, UserRef Do Begin
                      { Company Id that User is logged into }
                      Caption := IntToStr(ucCompanyId);

                      { Computer Name that user is logged in on }
                      SubItems.Add(Trim(ucWstationId));

                      { Windows User Name that user is logged in on }
                      SubItems.Add(Trim(ucUserId));

                      { UserCount increased by this record }
                      SubItems.Add (IntToStr(ucRefCount));

                      // System Id for User Count XRef record
                      SubItems.Add (RecPFix);

                      { Indexing shit }
                      SubItems.Add ('ucCode >' + Trim(UcCode) +
                                    '<  ucName >' + Trim (ucName) +
                                    '<  ucPath >' + Trim (ucPath) + '<');
                    End; { With }
    End; { Case Company^.RecPFix }

    LStatus := Find_Rec(B_StepNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
  End; { While (LStatus = 0) }

  LoadUserCounts;
end;

// Double-Clicked on Company - Set seclected company Id into List
procedure TfrmUCountTest.lvCompaniesDblClick(Sender: TObject);
begin
 If (lstCID.Items.IndexOf (lvCompanies.Selected.SubItems[1]) >= 0) Then
   lstCID.ItemIndex := lstCID.Items.IndexOf (lvCompanies.Selected.SubItems[1]);
end;

// Update the form with the Current User Count Licence and Used totals
procedure TfrmUCountTest.LoadUserCounts;
Var
  TotalLic, CurrUsed, TotUsers : SmallInt;
  Res                          : LongInt;
begin
  lvLicence.Items.Clear;

  { Enterprise Licence and Login Details }
  With lvLicence.Items.Add Do Begin
    Caption := 'Exchequer';
    Res := GetCurrentUserCounts (cmUserCount, TotalLic, CurrUsed);
    If (Res = 0) Then Begin
      SubItems.Add (IntToStr(TotalLic));
      SubItems.Add (IntToStr(CurrUsed));
    End { If (Res = 0) }
    Else
      SubItems.Add ('Error ' + IntToStr(Res));
  End; { With lvLicence.Items.Add }

  { Toolkit Licence and Login Details }
  With lvLicence.Items.Add Do Begin
    Caption := 'Toolkit';
    Res := GetCurrentUserCounts (cmTKUserCount, TotalLic, CurrUsed);
    If (Res = 0) Then Begin
      SubItems.Add (IntToStr(TotalLic));
      SubItems.Add (IntToStr(CurrUsed));
    End { If (Res = 0) }
    Else
      SubItems.Add ('Error ' + IntToStr(Res));
  End; { With lvLicence.Items.Add }

  { Toolkit Licence and Login Details }
  With lvLicence.Items.Add Do Begin
    Caption := 'Trade Counter';
    Res := GetCurrentUserCounts (cmTradeUserCount, TotalLic, CurrUsed);
    If (Res = 0) Then Begin
      SubItems.Add (IntToStr(TotalLic));
      SubItems.Add (IntToStr(CurrUsed));
    End { If (Res = 0) }
    Else
      SubItems.Add ('Error ' + IntToStr(Res));
  End; { With lvLicence.Items.Add }
end;

Function TfrmUCountTest.GetSysId : Char;
Begin { GetSysId }
  If (lstSysId.ItemIndex >= 0) Then
    Result := lstSysId.Items[lstSysId.ItemIndex][1]
  Else
    Raise Exception.Create ('Invalid System Id');
End; { GetSysId }

// Add a Login Reference to the MCM DB using info from the Text Box
procedure TfrmUCountTest.btnAddLoginRefClick(Sender: TObject);
Var
  CompanyId, Res : LongInt;
begin
  // Add User Count Entry
  CompanyId := StrToInt (lstCID.Text);
  Res := AddLoginRef (GetSysId, CompanyId, lstWID.Text, lstUID.Text);
  ShowMessage ('AddLoginRef: ' + IntToStr(Res));

  // Recalc User Count info
  LoadUserCounts;
  LoadCompF(1);
end;

// Simulate a Logout
procedure TfrmUCountTest.btnLogoutClick(Sender: TObject);
Var
  CompanyId, Res : LongInt;
begin
  // Remove existing User Count Entry
  CompanyId := StrToInt (lstCID.Text);
  Res := RemoveLoginRef (GetSysId, CompanyId, lstWID.Text, lstUID.Text);
  ShowMessage ('RemoveLoginRef: ' + IntToStr(Res));

  // Recalc User Count info
  LoadUserCounts;
  LoadCompF(1);
end;

procedure TfrmUCountTest.lvUCountsDblClick(Sender: TObject);
Var
  I : Byte;
begin
 If Assigned(lvUCounts.Selected) Then
   With lvUCounts.Selected Do Begin
     lstCID.Text := Caption;
     lstWID.Text := SubItems[0];
     lstUID.Text := SubItems[1];

     For I := 0 To lstSysId.Items.Count - 1 Do
     Begin
       If (lstSysId.Items[I][1] = SubItems[3]) Then
       Begin
         lstSysId.ItemIndex := I;
         Break;
       End; // If (lstSysId.Items[I][1] = SubItems[3])
     End; // For I
   End; { With lvUCounts.Selected  }
end;

procedure TfrmUCountTest.btnResetCIDCountsClick(Sender: TObject);
Var
  CompanyId, Res : LongInt;
begin
  // Remove existing User Count Entry
  CompanyId := StrToInt (lstCID.Text);
  Res := RemoveCIDLoginRef (CompanyId);
  ShowMessage ('RemoveCIDLoginRef: ' + IntToStr(Res));

  // Recalc User Count info
  LoadUserCounts;
  LoadCompF(1);
end;

procedure TfrmUCountTest.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  LoadCompF(0);
  Timer1.Enabled := True;
end;

procedure TfrmUCountTest.btnRefreshClick(Sender: TObject);
begin
  LoadCompF(0);
end;

procedure TfrmUCountTest.btnAutoRefreshClick(Sender: TObject);
begin
  If Timer1.Enabled Then
  Begin
    // Stop Auto-Refresh
    Timer1.Enabled := False;
    btnAutoRefresh.Caption := 'Start Auto-Refresh';
  End //
  Else
  Begin
    // Start Auto-Refresh
    Timer1.Enabled := True;
    btnAutoRefresh.Caption := 'Stop Auto-Refresh';
  End; // Else
end;

procedure TfrmUCountTest.btnCloseClick(Sender: TObject);
begin
  Timer1.Enabled := False;
  PostMessage (Self.Handle, WM_Close, 0, 0);
end;

end.
