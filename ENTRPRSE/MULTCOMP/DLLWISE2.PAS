unit Dllwise2;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

interface

uses Dialogs, FileCtrl, Forms, WinTypes, WinProcs, SysUtils, WiseUtil,
     IniFiles;



{ Initialises the company data with a 30-day security code }
//function SCD_EntSet30DaySec(var DLLParams: ParamRec): LongBool; StdCall; export;

{ Displays the company wizard to setup new companies }
function SCD_EntCompanyWizard(var DLLParams: ParamRec): LongBool; StdCall; export;

{ Replicate main security for new sets of company data }
function SCD_EntCopyMainSecurity(var DLLParams: ParamRec): LongBool; StdCall; export;

{ Data Copy Wizard for Single-CD }
function SCD_EntDataCopy(var DLLParams: ParamRec): LongBool; StdCall; export;


implementation


Uses BtrvU2, GlobVar, VarConst, EntRegU, ETStrU, ETDateU, CompWiz1, CompWiz2, CompWiz3,
     CompWiz4, CompWiz5, CompWiz6, ETMiscU, BtKeys1U, SecWarn, CompUtil, SecureU,
     BtSupU1, GlobExcH, EntInitU, SysU3, ModRels, VarFPosU, CompId, SecSup2U,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     Math;

Var
  LStatus : Integer;

//=========================================================================

Function OpenDataFileI (Const FileNo : Integer; Const FilePath : ShortString) : SmallInt;
Begin { OpenDataFileI }
  // Open specified file if it exists
{$IFDEF EXSQL}
  if TableExists(FilePath + FileNames[FileNo]) then
{$ELSE}
  If FileExists (FilePath + FileNames[FileNo]) Then
{$ENDIF}
    Result := Open_File(F[FileNo], FilePath + FileNames[FileNo], 0)
  Else
    Result := 12;  // File Not Found
End; { OpenDataFileI }

//------------------------------

Function OpenDataFile (Const FileNo : Integer; Const FilePath : ShortString) : Boolean;
Begin // OpenDataFile
  LStatus := OpenDataFileI (FileNo, FilePath);
  Result := (LStatus = 0);
End; // OpenDataFile

//-------------------------------------------------------------------------

Procedure CloseDataFile (Const FileNo : Integer);
Begin { CloseDataFile }
  Close_File(F[FileNo]);
End; { CloseDataFile }

//=========================================================================

{ Initialises the company data with a 30-day security code }
function SCD_EntSet30DaySec(var DLLParams: ParamRec): LongBool;
Const
  FNum    = SysF;
  KeyPath = SysK;

  MaxDaysSecy  =  30;
Var
  KeyS             : Str255;
  Params           : ANSIString;
  DlgPN            : String;
  RelDateStr       : LongDate;
  Rd, Rm, Ry       : Word;
  RelDOW, RelMoveX : Byte;
Begin { EntSet30DaySec }
  DllStatus := 0;
  Result := True;

  { Check security parameter to ensure not called by anyone }
  Params := DLLParams.szParam;  { GAS7G2 }
  If (Copy (Params, 1, 6) = 'GAS7G2') And (Length(Params) = 6) Then Begin
    If Check4BtrvOk Then Begin
      { Get directory of data to initialise }
      GetVariable(DLLParams, 'V_MAINDIR', DlgPN);
      FixPath (DlgPN);

      { Open ExchQss.Dat }
      Result := OpenDataFile (FNum, DlgPN);
      If Result Then Begin
        { Opened - get SysR record }
        KeyS := SysNames[SysR];
        Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

        If StatusOk Then Begin
          { Got SysR - Set security - no-one else editing so no need to lock }
          With Syss Do Begin
            { Set Security as Today + 30 days Check for weekends }
            RelDateStr:=CalcDueDate(Today,MaxDaysSecy);

            RelDOW:=DayofWeek(RelDateStr);

            Case RelDOW of {* Its at the weekend/Bank hols ... move to mid week *}
              1    : RelMoveX:=1;
              5..7 : RelMoveX:=(4-(RelDOW-5));
            Else
                     RelMoveX:=0;
            End; { Case }

            If (RelMoveX>0) then
              RelDateStr:=CalcDueDate(RelDateStr,RelMoveX);

            DateStr(RelDateStr,Rd,Rm,Ry);

            RelDate:=CalJul(Rd,Rm,Ry);

            {* Reset Security on all versions *}
            Blank (ExSecurity, Sizeof(ExSecurity));
            Blank (ExRelease,  Sizeof(ExRelease));
          End; { With Syss }

          { Update SysR record }
          Status := Put_Rec(F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath);

          Result := (Not StatusOK);

          { Inform user that security code will expire in 30 days }
          SecurityWarning := TSecurityWarning.Create (Application);
          Try
            SecurityWarning.ShowModal;
          Finally
            SecurityWarning.Free;
          End;
        End; { If }

        CloseDataFile(FNum);
      End; { If Result }
    End { If }
    Else Begin
      { Btrieve Not Running }
      Result := True;
    End; { Else }
  End { If }
  Else Begin
    { Incorrect security parameter - return false }
    Result := True;
  End; { Else }
End; { EntSet30DaySec }


{-----------------------------------------------------------------------------}


{ Displays the company wizard to setup new companies }
//
// 1000        Unknown Exception
// 1001        Incorrect security parameter
// 1002        Btrieve Not Running
// 1003        Company Wizard not completed
// 1100..1199  Btrieve Error opening Company.Dat
// 1200..1299  Btrieve Error updating Company.Dat
// 1300..1399  Btrieve Error loading/locking SysR + VatR
// 1400..1499  Btrieve Error updating Exchqss.Dat
// 1500..1599  Btrieve Error opening ExchQSS.Dat
// 1600..1699  Btrieve Error opening Stck.Dat
function SCD_EntCompanyWizard(var DLLParams: ParamRec): LongBool;
Const
  FNum    = SysF;
  KeyPath = SysK;
Var
  Params                   : ANSIString;
  W_ModuleVer,
  W_CurrVer, W_CompCode,
  W_CompName, W_InstallType,
  CompDir, Temp, MainDir   : String;
  IsDemo, NewComp, IsUpg   : Boolean;
  TmpCompany               : ^CompRec;
  CompLockPos,
  SyssLockPos, VATLockPos  : LongInt;
  LicCntry                 : LongInt;
  DLLStatus                : LongInt;

  {------------------------------------------------}

  { Get any existing company details or setup new details }
  Procedure GetCompanyDets (Const DataDir : ShortString);
  Const
    FNum    = CompF;
    KeyPath = CompPathK;
  Var
    KeyS   : Str255;
  Begin { GetCompanyDets }
    NewComp := False;
    LStatus := 0;

    { Lock record the hard way as I don't want to use BTSUPU1 }
    KeyS := FullCompPathKey(cmCompDet, Trim(DataDir));
    //LStatus := Find_Rec(B_GetEq + B_SingNWLock + B_MultLock, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
    LStatus := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

    If (LStatus = 0) And (UpperCase(Trim(Company^.CompDet.CompPath)) = UpperCase(DataDir)) Then Begin
      { Got the company details for the data directory }
      LStatus := GetPos(F[Fnum], Fnum, CompLockPos);
    End { If }
    Else Begin
      { No existing details found }
      NewComp := True;

      FillChar (Company^, SizeOf(Company^), #0);
      With Company^, CompDet do Begin
        { Hard code details as Company.Dat will be empty }
        RecPFix  := cmCompDet;
        CompName := W_CompName;
        If (Trim(CompName) = '') Then
        Begin
          CompName := 'Demonstration Company';

          // HM 13/12/00: Modified for Des so Demo Companies appear at bottom of MCM List
          //CompCode := Auto_GetCompCode('Demo');
          CompCode := Auto_GetCompCode('ZZZZ');
        End { If }
        Else Begin
          If (W_InstallType = '@') Then
            // Client-Synch
            CompCode := LJVAR(W_CompCode, CompCodeLen)
          Else
            CompCode := Auto_GetCompCode(CompName);
        End; { Else }
        CompPath := FullCompPath(DataDir);

        CompDemoData := IsDemo;
      End; { With }
    End; { Else }
  End; { GetCompanyDets }

  {------------------------------------------------}

  { Updates the companies database }
  Procedure UpdateCompany;
  Begin { UpdateCompany }
    If NewComp Then
    begin
      { Add new company record }
      LStatus := Add_Rec(F[CompF], CompF, RecPtr[CompF]^, CompCodeK);
//      Showmessage('Add company result: ' + inttostr(LStatus));
    end
    Else Begin
      { take temp copy of comp }
      New (TmpCompany);
      TmpCompany^ := Company^;

      { Restore position }
      LStatus := GetPos(F[CompF], CompF, CompLockPos);

      { copy rec back }
      Company^ := TmpCompany^;
      Dispose (TmpCompany);

      { Update existing company record }
      LStatus := Put_Rec(F[CompF], CompF, RecPtr[CompF]^, CompCodeK);

//      Showmessage('Update company result: ' + inttostr(LStatus));
    End; { Else }
  End; { UpdateCompany }

  {------------------------------------------------}

  { Allocate Company Id }
  Function AllocateCID : LongInt;
  Const
    FNum    = SysF;
    KeyPath = SysK;
  Var
    KeyS    : Str255;
    Locked  : Boolean;
    LockPos : LongInt;
  Begin { AllocateCID }
    Result := 0;

    { Get and lock the Module Release Code record - contains Company Id }
    KeyS := SysNames[ModRR];

    // TODO: multlock is not working for SQL... commented out for a while  

    //LStatus := Find_Rec(B_GetEq + B_MultLock, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
    LStatus := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);


    If (LStatus = 0) Then Begin
      { Get position of record for unlocking later }
      LStatus := GetPos(F[Fnum], Fnum, LockPos);


      If (LStatus = 0) Then Begin
        { Move ModRR into SyssMod^ for access }
        Move (Syss, SyssMod^, SizeOf(SyssMod^));

        // MH 12/12/06: Don't change the flag during upgrades - causes problems for Reseller/Demo Upgrades
        // which set the flag to Demo
        If (Not IsUpg) Then
        Begin
          // MH 30/11/06: Added Data Type flag into SysMod to allow IAO to exclude demo datasets from the company count
          SyssMod^.ModuleRel.CompanyDataType := IfThen(IsDemo, 1, 0);
//ShowMessage ('EntComp2.DllWise2.SCD_EntCompanyWizard.AllocateCID: ' + IntToStr(SyssMod^.ModuleRel.CompanyDataType));
        End; // If (Not IsUpg)

        With TCompanyIdCacheType.Create Do
          Try
            { Load all company details into the cache }
            BuildCache;

            { Generate unique Company Id for new company from Cache }
            SyssMod^.ModuleRel.CompanyID := GenCompId;
            Company^.CompDet.CompId := SyssMod^.ModuleRel.CompanyID;
          Finally
            Free;
          End;

        { Save changes to ModR record }
        Move (SyssMod^, Syss, SizeOf (Syss));
        Status := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, SysK);


        UnLockMultiSing(F[SysF], SysF, LockPos);
      End { If (LStatus = 0) }
      Else
        Result := 1300 + LStatus;
    End { If (LStatus = 0) }
    Else
      Result := 1300 + LStatus;
  End; { AllocateCID }

  {------------------------------------------------}

  { Load the System Setup records for the Company Wizard }
  Function LoadCompanySyss : Boolean;
  Const
    FNum    = SysF;
    KeyPath = SysK;
  Var
    KeyS   : Str255;
    Locked : Boolean;
  Begin { LoadCompanySyss }
    { Lock record the hard way as I don't want to use BTSUPU1 }
    KeyS := SysNames[VATR];
    //LStatus := Find_Rec(B_GetEq + B_MultLock, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
    LStatus := Find_Rec(B_GetEq , F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

    If (LStatus = 0) Then Begin
      { Copy into SyssVAT }
      Move(Syss,SyssVAT^,Sizeof(SyssVAT^));

      { Get record position for unlocking }
      LStatus := GetPos(F[Fnum], Fnum, VATLockPos);
    End; { If }

    If (LStatus = 0) Then Begin
      { Get main System Setup record }
      KeyS := SysNames[SysR];
      //LStatus := Find_Rec(B_GetEq + B_MultLock, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
      LStatus := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

      If (LStatus = 0) Then
        LStatus := GetPos(F[Fnum], Fnum, SyssLockPos);
    End; { If }

    Result := (LStatus = 0);
  End; { LoadCompanySyss }

  {------------------------------------------------}

  { Display the date entry wizard }
  Function CompanyWizard : Boolean;
  Const
    DoneCode       = 'D';
    VATCAScheme    =  'C';  {* VAT Cash Accounting Trigger *}
    VATNoScheme    =  'N';  {* VAT Normal Scheme           *}
  Var
    CompDetail1 : TCompDetail1;
    CompDetail2 : TCompDetail2;
    CompDetail3 : TCompDetail3;
    CompDetail4 : TCompDetail4;
    CompDetail5 : TCompDetail5;
    frmCompWizStockCats : TfrmCompWizStockCats;
    ExCode      : Char;
    CurrDlg, iCat : SmallInt;
    Cntry       : LongInt;
    DefCcy, iBand : Byte;
    WantStkCats : Boolean;
    sGetCompCode, sGetCompName: String;

    Function Calc_NewVATPeriod(LastVDate  :  LongDate;
                             NoMnths    :  Integer)  :  LongDate;
    Var
      Vd,Vm,Vy : Word;
    Begin
      DateStr(LastVDate,Vd,Vm,Vy);
      AdjMnth(Vm,Vy,NoMnths);
      Vd:=Monthdays[Vm];
      Calc_NewVATPeriod:=StrDate(Vy,Vm,Vd);
    end;

    Procedure ReadDefaults;
    Var
      UsrIniF : TIniFile;
      I       : Byte;
    Begin { ReadDefaults }
      If FileExists (MainDir + 'WSTATION\SETUP.USR') Then Begin
        UsrIniF := TIniFile.Create(MainDir + 'WSTATION\SETUP.USR');
        Try
          With Company^, CompDet Do Begin
            CompName := UsrIniF.ReadString('CustDets', 'Name', CompName);
            
      {VM 02/05/2007  has been added to be able to set sql and b-trieve during the initial wizard}
            if Trim(sGetCompCode) = '' then
              CompCode := Auto_GetCompCode(CompName);
          End; { With }

          With Syss Do Begin
            For I := Low(DetailAddr) To High(DetailAddr) Do
              DetailAddr[I] := UsrIniF.ReadString('CustDets', 'Addr'+IntToStr(I), DetailAddr[I]);

            DetailFax := UsrIniF.ReadString('CustDets', 'Fax', DetailFax);
            DetailTel := UsrIniF.ReadString('CustDets', 'Phone', DetailTel);
          End; { With }
        Finally
          UsrIniF.Free;
        End;
      End; { If FileExists }
    End; { ReadDefaults }

  Begin
    CompDetail1 := Nil;
    CompDetail2 := Nil;
    CompDetail3 := Nil;
    CompDetail4 := Nil;
    CompDetail5 := Nil;
    frmCompWizStockCats := NIL;
    Try
      //CurrDlg := 1;
      CurrDlg := 2;

      {VM 02/05/2007  has been added to be able to set sql and b-trieve during the initial wizard}
      GetVariable(DLLParams, 'V_GETCOMPCODE', sGetCompCode);
      GetVariable(DLLParams, 'V_GETCOMPNAME', sGetCompName);


      If (Not IsUpg) Then
        ReadDefaults;

      // MH 01/11/05: Check whether we need to display the LITE Stock Categories dialog
      // MH 20/03/06: Check we have a Stock version!
      WantStkCats := (W_InstallType = 'L') And (W_ModuleVer > '0');
      If WantStkCats Then
      Begin
        // Don't do if stock already in the table - i.e. Demo data installed or stock copied
        // into a new company from another dataset using the Data Copy Wizard
        WantStkCats := (Used_Recs(F[StockF], StockF) = 0);
      End; // If WantStkCats

      Repeat
        ExCode := ' ';

        Case CurrDlg Of
          1 : Begin
                If Not Assigned(CompDetail1) Then Begin
                  CompDetail1 := TCompDetail1.Create(Application);

                  With Company^, CompDetail1 Do Begin
                    Editing := Not NewComp;
                    OrigCode := Trim(CompDet.CompCode);

                    {check if company code and company name has been informed}
                    if (Trim(sGetCompCode) <> '') and (Trim(sGetCompName) <> '') then
                    begin
                      // VM: 21/06/2007  removed to avoid updating the company code
                      cpName.OnExit := nil;

                      cpCode.Text := Trim(sGetCompCode);
                      cpName.Text := Trim(sGetCompName);

                      // check if it is sql...
                    end
                    else
                    begin
                      // VM: 21/06/2007 removed to avoid updating the company code
                      cpName.OnExit := nil;

                      cpCode.Text := Trim(CompDet.CompCode);
                      cpName.Text := Trim(CompDet.CompName);

                    end; {else begin}

                    If IsUpg Then
                      NextBtn.Caption := '&Finish';
                  End; { With }
                End; { If }

                // VM: 21/06/2007 as we moved the first dialog to the beginning of the install, we start it using number 2
                //CompDetail1.ShowModal;
                //ExCode := CompDetail1.ExitCode;
                ExCode := 'N';

                If IsUpg And (ExCode = 'N') Then Begin
                  { Exit loop }
                  ExCode := DoneCode;
                End; { If }
              End;
          2 : Begin
                If Not Assigned(CompDetail2) Then Begin
                  CompDetail2 := TCompDetail2.Create(Application);

                // VM: 21/06/2007 as we moved the first dialog to the beginning of the install, we start it using number 2
                  CompDetail2.BackBtn.Visible := False;

                  With CompDetail2 Do Begin
                    cpAddr1.Text := Syss.DetailAddr[1];
                    cpAddr2.Text := Syss.DetailAddr[2];
                    cpAddr3.Text := Syss.DetailAddr[3];
                    cpAddr4.Text := Syss.DetailAddr[4];
                    cpAddr5.Text := Syss.DetailAddr[5];
                  End; { With }
                End; { If }

                CompDetail2.ShowModal;

                ExCode := CompDetail2.ExitCode;
              End;
          3 : Begin
                If Not Assigned(CompDetail3) Then Begin
                  CompDetail3 := TCompDetail3.Create(Application);

                  With CompDetail3 Do Begin
                    cpPhone.Text := Trim(Syss.DetailTel);
                    cpFax.Text   := Trim(Syss.DetailFax);

                    { Clear defaults and add country entries for licence }
                    cpCountry.Items.Clear;
                    Case LicCntry Of
                      0 : Begin { All Countries }
                            AddOz;
                            AddEire;
                            AddNZ;
                            AddSing;
                            AddRSA;
                            AddUK;
                          End;
                      1 : Begin { UK }
                            AddUK;
                          End;
                      2 : Begin { NZ }
                            AddNZ;
                          End;
                      3 : Begin { Sing }
                            AddSing;
                          End;
                      4 : Begin { Aus }
                            AddOz;
                          End;
                      5 : Begin { EIRE }
                            AddEIRE;
                          End;
                      6 : Begin { RSA }
                            AddRSA;
                          End;
                    End; { Case }

                    If (cpCountry.Items.Count = 1) Then Begin
                      cpCountry.ItemIndex := 0;
                      cpCountry.Enabled := False;
                    End; { If (cpCountry.Items.Count = 1) }
                  End; { With }
                End; { If }

                CompDetail3.ShowModal;

                ExCode := CompDetail3.ExitCode;
              End;
          4 : Begin
                If Not Assigned(CompDetail4) Then Begin
                  CompDetail4 := TCompDetail4.Create(Application);

                  With CompDetail4, Syss, SyssVAT^, VATRates Do Begin
                    cpVatNo.Text         := UserVATReg;
                    cpLastRet.DateValue  := VATReturnDate;
                    cpVATMonth.Value     := VATInterval;
                    //cpVatCash.Checked    := (VATScheme = VATCAScheme);
                    cpVatIntra.Checked   := IntraStat;
                  End; { With }
                End; { If }

                CompDetail4.ShowModal;

                ExCode := CompDetail4.ExitCode;
              End;
          5 : Begin
                If Not Assigned(CompDetail5) Then
                Begin
                  CompDetail5 := TCompDetail5.Create(Application);

                  // MH 25/10/05: Added 6th dialog for LITE Installer
                  If (W_InstallType = 'L') Then
                  Begin
                    CompDetail5.NextBtn.Caption := '&Next >>';
                  End; // If (W_InstallType = 'L')

                  With CompDetail5, Syss Do Begin
                    cpYearStart.DateValue := MonWk1;
                    CpPeriods.Value       := PrinYr;
                  End; { With }
                End; { If }

                CompDetail5.ShowModal;

                ExCode := CompDetail5.ExitCode;

                // MH 25/10/05: Added 6th dialog for LITE Installer
                If (Not WantStkCats) And (ExCode = 'N') Then Begin
                  { Exit loop }
                  ExCode := DoneCode;
                End; { If }
              End;

          // LITE Only - Stock Categories
          6 : Begin
                If Not Assigned(frmCompWizStockCats) Then
                Begin
                  frmCompWizStockCats := TfrmCompWizStockCats.Create(Application);
                End; { If }

                frmCompWizStockCats.ShowModal;

                ExCode := frmCompWizStockCats.ExitCode;

                If (ExCode = 'N') Then Begin
                  { Exit loop }
                  ExCode := DoneCode;
                End; { If }
              End;
        Else
          CurrDlg := 1;
        End; { Case }

        Case ExCode Of
          'B' : Dec (CurrDlg);
          'N' : Inc (CurrDlg);
        End; { Case }
      Until (ExCode In [DoneCode, 'X']);

      If (ExCode = DoneCode) Then
      Begin

//        If Assigned (CompDetail1) And (Not IsUpg) Then
//          { Copy company information into setup record }
//          Syss.UserName := Trim(CompDetail1.cpName.Text);
        If (Not IsUpg) Then
          Syss.UserName := Trim(sGetCompName);

        If Assigned (CompDetail2) Then
          With CompDetail2 Do Begin
            Syss.DetailAddr[1] := cpAddr1.Text;
            Syss.DetailAddr[2] := cpAddr2.Text;
            Syss.DetailAddr[3] := cpAddr3.Text;
            Syss.DetailAddr[4] := cpAddr4.Text;
            Syss.DetailAddr[5] := cpAddr5.Text;
          End; { With }

        If Assigned (CompDetail3) Then
          With CompDetail3 Do Begin
            Syss.DetailTel := Trim(cpPhone.Text);
            Syss.DetailFax := Trim(cpFax.Text);

            If (cpCountry.ItemIndex > -1) Then Begin
              { Retrieve index value from coutry Code list }
              Cntry := LongInt (cpCountry.Items.Objects[cpCountry.ItemIndex]);

              Case Cntry Of
                0 : Syss.USRCntryCode := AUSCCode;     { Australia }
                1 : Syss.USRCntryCode := NZCCode;      { New Zealand }
                2 : Syss.USRCntryCode := SingCCode;    { Singapore }
                3 : Syss.USRCntryCode := UKCCode;      { South Africa - set to UK as they use VAT}
                4 : Syss.USRCntryCode := UKCCode;      { United Kingdom }
                5 : Syss.USRCntryCode := IECCode;      { Ireland }
              Else
                { Unknown - default to UK }
                MessageDlg ('An unknown Country Code was selected, the Country has ' +
                            'been defaulted to the United Kingdom', mtWarning, [mbOk], 0);
                Syss.USRCntryCode := UKCCode;          { United Kingdom }
              End; { Case Cntry }
            End; { If (cpCountry.ItemIndex > -1) }
          End; { With }

        If Assigned (CompDetail4) Then
          With CompDetail4, Syss, SyssVAT^.VATRates Do Begin
            UserVATReg           := cpVatNo.Text;
            VATReturnDate        := cpLastRet.DateValue;
            VATInterval          := Round(cpVATMonth.Value);
            //If cpVatCash.Checked Then VATScheme := VATCAScheme Else VatScheme := VATNoScheme;
            If (lstVATScheme.ItemIndex = 0) Then VATScheme := VATCAScheme Else VatScheme := VATNoScheme;
            IntraStat            := cpVatIntra.Checked;
            CurrPeriod           := Calc_NewVATPeriod (VATReturnDate, VATInterval);
          End; { With }

        If Assigned (CompDetail5) Then
          With CompDetail5, Syss Do Begin
            MonWk1 := cpYearStart.DateValue;
            PrinYr := Round(CpPeriods.Value);
          End; { With }

(*        If Assigned (CompDetail1) Then
          With Company^, CompDet Do Begin
            { Copy company information into new company record }
            CompCode := FullCompCode(Trim(CompDetail1.cpCode.Text));
            If (Not IsUpg) Then
              CompName := Syss.UserName
            Else
              CompName := Trim(CompDetail1.cpName.Text);
          End; { With }
          *)
          With Company^, CompDet Do Begin
            { Copy company information into new company record }
            CompCode := FullCompCode(Trim(sGetCompCode));
            If (Not IsUpg) Then
              CompName := Syss.UserName
            Else
              CompName := Trim(sGetCompName);
          End; { With }


        If Assigned(frmCompWizStockCats) Then
        Begin
          // LITE Stock Categories
          If (frmCompWizStockCats.GroupCount > 0) Then
          Begin
            For iCat := 0 To (frmCompWizStockCats.GroupCount - 1) Do
            Begin
              With frmCompWizStockCats.Groups[iCat] Do
              Begin
                FillChar(Stock, SizeOf(Stock), #0);
                With Stock Do
                Begin
                  StockFolio := iCat + 1;
                  StockCat := FullStockCode('');  // Root
                  StockCode := FullStockCode(caCode);
                  Desc[1] := LJVar(caDescription, StkDesKLen);
                  StockType := StkGrpCode;  // Group

                  // These irrelevent fields are needed to suppress errors whilst editing and
                  // to make the record identical to one added through Exchequer
                  DefCcy := IFThen(W_CurrVer = '0', 0, 1);
                  For iBand := Low(SaleBands) To High(SaleBands) Do
                  Begin
                    SaleBands[iBand].Currency := DefCcy;
                  End; // For iBand
                  PCurrency := DefCcy;
                  ROCurrency := DefCcy;
                  UnitK := 'each';
                  UnitS := 'each';
                  UnitP := 'each';
                  SellUnit := 1.0;
                  BuyUnit := 1.0;

                  LStatus := Add_Rec(F[StockF], StockF, RecPtr[StockF]^, StkCodeK);
                  If (LStatus <> 0) Then
                  Begin
                    MessageDlg ('An error ' + IntToStr(lStatus) + ' occurred whilst adding the Stock Group ' +
                                QuotedStr(caCode) + ', please notify your technical support', mtError, [mbOK], 0);
                  End; // If (LStatus <> 0)
                End; // With Stock
              End; // With frmCompWizStockCats.Groups[iCat]
            End; // For iCat
          End; // If (frmCompWizStockCats.GroupCount > 0)
        End; // If Assigned(frmCompWizStockCats)
      End; { If }
    Finally
      { Free the forms }
      If Assigned(CompDetail1) Then CompDetail1.Free;
      If Assigned(CompDetail2) Then CompDetail2.Free;
      If Assigned(CompDetail3) Then CompDetail3.Free;
      If Assigned(CompDetail4) Then CompDetail4.Free;
      If Assigned(CompDetail5) Then CompDetail5.Free;
      FreeAndNIL(frmCompWizStockCats);
    End;

    Result := (ExCode = DoneCode);
  End;

  {------------------------------------------------}

  { Update Setup records }
  Procedure UpdateCompanySyss;
  Var
    TempSys : ^Sysrec;
  Begin { UpdateCompanySyss }
    New (TempSys);

    { Retrieve Syss Record }
    TempSys^ := Syss;
    Move(SyssLockPos,Syss,Sizeof(SyssLockPos));
    LStatus:=GetDirect(F[SysF],SysF,RecPtr[SysF]^,0,0);
    If (LStatus = 0) Then Begin
      { Save changes to system setup record }
      Syss := TempSys^;
      LStatus := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, SysK);
      UnLockMultiSing(F[SysF], SysF, SyssLockPos);

      If (LStatus = 0) Then Begin
        { Retrieve SyssVAT Record }
        Move(VATLockPos,Syss,Sizeof(VATLockPos));
        Status:=GetDirect(F[SysF],SysF,RecPtr[SysF]^,0,0);

        If (LStatus = 0) Then Begin
          { Save changes to VAT record }
          Move (SyssVat^, Syss, SizeOf (Syss));
          Status := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, SysK);
          UnLockMultiSing(F[SysF], SysF, VATLockPos);
        End; { If }
      End; { If }
    End; { If }
  End; { UpdateCompanySyss }

  {------------------------------------------------}

  // MH 01/10/07: Added as Code/Name for Demo Companies was being ignored
  Procedure LoadDemoCompanyDets;
  Var
    sGetCompCode, sGetCompName: String;
  Begin // LoadDemoCompanyDets
    GetVariable(DLLParams, 'V_GETCOMPCODE', sGetCompCode);
    GetVariable(DLLParams, 'V_GETCOMPNAME', sGetCompName);

    Company^.CompDet.CompCode := FullCompCode(Trim(sGetCompCode));
    Company^.CompDet.CompName := Trim(sGetCompName);
  End; // LoadDemoCompanyDets

  {------------------------------------------------}

Begin { SCD_EntCompanyWizard }
  DllStatus := 0;

  Try
    { Check security parameter to ensure not called by anyone }
    Params := DLLParams.szParam;
    If (Copy (Params, 1, 7) = 'KJ3G831') And (Length(Params) = 7) Then Begin
      If Check4BtrvOk Then Begin
        { Get Installer Type from Wise, e.g. E=Exchequer, L=LITE, @=ICE Client-Sync }
        GetVariable(DLLParams, 'V_INSTALL', W_InstallType);

        { Get directory of main Enterprise directory }
        GetVariable(DLLParams, 'V_MAINDIR', MainDir);
        FixPath (MainDir);

        { Setup path of help file }
        Application.HelpFile := MainDir + 'WSTATION\SETUP.HLP';

        { Get directory of data to initialise }
        GetVariable(DLLParams, 'V_COMPDIR', CompDir);
        FixPath (CompDir);

        { Get Company Name from Licence details }
        GetVariable(DLLParams, 'D_COMPNAME', W_CompName);

        { See if its a Demo CD - skip wizard and add into MCM - default to Demo }
        IsDemo := True;
        GetVariable(DLLParams, 'I_LICTYPE', Temp);
        If (Length(Temp) > 0) Then Begin
          IsDemo := (UpperCase(Temp[1]) = '2');
        End; { If }

        If (Not IsDemo) Then Begin
          { Check we aren't installing Demo Data }
          GetVariable(DLLParams, 'V_DEMODATA', Temp);
          If (Length(Temp) > 0) Then Begin
            IsDemo := (UpperCase(Temp[1]) = 'Y');
          End; { If }
        End; { If }

        If (W_InstallType = '@') Then
        Begin
          // Client-Synch - get Company Came from installer
          GetVariable(DLLParams, 'D_COMPCODE', W_CompCode);
        End // If (W_InstallType = '@')
        Else
          // HM 15/05/00: Test mod for DL/DS/SB to change demo company names to be Demo instead of licenced name
          If IsDemo Then W_CompName := '';

        { See if its an upgrade }
        IsUpg := False;
        GetVariable(DLLParams, 'V_INSTTYPE', Temp);
        If (Length(Temp) > 0) Then Begin
          IsUpg := (UpperCase(Temp[1]) = 'B');
        End; { If }

        { Get Country Version for Licencing }
        LicCntry := 1;    { Default to UK }
        GetVariable(DLLParams, 'I_COUNTRY', Temp);
        If (Length(Temp) > 0) Then Begin
          LicCntry := StrToInt(Temp);
        End; { If }

        // Get Modules version so we only add Stock Categories if we have Stock!
        GetVariable(DLLParams, 'L_BASE', W_ModuleVer);

        // Get Currency version for adding Stock Categories with the correct default currencies
        GetVariable(DLLParams, 'L_CURRVER', W_CurrVer);


        { Open Company.Dat }
        If OpenDataFile (CompF, MainDir) Then Begin



          { Look for existing Company Details }
          GetCompanyDets (CompDir);



          { Open ExchQss.Dat }
          If OpenDataFile (SysF, CompDir) Then Begin


            { Allocate Company Id }
            DLLStatus := AllocateCID;


            If (DLLStatus = 0) Then
            Begin
              { Check Not Demo and Not Upgrading - unless Upgrading and Company Doesn't exist in MCM }
              If (Not IsDemo) And ((Not IsUpg) Or (IsUpg And NewComp)) Then Begin


                { Load setup records }
                If LoadCompanySyss Then Begin


                  // MH 01/11/05: Added opening of Stock table for LITE's Stock Categories
                  If OpenDataFile (StockF, CompDir) Then
                  Begin

                    Try

                      { Display wizard }
                      If Not CompanyWizard Then
                        { Company Wizard not completed }
                        DLLStatus := 1003;


                      If (DLLStatus = 0) Then Begin

                        { Update Setup records }
                        UpdateCompanySyss;


                        If (LStatus <> 0) Then Begin
                          { Error updating Exchqss.Dat }
                          DLLStatus := 1400 + LStatus;
                        End; { IF }
                      End; { If }
                    Finally
                      CloseDataFile(StockF);
                    End; // Try..Finally
                  End // If OpenDataFile (StockF, CompDir)
                  Else
                    { Error opening Stock.Dat }
                    DLLStatus := 1600 + LStatus;
                End { If }
                Else
                  { Error loading/locking SysR + VatR }
                  DLLStatus := 1300 + LStatus;
              End { If }
              Else
                // MH 01/10/07: Added as Code/Name for Demo Companies was being ignored
                // MH 24/10/07: Added check on upgrade as it was blanking out the root company
                If IsDemo And (Not IsUpg) Then
                Begin
                  LoadDemoCompanyDets;
                End; // If IsDemo And (Not IsUpg)
            End; // If (DLLStatus = 0)

            CloseDataFile(SysF);
          End { If }
          Else
            { Error Opening SysF }
            DLLStatus := 1500 + LStatus;

          If (DLLStatus = 0) Then Begin
            If (W_InstallType <> '@') Then
            Begin
              { Warn user to remember company code }
              MessageDlg ('This company has a code of ' +
                          UpperCase(Trim(Company^.CompDet.CompCode)) +
                          ', please make a note of this code as it will be needed to use the OLE Server.'
                          , mtInformation, [mbOk], 9);
            End; // If (W_InstallType <> '@')

            { Add entry into Company Database }
            UpdateCompany;

            If (LStatus <> 0) Then
              { Error updating Company.Dat }
              DLLStatus := 1200 + LStatus;
          End; { If }

          CloseDataFile(CompF);
        End { If }
        Else
          { Failed to open Company.Dat }
          DLLStatus := 1100 + LStatus;

      End { If }
      Else Begin
        { Btrieve Not Running }
        DLLStatus := 1002;
      End; { Else }
    End { If }
    Else Begin
      { Incorrect security parameter - return false }
      DLLStatus := 1001;
    End; { Else }
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      DLLStatus := 1000;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_EntCompanyWizard }


{-----------------------------------------------------------------------------}


{ Replicate main security for new sets of company data }
//
// 1000        Unknown Exception
// 1001        Incorrect security parameter
// 1002        Btrieve Not Running
// 1100..1199  Btrieve Error opening SysF in Main Ent dir
// 1200..1299  Btrieve Error getting ModRR in Main Ent dir
// 1300..1399  Btrieve Error getting SysR in Main Ent dir
// 1400..1499  Btrieve Error opening SysF in Company Dir
// 1500..1599  Btrieve Error getting ModRR in Company Dir
// 1600..1699  Btrieve Error getting SysR in Company Dir
// 1700..1799  Btrieve Error opening PwrdF in Company Dir
function SCD_EntCopyMainSecurity(var DLLParams: ParamRec): LongBool;
Const
  FNum    = SysF;
  KeyPath = SysK;
Var
  LocSys, LocMod   : ^Sysrec;
  KeyS             : Str255;
  Params           : ANSIString;
  DlgPN, MainDir   : String;
  W_Country        : String;
  oCoPath          : ShortString;
Begin { EntCopyMainSecurity }
  Try
    DllStatus := 0;

    { Check security parameter to ensure not called by anyone }
    Params := DLLParams.szParam;  { GAS7G2 }
    If (Copy (Params, 1, 4) = 'GH92') And (Length(Params) = 4) Then Begin
      If Check4BtrvOk Then Begin
        { Get directory of data to initialise }
        GetVariable(DLLParams, 'V_COMPDIR', DlgPN);
        FixPath (DlgPN);

        { Get directory of main company }
        GetVariable(DLLParams, 'V_MAINDIR', MainDir);
        FixPath (MainDir);

        { Get Country version from WISE - 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }
        GetVariable(DLLParams, 'I_COUNTRY', W_Country);

        { Open ExchQss.Dat in Main Company}
        If OpenDataFile (FNum, MainDir) Then Begin
          { Opened - get SysR and ModRR records }
          New (LocSys);
          New (LocMod);

          KeyS := SysNames[ModRR];
          Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

          If StatusOk Then Begin
            { Got ModRR - Copy into local record }
            Move(Syss,LocMod^,Sizeof(LocMod^));

            KeyS := SysNames[SysR];
            Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
            If StatusOk Then Begin
              { Got SysR - Copy into local record }
              Move(Syss,LocSys^,Sizeof(LocSys^));

//ShowMessage ('Root Company'#13 +
//             '  ExSecurity: ' + LocSys^.ExSecurity + #13 +
//             '  ExRelease: ' + LocSys^.ExRelease + #13 +
//             '  ExRelDate: ' + FloatToStr(LocSys^.RelDate));

              { Close Main Company ExchQSS.Dat and open New Company ExchQSS.Dat }
              CloseDataFile(FNum);
              If OpenDataFile (FNum, DlgPN) Then Begin
                If OpenDataFile (PwrdF, DlgPN) Then Begin
                  { Get and update SysR record - no need to lock as file just installed }
                  KeyS := SysNames[SysR];
                  Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
                  If StatusOk Then Begin
                    { Copy Security across }
                    With Syss Do Begin
                      { Copy security and users in from main company record }
                      ExUsrSec     := LocSys^.ExUsrSec;
                      ExUsrRel     := LocSys^.ExUsrRel;
                      UsrRelDate   := LocSys^.UsrRelDate;
                      ExSecurity   := LocSys^.ExSecurity;
                      ExRelease    := LocSys^.ExRelease;
                      RelDate      := LocSys^.RelDate;

                      ExISN        := LocSys^.ExISN;
                      ExDemoVer    := LocSys^.ExDemoVer;

                      { HM 23/11/99: Added to copy country code from main company }
                      USRCntryCode := GetCountryCode (W_Country);

                      // MH 16/02/06: Added copying of Theme information
                      UseBkTheme := LocSys^.UseBkTheme;
                      BKThemeNo := LocSys^.BKThemeNo;
                    End; { With Syss }

//ShowMessage ('New Company'#13 +
//             '  ExSecurity: ' + Syss.ExSecurity + #13 +
//             '  ExRelease: ' + Syss.ExRelease + #13 +
//             '  ExRelDate: ' + FloatToStr(Syss.RelDate));

//Syss.ExRelease := 'Wibble';

                    { Update Syss }
                    Status := Put_Rec(F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath);
//ShowMessage ('New Company Put_Rec: ' + IntToStr(Status));

                    { Use LocSys to record New Company Syss record }
                    Move(Syss,LocSys^,Sizeof(LocSys^));
                  End { If }
                  Else Begin
                    { Error Getting SysF in Company Dir }
                    DLLStatus := 1500 + Status;
                  End; { Else }

                  If StatusOk Then Begin
                    { Get and update ModRR record - no need to lock as file just installed }
                    KeyS := SysNames[ModRR];
                    Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
                    If StatusOk Then Begin
                      { Copy Module Release Codes across }
                      Syss := LocMod^;

                      { Update ModRR }
                      Status := Put_Rec(F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath);
                    End { If }
                    Else Begin
                      { Error Getting SysR in Company Dir }
                      DLLStatus := 1600 + Status;
                    End { Else }
                  End; { If }

                  If StatusOk Then Begin
                    { HM 16/11/99: Update duplicate security record }
                    Move(Syss,SyssMod^,Sizeof(SyssMod^));
                    Move(LocSys^,Syss,Sizeof(LocSys^));

                    // HM 23/11/00: Modified so it doesn't attempt to update the licence file
                    oCoPath := ExMainCoPath^;
                    ExMainCoPath^ := 'Wibble';
                    TrackSecUpdates(True);
                    ExMainCoPath^ := oCoPath;
                  End; { If StatusOK }

                  CloseDataFile(PwrdF);
                End { If }
                Else Begin
                  { Error opening PwrdF in Company Dir }
                  DLLStatus := 1700 + LStatus;
                End; { Else }
              End { If }
              Else Begin
                { Error opening SysR in Company Dir }
                DLLStatus := 1400 + LStatus;
              End; { Else }
            End { If }
            Else Begin
              { Error getting SysR }
              DLLStatus := 1300 + Status;
            End; { Else }
          End { If }
          Else Begin
            { Error getting ModRR }
            DLLStatus := 1200 + Status;
          End; { Else }

          Dispose (LocSys);
          Dispose (LocMod);

          CloseDataFile(SysF);
        End { If OpenDataFile (FNum, DlgPN) }
        Else Begin
          { Error opening SysF in Main Ent dir }
          DLLStatus := 1100 + LStatus;
        End; { Else }
      End { If }
      Else Begin
        { Btrieve Not Running }
        DLLStatus := 1002;
      End; { Else }
    End { If }
    Else Begin
      { Incorrect security parameter - return false }
      DLLStatus := 1001;
    End; { Else }
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      DLLStatus := 1000;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { EntCopyMainSecurity }


{ Copies data into a new company }
function SCD_EntDataCopy(var DLLParams: ParamRec): LongBool;
//Var
//  MainComp, NewComp, W_Install, lDbType : String;
Begin { SCD_EntDataCopy }
Result := False;
MessageDlg ('SCD_EntDataCopy Not Supported - please notify your technical support', mtError, [mbOK], 0);
(****
  {$IFDEF HMTEST}
    ShowMessage ('EntDataCopy');
    Result := False;
  {$ELSE}
    DllStatus := 0;

    { Get Installation Directories from WISE }
    { Main Company }
    GetVariable(DLLParams, 'V_MAINDIR', MainComp);
    FixPath (MainComp);

    { Setup path of help file }
    Application.HelpFile := MainComp + 'WSTATION\SETUP.HLP';

    { New Company }
    GetVariable(DLLParams, 'V_COMPDIR', NewComp);
    FixPath (NewComp);

    // Installer Type
    GetVariable(DLLParams, 'V_INSTALL', W_Install);

    // database type
    GetVariable(DLLParams, 'L_DBTYPE', lDbType);

    { Check paths are valid }
{$IFDEF EXSQL}
    if SQLUtils.ValidSystem(MainComp) then
{$ELSE}
    If FileExists (MainComp + 'ENTCOMP.DLL') And FileExists (MainComp + 'COMPANY.DAT') Then
{$ENDIF}
    Begin
      // Run the Copy Data wizard
      If (W_Install = 'L') Then
        CopyCompanyData (lDbType = '1', MainComp, NewComp, cdmLITE)
      Else
        CopyCompanyData (lDbType = '1', MainComp, NewComp, cdmExchequer);
    End { If }
    Else Begin
      DllStatus := 1;
      MessageDlg ('The directory containing the main company is invalid' + #10#13#10#13 +
                  MainComp, mtError, [mbOk], 0);
    End; { Else }

    Result := (DllStatus <> 0);
  {$ENDIF}
****)
End; { SCD_EntDataCopy }


(***** HM 09/01/02: Removed as not apparently used anywhere
{ Sets the User Licence Count }
function SCD_SetULC(var DLLParams: ParamRec): LongBool;
Const
  FNum    = SysF;
  KeyPath = SysK;
Var
  LocSys          : ^Sysrec;
  KeyS            : Str255;
  Params          : ANSIString;
  DlgPN, MainDir  : String;
  Locked          : Boolean;
  CurSecy, UCount : LongInt;
  Err             : Integer;

  { Generates the final User Release Code }
  Function Gen_UsrRelCode (SecStr  :  Str20;
                           NoUsrs  :  LongInt)  :  Str20;
  Var
    SecNo  :  LongInt;
  Begin { Gen_UsrRelCode }
    SecNo:=Calc_Security(SecStr,BOff);

    If (SecNo>MaxUsrRel) then
      SecNo:=MaxUsrRel;

    SecNo:=SecNo+(NoUsrs*UsrSeed);

    Gen_UsrRelCode:=Calc_SecStr(SecNo,BOn);
  End; { Gen_UsrRelCode }

Begin { SCD_SetULC }
  DllStatus := 0;
  Result := True;

  { Check security parameter to ensure not called by anyone }
  Params := DLLParams.szParam;
  If (Copy (Params, 1, 6) = 'SKH7D7') And (Length(Params) = 6) Then Begin
    If Check4BtrvOk Then Begin
      { Get directory of main company }
      GetVariable(DLLParams, 'V_MAINDIR', MainDir);
      FixPath (MainDir);

      { Get required User Count and convert to number }
      GetVariable(DLLParams, 'L_UCOUNT', DlgPN);
      Val (DlgPn, UCount, Err);

      If (Err = 0) And (UCount > 0) Then Begin
        { Open ExchQss.Dat in Main Company}
        If OpenDataFile (FNum, MainDir) Then Begin
          { Opened - get SysR record }
          New (LocSys);

          KeyS := SysNames[SysR];
          Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
          If StatusOk Then Begin
            { Got SysR - Lock It }
            Locked := False;
            If GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPath,FNum,BOn,Locked) Then Begin
              { Update User Count }
              CurSecy  := Set_Security;
              Syss.ExUsrSec := Calc_SecStr(CurSecy, False);
              Syss.ExUsrRel := Gen_UsrRelCode(Syss.ExUsrSec,UCount);
              //UsrRelDate :=   Not used?

              { Update Syss }
              Status := Put_Rec(F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath);

              { Return True if failed }
              Result := (Status <> 0);
            End; { If }
          End; { If }

          Dispose (LocSys);

          CloseDataFile(SysF);
        End; { If OpenDataFile (FNum, MainDir) }
      End; { If (Err = 0) And (UCount > 0) }
    End; { If Check4BtrvOk }
  End; { If }
End; { SCD_SetULC }
*****)

end.
