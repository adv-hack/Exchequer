unit ReadLicF;

{ markd6 10:35 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, TEditVal, bkgroup, oLicence, FilCtl95, LicRec,
  ComCtrls, ShellCtrls2005, ExtCtrls, Buttons;

type
  TfrmReadLic = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    ShellTreeView20051: TShellTreeView2005;
    tvLicenceInfo: TTreeView;
    Splitter1: TSplitter;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ShellTreeView20051AddFolder(Sender: TObject;
      AFolder: TShellFolder; var CanAdd: Boolean);
    procedure ShellTreeView20051Change(Sender: TObject; Node: TTreeNode);
    procedure BitBtn1Click(Sender: TObject);
    procedure ShellTreeView20051Editing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
  private
    { Private declarations }
    FirstTime : Boolean;
    TempCDLic : CDLicenceRecType;
    FDefaultPath : ShortString;

    procedure CheckForLicence (LicencePath : ShortString);
    Procedure SetDefaultPath (Value : ShortString);
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
    OK : Boolean;
    Property DefaultPath : ShortString Read FDefaultPath Write SetDefaultPath;
  end;


implementation

{$R *.DFM}

Uses LicFuncU, SerialU, MainF, IssueU, StrUtils;



procedure TfrmReadLic.FormCreate(Sender: TObject);
begin
  Left := Application.MainForm.Left + ((Application.MainForm.Width - Self.Width) Div 2);
  Top := Application.MainForm.Top + ((Application.MainForm.Height - Self.Height) Div 2);

  OK := False;
  FirstTime := True;
  FDefaultPath := '';

  tvLicenceInfo.Items.Clear;  // Remove design time items

  // Initialise the local CD Licence to whatever is currently held in the global licence
  TempCDLic := CDLic;
end;

procedure TfrmReadLic.FormActivate(Sender: TObject);
begin
  If FirstTime Then Begin
    FirstTime := False;

    //DirectoryListBox1Change(Sender);
    CheckForLicence (ShellTreeView20051.Path);
  End; { If }
end;

procedure TfrmReadLic.btnCancelClick(Sender: TObject);
begin
  OK := False;
  Close;
end;

procedure TfrmReadLic.DirectoryListBox1Change(Sender: TObject);
Begin
End;

//-------------------------------------------------------------------------

procedure TfrmReadLic.CheckForLicence (LicencePath : ShortString);
Var
  LicInfo      : TEntLicence;
  OK           : Boolean;
  I, CDIssue   : SmallInt;
  DriveStr     : ShortString;
  oNode, oRoot : TTreeNode;
  SortList     : TStringList;
begin
  LicencePath := IncludeTrailingPathDelimiter (LicencePath);

  If DirectoryExists(LicencePath) And Self.Visible Then
  Begin
    OK := False;

    tvLicenceInfo.Items.Clear;

    If FileExists (LicencePath + LicFile) Then
    Begin
      LicInfo := TEntLicence.Create;
      Try
        LicInfo.SetExpiry := True;
        LicInfo.FileName := LicencePath + LicFile;

        OK := LicInfo.Valid;
        If OK Then
        Begin
          TempCDLic := LicInfo.EncLic;

          With LicInfo Do
          Begin
            { Check whether licence has expired, ... }
            If Expired Then Begin
              { Licence expired }
              OK := False;
              MessageDlg ('This Exchequer CD Licence has expired', mtError, [mbOk], 0);
            End; { If }

            { Check the Licence Version for all licences }
            If OK Then Begin
              { Check the Licence is the current version }
              OK := (Version = CurrLicVer);

              If (Not OK) Then
                MessageDlg ('This Exchequer CD Licence has expired, please contact your ' +
                            'Dealer or Distributor to get a new Licence', mtError, [mbOk], 0);
            End; { If OK }

// MH 24/04/07: Removed so we can have a single CD covering both editions
// MH 06/02/07: Re-instated for v6.00 SQL release to stop P.SQL licences being used

{$IFDEF SQLONLY}
            // MH 06/03/07: Check for Database Type
            If OK Then
            Begin
              //OK := (EntDBType = DBBtrieve);
              OK := (EntDBType = dbMSSQL);
              If (Not OK) Then
                MessageDlg ('This Exchequer CD Licence is for a different edition of Exchequer, please contact your ' +
                            'Dealer or Distributor to get a new Licence', mtError, [mbOk], 0);
            End; // If OK
{$ENDIF}

            { For Auto-Upgrades check the Issue Number }
            If OK And (InstType = 2) Then
            Begin
              { Auto-Upgrade - Check for Issue DLL }
              CDIssue := -1;
              OK := FileExists (ExtractFilePath(Application.ExeName) + 'Utils32.Dll');
              If OK Then Begin
                Try
                  CDIssue := ReadIssueNo (ExtractFilePath(Application.ExeName) + 'Utils32.Dll');
                  OK := (IssueNo = CDIssue);
                Except
                  On Exception Do Begin
                    OK := False;
                    CDIssue := -2;
                  End; { On }
                End;
              End; { If OK }

              If (Not OK) Then
                MessageDlg ('This Auto-Upgrade Licence (' + IntToStr(IssueNo) + ') is not valid for this CD Issue (' +
                            IntToStr(CDIssue) + ')', mtError, [mbOk], 0);
            End; { If OK And (InstType = 2) }

            { Check whether its the correct licence for this CD }
// MH 21/07/2014 v7.0.11 ABSEXCH-15467: Removed CD Serial Number Check.
//            If OK And (InstType <> 2) Then
//            Begin
//              DriveStr := GetDriveSerial (ExtractFileDrive(Application.ExeName)[1]);
//              If (DriveStr <> CDSerial) Then
//              Begin
//                { Wrong Serial Number }
//                OK := False;
//                MessageDlg ('This Licence is for another CD' + #13#13 + 'Licence: ' + CDSerial + ', CD: ' + DriveStr,
//                            mtError, [mbOk], 0);
//              End; // If (DriveStr <> CDSerial)
//            End; // If OK

            If OK Then
            Begin
              If (InstType <> 2) Then
              Begin
                // CD
                oRoot := tvLicenceInfo.Items.AddChild(Nil, 'Exchequer - ' + licDBToStr(EntDBType) + ' Edition');

                tvLicenceInfo.Items.AddChild(oRoot, 'CD Serial No - ' + CDSerial + ' - ' + licCountryStr (Country, True) + ' ' + licTypeToStr (InstType));

                tvLicenceInfo.Items.AddChild(oRoot, 'Company - ' + Company);

                // Composite version
                oNode := tvLicenceInfo.Items.AddChild(oRoot, 'Version - ' + licCurrVerToStr (CurrVer) + '/' + licEntModsToStr (BaseModules));
                //If (oNode.Text[Length(oNode.Text)] <> '/') Then oNode.Text := oNode.Text + '/';
                If (ClSvr = 1) Then oNode.Text := oNode.Text + '/CS';
                If (oNode.Text[Length(oNode.Text)] <> '/') Then oNode.Text := oNode.Text + '/';
                oNode.Text := oNode.Text + IntToStr(Users);

                // HM 19/11/12: Added SBE Support
                If (ExchequerEdition <>  eeStandard) Then
                Begin
                  tvLicenceInfo.Items.AddChild(oRoot, licExchequerEditionToStr (ExchequerEdition));
                End; // If (ExchequerEdition <>  eeStandard)

                // add number of licenced companies
                tvLicenceInfo.Items.AddChild(oRoot, 'Companies - ' + Inttostr(LicInfo.UserCounts[1]));

                // Database Engine
                If (ClSvrEng > 0) Or (PSQLWGE > 0) Then
                Begin
                  If (ClSvrEng > 0) Then
                    // Client-Server
                    tvLicenceInfo.Items.AddChild(oRoot, 'Database - ' + IfThen(ClSvrEng = 1, 'P.SQL NT', 'P.SQL Netware') + ' - ' + IntToStr(ClSvrUser) + ' User')
                  Else
                    // Workgroup
                    tvLicenceInfo.Items.AddChild(oRoot, 'Database - ' + licPSQLWGEVerToStr (PSQLWGE, False));
                End; // If (ClSvrEng > 0) Or (PSQLWGE > 0)

                // Modules
  //              oNode := tvLicenceInfo.Items.AddChild(Nil, 'No Additional Modules');
  //              For I := 1 To modLast Do
  //                If (Modules[I] > 0) Then
  //                  tvLicenceInfo.Items.AddChild(oNode, licModuleDescEx (True, I));
  //              If (oNode.Count > 0) Then
  //                oNode.Text := IntToStr(oNode.Count) + ' Additional Module' + IfThen(oNode.Count > 0, 's', '');

                // MH 09/01/06: Modified to sort modules into alphabetical order to make them easier to read
                SortList := TStringList.Create;
                Try
                  For I := 1 To modLast Do
                    If (Modules[I] > 0) Then
                      SortList.Add(licModuleDescEx (True, I));
                  If (SortList.Count > 0) Then
                  Begin
                    SortList.Sorted := True;
                    oNode := tvLicenceInfo.Items.AddChild(oRoot, IntToStr(SortList.Count) + ' Additional Module' + IfThen(SortList.Count > 0, 's', ''));
                    For I := 0 To (SortList.Count-1) Do
                      tvLicenceInfo.Items.AddChild(oNode, SortList.Strings[I]);
                  End // If (SortList.Count > 0)
                  Else
                    oNode := tvLicenceInfo.Items.AddChild(oRoot, 'No Additional Modules');
                Finally
                  SortList.Free;
                End; // Try..Finally
              End // If (InstType <> 2)
              Else Begin
                { Auto-Upgrade Licence }
                tvLicenceInfo.Items.AddChild(oRoot, 'Auto-Upgrade - ' + licDBToStr(EntDBType, True) + ' Edition');
              End; { Else }
            End; // If OK
          End; { With LicInfo }
        End // If OK
        Else
          { Invalid Licence File }
          MessageDlg (LicInfo.ValidErrStr, mtError, [mbOk], 0);
      Finally
        LicInfo.Destroy;
      End;
    End // If FileExists (LicencePath + LicFile)
    Else
      tvLicenceInfo.Items.AddChild(Nil, 'No Licence Found');

    If (tvLicenceInfo.Items.Count > 0) Then
    Begin
      tvLicenceInfo.FullExpand;
      tvLicenceInfo.Selected := tvLicenceInfo.Items[0];
    End; // If (tvLicenceInfo.Items.Count > 0)

    btnOK.Enabled := OK;
  End; { If }
end;

procedure TfrmReadLic.btnOKClick(Sender: TObject);
begin
  If btnOK.Enabled Then Begin
    CDLic := TempCDLic;
    OK := True;
    Close;
  End; { If }
end;


procedure TfrmReadLic.ShellTreeView20051AddFolder(Sender: TObject;
  AFolder: TShellFolder; var CanAdd: Boolean);
begin
  //Memo1.Lines.Add ('DisplayName: ' + AFolder.DisplayName + ', PathName: ' + AFolder.PathName);

  CanAdd := UpperCase(AFolder.DisplayName) <> 'CONTROL PANEL';
end;

procedure TfrmReadLic.ShellTreeView20051Change(Sender: TObject; Node: TTreeNode);
begin
  CheckForLicence (ShellTreeView20051.Path);
end;

//-------------------------------------------------------------------------

Procedure TfrmReadLic.SetDefaultPath (Value : ShortString);
Var
  TmpStr     : ShortString;
Begin // SetDefaultPath
  If (FDefaultPath <> Value) Then
  Begin
    FDefaultPath := Value;

    ShellTreeView20051.Path := FDefaultPath;
    CheckForLicence (ShellTreeView20051.Path);
  End; { If }
End; // SetDefaultPath

//-------------------------------------------------------------------------

Procedure TfrmReadLic.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ do Begin
    ptMinTrackSize.X:=580;
    ptMinTrackSize.Y:=280;
  end;

  Message.Result:=0;

  Inherited;
end;

//-------------------------------------------------------------------------

procedure TfrmReadLic.BitBtn1Click(Sender: TObject);
begin
  ShowMessage ('Height: ' + IntToStr(Self.Height) + #13 +
               'Width: ' + IntToStr(Self.Width));
end;

procedure TfrmReadLic.ShellTreeView20051Editing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

end.
