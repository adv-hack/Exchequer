unit CompDet;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, TEditVal, StdCtrls, Grids, SBSOutl, ExtCtrls, GlobVar, VarConst,
  GlobType, ExWrap1U, Menus, StrUtils;

type
  TfrmCompDet = class(TForm)
    Label81: Label8;
    cmName: Text8Pt;
    Label82: Label8;
    SaveBtn: TButton;
    CancelBtn: TButton;
    cmCode: Text8Pt;
    cmPath: Text8Pt;
    Label83: Label8;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    BrowseBtn: TButton;
    lblDemoData: TLabel;
    panSQLDetails: TPanel;
    Label84: Label8;
    Label85: Label8;
    edtRepUserId: Text8Pt;
    edtConnectionString: Text8Pt;
    Label86: Label8;
    edtRepUserPwd: Text8Pt;
    chkExportToAnalytics: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PropFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BrowseBtnClick(Sender: TObject);
    procedure cmCodeExit(Sender: TObject);
    procedure cmNameExit(Sender: TObject);
    procedure cmCodeKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    ItemChanged : Boolean;
    LockPos     : LongInt;
    OrigCompPath : ShortString;
    procedure Find_FormCoord;
    Procedure Send_UpdateList(WPar, LPar :  Integer);
    procedure SetFormProperties;
    procedure Store_FormCoord(UpMode  :  Boolean);
    Procedure SetSQLDetails;

    Function  vCompCode : Boolean;
    Function  vCompName : Boolean;
  public
    { Public declarations }
    DispMode : Byte;
    DirectoryError : Boolean;
    Procedure DisplayRec;
    Procedure ShowLink;
    {Function  ShowNew(WantCopy : Boolean) : Boolean;}
  end;


// Displays the company detail window for adding or editing, it assumes
// that the global Company^.CompDet record is already primed with the
// company details
Procedure EditCompany (Const ParentForm : TForm; Const Edit : Boolean);

Procedure ViewCompany (Const ParentForm : TForm);

{ Returns True if the data in the specified directory can be opened exclusively }
Function TestExclusivity (Const CompPath : ShortString) : Boolean;

implementation

{$R *.DFM}

Uses BtrvU2, BtSupU1, CmpCtrlU, ColCtrlU, EtStrU, BtSupU2, CompDlg, EntInitU,
     BtKeys1U, ChkCurrV, CompId, CompSec, Math, ConvData,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     oExchqSS,
     EntLicence;

Const
  {$I FilePath.Inc}

Type
  FlagsType = (IsTitle, IsField, IsStock, IsSPOP, Warn);
  FlagsSetType = Set Of FlagsType;

//=========================================================================

{ Returns True if the data in the specified directory can be opened exclusively }
Function TestExclusivity (Const CompPath : ShortString) : Boolean;
Var
  EStatus : SmallInt;
Begin { TestExclusivity }
  {$IFDEF EXSQL}
    If Not EnterpriseLicence.ISSQL Then
    Begin
  {$ENDIF}
      { Open file in Exclusive mode }
      EStatus := Open_File(F[JMiscF], CompPath + FileNames[JMiscF], -4);

      Result := (EStatus = 0);
      If Result Then
        { Close open file }
        Close_File (F[JMiscF]);
  {$IFDEF EXSQL}
    End // If Not EnterpriseLicence.ISSQL
    Else
      Raise Exception.Create ('EntComp.CompDet.TestExclusivity: This routine is not SQL compatible and should not be used');
  {$ENDIF}
End; { TestExclusivity }

//-------------------------------------------------------------------------

// Displays the company detail window for adding or editing, it assumes
// that the global Company^.CompDet record is already primed with the
// company details
Procedure EditCompany (Const ParentForm : TForm; Const Edit : Boolean);
Var
  CmpDir   : ShortString;
  OK       : Boolean;
begin
  { HM 18/07/01: Get Exclusive Access to Company before continueing }
  CmpDir := IncludeTrailingBackslash(Trim(Company^.CompDet.CompPath));

  If EnterpriseLicence.ISSQL Then
  Begin
    // MH 27/08/2008: Removed exclusive check for SQL when adding companies as it isn't technically
    // possible to do the check until AFTER it is in the Company table, at which point it is a bit late.
    If Edit Then
      OK := SQLUtils.ExclusiveAccess(CmpDir)
    Else
      OK := True;
  End // If EnterpriseLicence.ISSQL
  Else
  Begin
    { HM 18/07/01: Try to access Exclusively to ensure no-one is using the company data set }
    If FileExists (CmpDir + FileNames[SysF]) Then
      { Get Data Files-  check for exlusive access }
      OK := TestExclusivity (CmpDir)
    Else
      { No files - so OK to delete MCM entry }
      OK := True;
  End; // Else

  If OK Then
  Begin
    With TfrmCompDet.Create(ParentForm) Do
    Begin
      Try
        If Edit Then Begin
          HelpContext := 2;

          { Edit Company }
          DispMode := 2;

          DirectoryError := (Not IsValidCompany(CmpDir));

          { Lock and display company details }
          ShowLink;
        End { If }
        Else Begin
          DispMode := 1;

          { display company details }
          DisplayRec;
        End; { Else }

        { Display Window }
        ShowModal;
      Finally
        Free;
      End
    End; // With TfrmCompDet.Create(ParentForm)
  End // If OK
  Else
  Begin
    { Someone already using Company Data Set }
    MessageDlg('Someone is already using this Company Data Set, please get them to log out ' +
               'as this procedure requires exclusive access to the Data Set.',
               mtWarning, [mbOK], 0);
  End; // Else
end;

//-------------------------------------------------------------------------

Procedure ViewCompany (Const ParentForm : TForm);
Begin // ViewCompany
  With TfrmCompDet.Create(ParentForm) Do
  Begin
    Try
      HelpContext := 2;
      DispMode := 3;
      DisplayRec;
      ShowModal;
    Finally
      Free;
    End
  End; // With TfrmCompDet.Create(ParentForm)
End; // ViewCompany

//=========================================================================

procedure TfrmCompDet.FormCreate(Sender: TObject);
Var
  N : Integer;
begin
  DirectoryError := False;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  { Load in the saved coordinates }
  Find_FormCoord;

  // MH 15/07/08: Added cache of original Company Path for exclusive check under SQL
  OrigCompPath := '';
end;

procedure TfrmCompDet.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Var
  N : Integer;
begin
  If (DispMode = 2) Then
    Status:=UnlockMultiSing(F[CompF],CompF,LockPos);

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

{$IFNDEF EXSQL}
  Store_FormCoord(Not SetDefault);
{$ENDIF}
end;


Procedure TfrmCompDet.DisplayRec;
Begin
  With Company^, CompDet Do Begin
    { Set caption }
    If (DispMode = 2) Then
      Caption := 'Edit Company Details'
    Else If (DispMode = 1) Then
      Caption := 'New Company Details'
    Else If (DispMode = 3) Then
      Caption := 'View Company Details'
    Else
      Raise Exception.Create('EntComp.CompDet.DisplayRec: Unknown Mode (' + IntToStr(DispMode) + ')');

    cmCode.Text := Trim(CompCode);
    cmName.Text := Trim(CompName);
    cmPath.Text := Trim(CompPath);

    // MH 17/01/2013 v7.0.2 ABSEXCH-13857: Added Export To Analytics checkbox
    chkExportToAnalytics.Checked := CompExportToAnalytics;

    lblDemoData.Visible := CompDemoData;

    // Company Codes cannot be changed under SQL when re-attaching companies
    cmCode.Enabled := (DispMode = 1) And (Not EnterpriseLicence.IsSQL);
    cmName.Enabled := (DispMode <> 3);
    // Company Path's cannot be edited under SQL - detach company, move dir and re-attach the company instead
    cmPath.Enabled := (DispMode <> 3) And ((Not EnterpriseLicence.IsSQL) Or (DirectoryError And (DispMode = 2)));

    // MH 17/01/2013 v7.0.2 ABSEXCH-13857: Added Export To Analytics checkbox
    // ExportToAnalytics is only available for the SQL Edition
    chkExportToAnalytics.Visible := EnterpriseLicence.IsSQL;
    chkExportToAnalytics.Enabled := (DispMode <> 3) And EnterpriseLicence.IsSQL;

    BrowseBtn.Visible := cmPath.Enabled;
    SaveBtn.Visible := (DispMode <> 3);
    CancelBtn.Caption := IfThen(SaveBtn.Visible, '&Cancel', '&Close');

    panSQLDetails.Visible := (DispMode = 3) And EnterpriseLicence.IsSQL;
    If panSQLDetails.Visible Then
      SetSQLDetails;

    If (DispMode = 3) Then ActiveControl := CancelBtn;

    // MH 17/01/2013 v7.0.2 ABSEXCH-13857: Added Export To Analytics checkbox
    If chkExportToAnalytics.Visible Then
      // Check to see if the SQL Details are visible
      BrowseBtn.Top := IfThen (panSQLDetails.Visible, panSQLDetails.Top + panSQLDetails.Height + 5, panSQLDetails.Top)
    Else
      BrowseBtn.Top := chkExportToAnalytics.Top;

    SaveBtn.Top := BrowseBtn.Top;
    CancelBtn.Top := BrowseBtn.Top;

    ClientHeight := BrowseBtn.Top + BrowseBtn.Height + 5;

    // MH 15/07/08: Added cache of original Company Path for exclusive check under SQL
    OrigCompPath := Trim(CompPath);
  End; { With }
End;

//-------------------------------------------------------------------------

Procedure TfrmCompDet.SetSQLDetails;
var
{$IFDEF EXSQL}
  Entries: TStringList;
{$ENDIF}
  ConnStr: AnsiString;
Begin // SetSQLDetails

  // Reporting User
  edtRepUserId.Text := '';
  edtRepUserPwd.Text := '';

  // Connection String
  edtConnectionString.Text := '';

  {$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
  begin
    // edtConnectionString.Text := SQLUtils.GetConnectionString(cmCode.Text, True);

    if SQLUtils.GetConnectionString(cmCode.Text, True, ConnStr) = 0 then
    begin
      edtConnectionString.Text := ConnStr;
      Entries := TStringList.Create;
      try
        ExtractStrings([';'], [], PChar(ConnStr), Entries);
        EdtRepUserId.Text := Entries.Values['User ID'];
        EdtRepUserPwd.Text := Entries.Values['Password'];
      finally
        Entries.Free;
      end;
    end; {if SQLUtils.GetConnectionString(cmCode.Text, True, ConnStr) = 0 then}
  end;
  {$ENDIF}
  
End; // SetSQLDetails

//-------------------------------------------------------------------------

Procedure TfrmCompDet.ShowLink;
Var
  Key2F      : Str255;
  OK, Locked : Boolean;
Begin
  { Lock record }
  Status := 0;
  Locked := BOn;
  Key2F := FullCompCodeKey(Company^.RecPFix, Company^.CompDet.CompCode);
  Ok:=GetMultiRec(B_GetEq,B_MultLock,Key2F,CompCodeK,CompF,True,Locked);
  Report_BError(CompF, Status);

  Status:=GetPos(F[CompF],CompF,LockPos);

  If OK And StatusOk And Locked Then Begin
    { display }
    DisplayRec;
  End; { If }
End;

procedure TfrmCompDet.SaveBtnClick(Sender: TObject);
Var
  KeyS       : Str255;
  ValidError : Boolean;
  EStatus    : SmallInt;
  DataType   : Boolean;

  Function CheckDupli : Boolean;
  Const
    FNum    = CompF;
    KeyPath : Integer = CompPathK;
  Var
    TmpComp     : ^CompRec;
    KeyS        : Str255;
    TmpRecAddr  : LongInt;
    TmpKPath,
    TmpStat     : Integer;
  Begin
    Result := False;

    { Save company pos & rec }
    New (TmpComp);
    TmpComp^ := Company^;
    TmpKPath:=GetPosKey;
    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    { Check for duplicate path }
    KeyS := FullCompPathKey(cmCompDet, Company^.CompDet.CompPath);
    Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

    If StatusOk And (Company^.CompDet.CompCode <> TmpComp^.CompDet.CompCode) Then Begin
      Result := True;
      MessageDlg ('This company is already registered as ' + Trim(Company^.CompDet.CompCode), mtWarning, [mbOk], 0);
    End; { If }

    { restore company rec and pos }
    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);
    Company^ := TmpComp^;
    Dispose (TmpComp);
  End;

  Function GetCompanyId (Const InEdit   : Boolean;
                         Var   CompRec  : CompanyDetRec) : Boolean;
  Var
    SysKey   : Str255;
    LStatus  : SmallInt;
    SLocked  : Boolean;
    Res      : LongInt;
    oExchqSSFile : TExchqSSFile;
  Begin { GetCompanyId }
    CompRec.CompId := 0;

    With TCompanyIdCacheType.Create Do
    Begin
      Try
        // Build list of company details
        BuildCache;

        // MH 14/11/07: Modified for SQL Edition as the code below won't work under SQL as when
        // attaching a company you can't access the data until the company is attached.  Also
        // under the SQL Edition it is not possible to have two company records pointing at the
        // same data as the tables are prefixed with the company code, this makes the code below
        // mostly unnecessary
        If (Not EnterpriseLicence.IsSQL) Then
        Begin
          // Check there is a free slot - don't do check for IAO as is done on the directory dialog
          //If (CacheTotal < GetLicencedCompanyCount) Or InEdit Then Begin
          If (EnterpriseLicence.IsLITE Or (LiveCompanies < GetLicencedCompanyCount)) Or InEdit Then
          Begin
            // MH 12/11/07: Rewrote to use Client Id for SQL Compatibility
            oExchqSSFile := TExchqSSFile.Create;
            Try
              LStatus := oExchqSSFile.OpenFile (Trim(CompRec.CompPath) + FileNames[SysF], False);
              If (LStatus = 0) Then
              Begin
                { Get ModR from new data set and check the CompanyId }
                KeyS := SysNames[ModRR];
                LStatus := oExchqSSFile.GetEqual(KeyS);
                If (LStatus = 0) Then
                Begin
                  SyssMod^ := oExchqSSFile.SysMod;

                  // MH 30/11/06: Added Demo Data flag so that for IAO Demo Datasets can be exluded from the company count,
                  //              only set when adding otherwise it is a security loophole allowing blank datasets to be
                  //              converted to demo datasets by copying a blank system over the top of a demo system
                  If (DispMode = 1) Then CompRec.CompDemoData := (SyssMod^.ModuleRel.CompanyDataType = 1);

                  If (SyssMod^.ModuleRel.CompanyId = 0) Then
                  Begin
                    // CompanyId Not set - generate new unique value using cache
                    CompRec.CompId := GenCompId;

                    { Update ModRR with new Id }
                    LStatus := oExchqSSFile.Lock;
                    If (LStatus = 0) Then
                    Begin
                      SyssMod^.ModuleRel.CompanyId := CompRec.CompId;
                      oExchqSSFile.SysMod := SyssMod^;
                      LStatus := oExchqSSFile.Update;
                    End { If GetMultiSys }
                    Else Begin
                      // Error Reading ModRR for updating
                      MessageDlg('Failed to lock the Company Id in the ' +
                                 'Company Data Set for updating', mtError, [mbOK], 0);
                      CompRec.CompId := 0;
                    End; { Else }
                  End { If (SyssMod^.ModuleRel.CompanyId = 0)  }
                  Else Begin
                    // CompanyId set - check against those cached up from Company.Dat
                    If Not CheckExists (SyssMod^.ModuleRel.CompanyId) Then
                      // CompanyId doesn't already exists in Company.Dat - go with it
                      CompRec.CompId := SyssMod^.ModuleRel.CompanyId
                    Else Begin
                      // CompanyId set and Duplicate - do CompanySynch bodge to determine
                      // whether to use existing CId or generate new unique CId

                      // Step 1: Reset CompanySynch in new data set to zero
                      LStatus := oExchqSSFile.Lock;
                      If (LStatus = 0) Then
                      Begin
                        SyssMod^.ModuleRel.CompanySynch := 0;
                        oExchqSSFile.SysMod := SyssMod^;
                        LStatus := oExchqSSFile.Update;

                        // Step 2: Close ExchQss.Dat
                        oExchqSSFile.CloseFile;

                        // Step 3: Reset all CompanySynch's in Company.Dat to 1 so we
                        // can detect if new comp is already in Company.Dat
                        Res := ResetCompanySynchFlags (1);

                        // Step 4: Re-open ExchqSS.Dat in new data set
                        LStatus := oExchqSSFile.OpenFile (Trim(CompRec.CompPath) + FileNames[SysF], False);
                        If (LStatus = 0) Then Begin
                          // Step 5: Get ModR and check to see if CompanySynch 0 or 1
                          KeyS := SysNames[ModRR];
                          LStatus := oExchqSSFile.GetEqual(KeyS);
                          If (LStatus = 0) Then
                          Begin
                            SyssMod^ := oExchqSSFile.SysMod;

                            // Check CompanySynch to determine if company is a duplicate
                            // peer-to-peer already in Company.Dat or if a new set of data
                            If (SyssMod^.ModuleRel.CompanySynch = 0) Then Begin
                              // New Data Set with Duplicate Company Id - Generate new unique
                              // CompanyId - probably caused by copying an existing company
                              CompRec.CompId := GenCompId;

                              LStatus := oExchqSSFile.Lock;
                              If (LStatus = 0) Then
                              Begin
                                SyssMod^.ModuleRel.CompanyId := CompRec.CompId;
                                oExchqSSFile.SysMod := SyssMod^;
                                LStatus := oExchqSSFile.Update;
                              End // If (LStatus = 0)
                              Else Begin
                                // Error Reading ModRR for updating
                                MessageDlg('Failed to lock the Company Id in the Company Data Set for updating', mtError, [mbOK], 0);
                                CompRec.CompId := 0;
                              End; { Else }
                            End { If (CompanySynch = 0) }
                            Else
                              // Duplicate entry for Peer-To-Peer access - keep
                              // existing Compamny Id
                              CompRec.CompId := SyssMod^.ModuleRel.CompanyId;
                          End { If GetMultiSys }
                          Else
                            // Error reading ModRR
                            MessageDlg('Failed to read the Company Id from the ' +
                                       'Company Data Set', mtError, [mbOK], 0);
                        End { If (LStatus = 0) }
                        Else
                          // Error re-opening ExchqSS.Dat in new data set
                          MessageDlg('Failed to re-open the Company Data to read the ' +
                                     'Company Id, status ' + IntToStr(LStatus),
                                     mtError, [mbOK], 0);
                      End { If GetMultiSys }
                      Else
                        // Error reading ModRR
                        MessageDlg('Failed to lock the Company Id in the Company Data Set',
                                   mtError, [mbOK], 0);
                    End;{ Else }
                  End; { Else }
                End { If GetMultiSys }
                Else
                  // Error reading ModRR
                  MessageDlg('Failed to read the Company Id from the Company Data Set',
                             mtError, [mbOK], 0);

                oExchqSSFile.CloseFile;
              End { If (LStatus = 0) }
              Else
                // Error opening ExchqSS.Dat in new data set
                MessageDlg('Failed to open the Company Data to read the Company Id, status ' +
                           IntToStr(LStatus), mtError, [mbOK], 0);
            Finally
              oExchqSSFile.Free;
            End; // Try..Finally
          End { If (CacheTotal < GetLicencedCompanyCount)  }
          Else
            MessageDlg('The Licenced Company Count has been exceeded', mtWarning, [mbOK], 0);
        End // If (Not EnterpriseLicence.IsSQL)
        Else
        Begin
          // SQL - generate new unique value using cache
          CompRec.CompId := GenCompId;
        End; // Else
      Finally
        Free;
      End;
    End; // With TCompanyIdCacheType.Create

    Result := (CompRec.CompId > 0);
  End; { GetCompanyId }

  //------------------------------

  Function UpdateCompanyId : Boolean;
  Var
    oExchqSSFile : TExchqSSFile;
    lStatus : LongInt;
    lSysMod : ModRelRecType;
  Begin // UpdateCompanyId
    Result := False;

    oExchqSSFile := TExchqSSFile.Create;
    Try
      LStatus := oExchqSSFile.OpenFile (Trim(Company^.CompDet.CompPath) + FileNames[SysF], False);
      If (LStatus = 0) Then
      Begin
        // Get ModR from new data set and check the CompanyId
        KeyS := SysNames[ModRR];
        LStatus := oExchqSSFile.GetEqual(KeyS);
        If (LStatus = 0) Then
        Begin
          lSysMod := oExchqSSFile.SysMod;

          // Return company data type flag
          Result := (lSysMod.ModuleRel.CompanyDataType = 1);

          If (Company^.CompDet.CompId <> lSysMod.ModuleRel.CompanyId) Then
          Begin
            LStatus := oExchqSSFile.Lock;
            If (LStatus = 0) Then
            Begin
              lSysMod.ModuleRel.CompanyId := Company^.CompDet.CompId;
              oExchqSSFile.SysMod := lSysMod;
              LStatus := oExchqSSFile.Update;
            End // If (LStatus = 0)
            Else
              // Error Reading ModRR for updating
              MessageDlg('Failed to lock the Company Id in the Company Data Set for updating', mtError, [mbOK], 0);
          End; // If (Company^.CompDet.CompId <> SyssMod^.ModuleRel.CompanyId)
        End // If (LStatus = 0)
        Else
          // Error reading ModRR
          MessageDlg('Failed to read the Company Id from the Company Data Set', mtError, [mbOK], 0);

        oExchqSSFile.CloseFile;
      End // If (LStatus = 0)
      Else
        // Error opening ExchqSS.Dat in new data set
        MessageDlg('Failed to open the Company Dataset to update the Company Id, status ' + IntToStr(LStatus), mtError, [mbOK], 0);
    Finally
      oExchqSSFile.Free;
    End; // Try..Finally
  End; // UpdateCompanyId

  //------------------------------

  Procedure SetCompanyDataType (Const IsDemoData : Boolean);
  Var
    lStatus : SmallInt;
    OK : Boolean;
    KeyS : Str255;
    lLockPos : LongInt;
    Locked : Boolean;
  Begin // SetCompanyDataType
    Locked := BOn;
    KeyS := FullCompCodeKey(Company^.RecPFix, Company^.CompDet.CompCode);

    OK := GetMultiRec(B_GetEq, B_MultLock, KeyS, CompCodeK, CompF, True, Locked);

    lStatus := GetPos(F[CompF], CompF, lLockPos);
    If OK And (lStatus = 0) And Locked Then
    Begin
      Company^.CompDet.CompDemoData := IsDemoData;

      lStatus:=Put_Rec(F[CompF],CompF,RecPtr[CompF]^,0);

      { Unlock }
      UnlockMultiSing(F[CompF], CompF, lLockPos);
    End; // If OK And (lStatus = 0) And Locked
  End; // SetCompanyDataType

  //------------------------------

begin
  If (DispMode = 2) Then Begin
    { Get edit Record as may of been changed in the browse dialog }
    SetDataRecOfs(CompF,LockPos);
    Status:=GetDirect(F[CompF],CompF,RecPtr[CompF]^,0,0);
  End; { If }

  With Company^, CompDet Do Begin
    { Load details into record }
    RecPFix := cmCompDet;
    CompCode := FullCompCode(cmCode.Text);
    CompName := cmName.Text;

    // MH 17/01/2013 v7.0.2 ABSEXCH-13857: Added Export To Analytics checkbox
    CompExportToAnalytics := chkExportToAnalytics.Checked;

    { Check path ends in ':' or '\' }
    CompPath := Trim(UpperCase(cmPath.Text));
    If (CompPath <> '') And
       (Not (Copy(CompPath,Length(CompPath),1)[1] In [':', '\'])) Then Begin
      CompPath := CompPath + '\';
    End; { If }
    CompPath := FullCompPath(CompPath);
    cmPath.Text := Trim(CompPath);

    { Check validation }
    If vCompCode And vCompName Then Begin
      { Check drive is specified }
      ValidError := (Not (CompPath[1] In ['C'..'Z'])) Or
                    (CompPath[2] <> ':') Or
                    (Length(Trim(CompPath)) <= 3);

      If (Not ValidError) Then Begin
        { Check data exists }
{$IFDEF EXSQL}
        // MH 11/05/07: Can't do this as until we have added the company it doesn't exist in Company.Dat
        // MH 21/09/07: Restored the ValidCompany call as
        ValidError := Not SQLUtils.ValidCompany(Trim(CompPath));
        //ValidError := False;
{$ELSE}
        ValidError := Not FileExists (Trim(CompPath) + PathSys);
{$ENDIF}        
        If Not ValidError Then Begin
          { validate company - check it doesn't already exist in the database }
          ValidError := CheckDupli;
        End { If }
        Else
          MessageDlg ('The path is not valid', mtWarning, [mbOk], 0);
      End { If }
      Else
        MessageDlg ('The drive is not valid', mtWarning, [mbOk], 0);
    End { Else }
    Else
      ValidError := True;

    If (Not ValidError) Then Begin
      { Company code, name etc check out - make sure its the correct currency version }
      If Not CheckCurrencyVer (CompPath) Then Begin
        ValidError := True;
        MessageDlg ('This company is setup for a different Currency version', mtWarning, [mbOk], 0);
      End; { If }
    End; { If }

    { HM 18/06/01: Added Exclusivity check as part of v4.40 security }
    If (Not ValidError) Then Begin
      // MH 12/11/07: Modified for SQL compatibility
      If UsingSQL Then
      Begin
        // MH 27/08/2008: Modified to skip Exclusive Check when adding companies as not
        // technically possible until AFTER the company is in Company.Dat
        If (DispMode <> 1) Then
        Begin
          // MH 15/07/08: Modified to use cached original path under SQL as if the company path
          // is changed then BtrvSQL.Dll is going to fail to match it up in Company.Dat until
          // after the BUpdate has been done.
          If (OrigCompPath <> '') Then
            ValidError := Not ExclusiveAccess(Trim(OrigCompPath))
          Else
            ValidError := Not ExclusiveAccess(Trim(CompPath))
        End; // If (DispMode <> 1)
      End // If UsingSQL
      Else
      Begin
        { Check can open data set exclusively }
        EStatus := Open_File(F[JMiscF], Trim(CompPath) + FileNames[JMiscF], -4);
        ValidError := (EStatus <> 0);
        If (Not ValidError) Then
          Close_File (F[JMiscF])
      End; // Else

      If ValidError Then
        MessageDlg('Someone is already using this Company Data Set, please get them to log out ' +
                   'as this procedure requires exclusive access to the Data Set.',
                   mtWarning, [mbOK], 0);
    End; { If (Not ValidError) }
  End; { With }

  If (Not ValidError) Then
    { Get CompanyId from ExchQss.Dat }
    ValidError := Not GetCompanyId ((DispMode = 2), Company^.CompDet);

  If (Not ValidError) Then Begin
    If (DispMode = 2) Then Begin
      { Edit }
      Status:=Put_Rec(F[CompF],CompF,RecPtr[CompF]^,0);

      { Unlock }
      UnlockMultiSing(F[CompF],CompF,LockPos);

{$IFDEF EXSQL}
      If EnterpriseLicence.IsSQL And (Status = 0) Then
      Begin
        UpdateCompanyCache(Company^.CompDet.CompCode, Company^.CompDet.CompPath);
        // Company Company Id into SyssMod
        UpdateCompanyId;
      End; // If EnterpriseLicence.IsSQL And (Status = 0)
{$ENDIF}
    End { If }
    Else Begin
      { Add/Copy }
{$IFDEF EXSQL}
      If EnterpriseLicence.IsSQL Then
      Begin
        // SQL - Attach the company and then if successful add the record into Company.Dat
        Status := SQLUtils.AttachCompany(Trim(Company^.CompDet.CompCode));
      End // If EnterpriseLicence.IsSQL
      Else
{$ENDIF}
        Status := 0;

      If (Status = 0) Then
      Begin
        Status := Add_rec(F[CompF],CompF,RecPtr[CompF]^,0);
{$IFDEF EXSQL}
        If EnterpriseLicence.IsSQL Then
        Begin
          If (Status = 0) Then
          Begin
            // MH 27/08: Need to refresh Company Cache in BtrvSQL somehow
            //UpdateCompanyCache(Company^.CompDet.CompCode, Trim(Company^.CompDet.CompPath));
            Status := RebuildCompanyCache;
          End; // If (Status = 0)

          If (Status = 0) Then
          Begin
            // Copy Company Id into SyssMod and update data type in Company record
            DataType := UpdateCompanyId;
            SetCompanyDataType (DataType);
          End // If (Status = 0)
          Else
          Begin
            // SQL - Add failed try to return company to detached state
            SQLUtils.DetachCompany(Trim(Company^.CompDet.CompCode));
          End; // If (Status <> 0) And EnterpriseLicence.IsSQL
        End; // If EnterpriseLicence.IsSQL
{$ENDIF}
      End; // If (Status = 0)
    End; { Else }

    Report_BError (CompF, Status);

    If (DispMode = 2) Then
      Send_UpdateList(200,0)
    Else
      Send_UpdateList(100,0);

    Close;
  End; { If }
end;

procedure TfrmCompDet.CancelBtnClick(Sender: TObject);
begin
  { Check for changes }
  If cmCode.Modified Or cmName.Modified Or cmPath.Modified Then Begin
    If (MessageDlg ('Abandon Changes?', mtConfirmation, [mbYes, mbNo],0) = mrYes) Then
      Close;
  end
  else
    Close;
end;

(*
Function TfrmCompDet.ShowNew(WantCopy : Boolean) : Boolean;
Var
  NS : Byte;

  Function NextSet : Byte;
  Var
    KeyS : Str255;
  Begin
    Result := 0;

    Repeat
      Inc (Result);
      KeyS := Copy (SysNames[FormR], 1, 2) + Chr(100 + Result);
    Until (Result > 99) Or (Not CheckExsists (KeyS, SysF, SysK));

    If (Result > 99) Then
      Result := 0;
  End;

Begin
  Result := True;

  { Initialise Record }
  If (Not WantCopy) Then
    Blank(SyssForms,Sizeof(SyssForms))
  Else
    Move(Syss, SyssForms^, Sizeof(SyssForms^));

  { Default SetNo to next available }
  SyssForms.IdCode := SysNames[FormR];
  NS := NextSet;
  If (NS > 0) Then
    SyssForms.IdCode[3] := Chr(100 + NS)
  Else
    { no more available numbers }
    Result := False;

  If Result Then
    { display }
    DisplayRec;
End;
*)

{ == Procedure to Send Message to Get Record == }
Procedure TfrmCompDet.Send_UpdateList(WPar, LPar :  Integer);
Var
  Message1 :  TMessage;
  MessResult :  LongInt;
Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do Begin
    MSg:=WM_CustGetRec;
    WParam := 100 + WPar;
    LParam := LPar;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);
end; {Proc..}

procedure TfrmCompDet.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmCompDet.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TfrmCompDet.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

procedure TfrmCompDet.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TfrmCompDet.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord := Not StoreCoord;
end;


procedure TfrmCompDet.SetFormProperties;
Var
  TmpPanel    :  Array[1..3] of TPanel;
  n           :  Byte;
  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;
Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;

  try
    TmpPanel[1].Font:=CmCode.Font;
    TmpPanel[1].Color:=CmCode.Color;

    TmpPanel[2].Font:=Label81.Font;
    TmpPanel[2].Color:=Label81.Color;

    {
    TmpPanel[3].Color:=BarColor;
    TmpPanel[3].Font.Assign(TmpPanel[1].Font);
    TmpPanel[3].Font.Color:=BarTextColor;
    }

    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],0,'Company Detail Properties',BeenChange,ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then Begin
          Label81.Font.Assign(TmpPanel[2].Font);
          Label82.Font.Assign(Label81.Font);
          Label83.Font.Assign(Label81.Font);

          cmCode.Color := TmpPanel[1].Color;
          cmCode.Font.Assign(TmpPanel[1].Font);
          cmName.Color := cmCode.Color;
          cmName.Font.Assign(cmCode.Font);
          cmPath.Color := cmCode.Color;
          cmPath.Font.Assign(cmCode.Font);
        end;
      end;
    finally
      ColourCtrl.Free;
    end;
  Finally
    For n:=1 to 3 do
      TmpPanel[n].Free;
  End;

  If (ResetDefaults) then Begin
    SetDefault:=BOn;
    Close;
  end;
end;

procedure TfrmCompDet.Find_FormCoord;
Var
  ThisForm:  TForm;
  VisibleRect:  TRect;
  GlobComp:  TGlobCompRec;
  I        : Integer;
Begin
  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do Begin
    GetValues:=BOn;

    PrimeKey:='S';

    If (GetbtControlCsm(ThisForm)) then Begin
      StoreCoord:=(ColOrd=1);
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);
    end;

    If GetbtControlCsm(Label81) then Begin
      Label82.Font.Assign(Label81.Font);
      Label82.Color:=Label81.Color;
      Label83.Font.Assign(Label81.Font);
      Label83.Color:=Label81.Color;
    End; { If }

    If GetbtControlCsm(CmCode) then Begin
      cmName.Color := cmCode.Color;
      cmName.Font.Assign(cmCode.Font);
      cmPath.Color := cmCode.Color;
      cmPath.Font.Assign(cmCode.Font);
    End; { If }
  End; { With }
end;

procedure TfrmCompDet.Store_FormCoord(UpMode  :  Boolean);
Var
  GlobComp : TGlobCompRec;
  I        : Integer;
Begin
  New(GlobComp,Create(BOff));

  With GlobComp^ do Begin
    GetValues:=UpMode;

    PrimeKey:='S';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(Label81);
    StorebtControlCsm(cmCode);
  end; {With GlobComp..}

  GlobComp.Destroy;
end;

procedure TfrmCompDet.BrowseBtnClick(Sender: TObject);
Var
  CompanyDialog : TCompanyDialog;
begin
  CompanyDialog := TCompanyDialog.Create(Self);
  Try
    CompanyDialog.Caption := 'Find Existing Company';
    CompanyDialog.Path := cmPath.Text;
    CompanyDialog.DirectoryError := DirectoryError;

    // Check data type controls whether the company count licence is checked - it should always
    // be set when adding and should be set when editing a demo dataset - it should not be set
    // when editing a 'new' dataset as that may cause incorrect warnings if they browse to another
    // 'new' dataset
    CompanyDialog.CheckDataType := (DispMode = 1) or ((DispMode = 2) And Company^.CompDet.CompDemoData);

    If CompanyDialog.Execute Then
    Begin
      cmPath.Text := CompanyDialog.Path;
    End; { If }
  Finally
    CompanyDialog.Free;
  End;
end;

procedure TfrmCompDet.cmCodeExit(Sender: TObject);
begin
  If cmCode.Enabled And (Not cmCode.ReadOnly) And (ActiveControl <> CancelBtn) Then
    VCompCode;
end;

procedure TfrmCompDet.cmNameExit(Sender: TObject);
begin
  If cmName.Enabled And (Not cmName.ReadOnly) And (ActiveControl <> CancelBtn) Then
    VCompName;
end;

Function TfrmCompDet.vCompCode : Boolean;
Const
  FNum    = CompF;
  KeyPath : Integer = CompCodeK;
Var
  KeyS : Str255;

  Function ValidChars (Const CheckStr : ShortString; Const CheckIdx : Byte = 1) : Boolean;
  Begin // ValidChars
    If (CheckIdx < Length(CheckStr)) Then
    Begin
      Result := CheckStr[CheckIdx] In ['A'..'Z', '0'..'9'];
      If Result Then
        Result := ValidChars(CheckStr, CheckIdx+1);
    End // If (CheckIdx < Length(CheckStr))
    Else
      Result := True;
  End; // ValidChars

Begin
  Result := False;

  If cmCode.Enabled And (Not cmCode.ReadOnly) Then Begin
    { Check its not blank }
    If (Trim (CmCode.Text) <> '') Then
    Begin
      If (DispMode = 2) Or ValidChars (cmCode.Text) Then
      Begin
        { Check it doesn't already exist in database }
        KeyS := cmCompDet + Trim(UpperCase(cmCode.Text));
        Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

        Result := Not StatusOK;

        If (Not Result) Then
          { Code already exists }
          MessageDlg ('This Company Code already exists', mtWarning, [mbOk], 0);
      End // If (DispMode = 2) Or ValidChars (cmCode.Text)
      Else
        MessageDlg ('The Company Code can only contain the letters A to Z and the numbers 0 to 9', mtWarning, [mbOk], 0);
    End { If }
    Else
      { Its blank }
      MessageDlg ('The Company Code cannot be left blank', mtWarning, [mbOk], 0);

    If (Not Result) And (Trim(cmName.Text) <> '') Then
      cmCode.Text := Auto_GetCompCode(Trim(cmName.Text));
  End { If }
  Else
    Result := True;
End;

Function TfrmCompDet.vCompName : Boolean;
Begin
  Result := False;

  { Check its not blank }
  If (Trim (CmName.Text) <> '') Then Begin
    Result := True;
  End { If }
  Else
    { Its blank }
    MessageDlg ('The Company Name cannot be left blank', mtWarning, [mbOk], 0)
End;

procedure TfrmCompDet.cmCodeKeyPress(Sender: TObject; var Key: Char);
begin
  // From v6.00 limit company codes to 'A'-'Z' and '0'-'9' for SQL compatiblity
  If (Key In ['a'..'z']) Then
    Key := UpperCase(Key)[1]
  Else If (Not (Key In [#8, 'A'..'Z', '0'..'9'])) Then
    Key := #0;
end;

Initialization
  Randomize;
end.
