unit EntInitU;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Forms, Dialogs, SysUtils;

Const
  VATCAScheme    =  'C';  {* VAT Cash Accounting Trigger *}
  VATNoScheme    =  'N';  {* VAT Normal Scheme           *}

Procedure InitCompany (ExeDir, DataDir, InstDir : String; InitSecurity, WantMainSec, InitComp, IsDemo, IsUpdate : Boolean);
Function Auto_GetCompCode(CompName : ShortString) : ShortString;

implementation

Uses BtrvU2, GlobVar, VarConst, EntRegU, ETStrU, ETDateU, CompWiz1, CompWiz2, CompWiz3,
     CompWiz4, CompWiz5, ETMiscU, BtKeys1U, SecWarn, SysU1;


{ Returns a guestimate code based on the company name }
Function Auto_GetCompCode(CompName : ShortString) : ShortString;
Const
  FNum    = CompF;
  KeyPath : Integer = CompCodeK;
Var
  KeyS       : Str255;
  TmpStat, Stat : Integer;
  TmpRecAddr : LongInt;
  TmpComp    : CompRec;
  n          : Byte;
Begin
  TmpComp:=Company^;
  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOff,BOff);

  CompName := Copy (UpperCase (Strip('A', [#0, #32], CompName)), 1, (CompCodeLen - 2));
  n:=1;

  Repeat
    KeyS := FullCompCodeKey(cmCompDet, CompName + SetPadNo(IntToStr(n), 2));
    Stat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (Stat = 0) then
      Inc(n);
  Until (Stat <> 0) or (n=99);

  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOn,BOff);

  Company^ := TmpComp;

  Result:=Copy (KeyS, 2, CompCodeLen);
end; {Func..}


{ Sets up a new company or registers and existing company with the multi-company manager }
Procedure InitCompany (ExeDir, DataDir, InstDir : String; InitSecurity, WantMainSec, InitComp, IsDemo, IsUpdate : Boolean);
Var
  MainSyss, CDSyss                     : ^Sysrec;
  ModSyss, CDMod                       : ^Sysrec;
  ModLockPos,
  CompLockPos, SyssLockPos, VATLockPos : LongInt;
  NewComp                              : Boolean;
  TmpCompany                           : CompRec;

  { Gets the security and user information from the main system }
  Procedure GetMainSecurity;
  Const
    FNum    = SysF;
    KeyPath = SysK;
  Var
    KeyS : Str255;
  Begin
    { Open System File }
    Status := Open_File(F[FNum], ExeDir + FileNames[FNum], 0);

    If StatusOk Then Begin
      { Get security and User info }
      KeyS := SysNames[SysR];
      Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

      If StatusOk Then Begin
        { got main system setup record }
        MainSyss^ := Syss;

        { HM 20/01/98: Added copying of Module Release info }
        { Get Module Release Code record }
        KeyS := SysNames[ModRR];
        Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        If StatusOk Then Begin
          { take local copy }
          ModSyss^ := Syss;
        End { If }
        Else
          { failed to get record }
          DllStatus := 11000 + Status;
      End { If }
      Else
        { failed to get record }
        DllStatus := 11100 + Status;

      { Close system file }
      Close_File(F[FNum]);
    End { If }
    Else
      { failed to get record }
      DllStatus := 11200 + Status;
  End;

  { Gets the security and user information from the EXCHQSS.DAT shipped on CD }
  Procedure GetShippedSecurity;
  Const
    FNum    = SysF;
    KeyPath = SysK;
  Var
    KeyS : Str255;
  Begin
    { Open System File }
    Status := Open_File(F[FNum], InstDir + FileNames[FNum], 0);

    If StatusOk Then Begin
      { Get security and User info }
      KeyS := SysNames[SysR];
      Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

      If StatusOk Then Begin
        { got main system setup record }
        CDSyss^ := Syss;

        { HM 20/01/98: Added copying of Module Release info }
        { Get Module Release Code record }
        KeyS := SysNames[ModRR];
        Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        If StatusOk Then Begin
          { take local copy }
          CDMod^ := Syss;
        End { If }
        Else
          { failed to get record }
          DllStatus := 10000 + Status;
      End { If }
      Else
        { failed to get record }
        DllStatus := 10100 + Status;

      { Close system file }
      Close_File(F[FNum]);
    End { If }
    Else
      { failed to get record }
      DllStatus := 10200 + Status;
  End;

  { Gets and locks the System record from the new companies database }
  Function GetCompanySyss : Boolean;
  Const
    FNum    = SysF;
    KeyPath = SysK;
  Var
    KeyS   : Str255;
    Locked : Boolean;
  Begin
    { Lock record the hard way as I don't want to use BTSUPU1 }
    KeyS := SysNames[VATR];
    Status := Find_Rec(B_GetEq + B_SingNWLock + B_MultLock, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

    If StatusOk Then Begin
      { Copy into SyssVAT }
      Move(Syss,SyssVAT^,Sizeof(SyssVAT^));

      { Get record position for unlocking }
      Status := GetPos(F[Fnum], Fnum, VATLockPos);
    End; { If }

    { HM 20/01/98: Added copying of Module Release info }
    If StatusOK Then Begin
      { Get Module Release record }
      KeyS := SysNames[ModRR];
      Status := Find_Rec(B_GetEq + B_SingNWLock + B_MultLock, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

      If StatusOk Then Begin
        { Copy into SyssMod }
        Move(Syss,SyssMod^,Sizeof(SyssMod^));

        { Get record position for unlocking }
        Status := GetPos(F[Fnum], Fnum, ModLockPos);
      End; { If }
    End; { If }

    If StatusOk Then Begin
      { Get main System Setup record }
      KeyS := SysNames[SysR];
      Status := Find_Rec(B_GetEq + B_SingNWLock + B_MultLock, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

      If StatusOk Then
        Status := GetPos(F[Fnum], Fnum, SyssLockPos);
    End; { If }

    Result := StatusOk;
  End;

  { Resets the security expiry to @30 days from today }
  Procedure ResetSecurity;
  Const
    MaxDaysSecy  =  30;
  Var
    RelDateStr       : LongDate;
    Rd,Rm,Ry         : Word;
    RelDOW, RelMoveX : Byte;
  Begin
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
    End; { With }

    { Inform user that security code will expire in 30 days }
    SecurityWarning := TSecurityWarning.Create (Application);
    Try
      SecurityWarning.ShowModal;
    Finally
      SecurityWarning.Free;
    End;
  End;

  { Get any existing company details or setup new details }
  Procedure GetCompanyDets;
  Const
    FNum    = CompF;
    KeyPath = CompPathK;
  Var
    KeyS   : Str255;
  Begin
    NewComp := False;

    { Lock record the hard way as I don't want to use BTSUPU1 }
    KeyS := FullCompPathKey(cmCompDet, Trim(DataDir));
    Status := Find_Rec(B_GetEq + B_SingNWLock + B_MultLock, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

    If (Status = 0) And (UpperCase(Trim(Company^.CompDet.CompPath)) = UpperCase(DataDir)) Then Begin
      { Got the company details for the data directory }
      Status := GetPos(F[Fnum], Fnum, CompLockPos);
    End { If }
    Else Begin
      { No existing details found }
      NewComp := True;
      Status := 0;

      FillChar (Company^, SizeOf(Company^), #0);
      With Company^, CompDet do Begin
        RecPFix  := cmCompDet;
        CompName := Syss.UserName;
        CompCode := Auto_GetCompCode(CompName);
        CompPath := FullCompPath(DataDir);
      End; { With }
    End; { Else }
  End;

  { Display the date entry wizard }
  Function CompanyWizard : Boolean;
  Const
    DoneCode = 'D';
  Var
    CompDetail1 : TCompDetail1;
    CompDetail2 : TCompDetail2;
    CompDetail3 : TCompDetail3;
    CompDetail4 : TCompDetail4;
    CompDetail5 : TCompDetail5;
    ExCode      : Char;
    CurrDlg     : SmallInt;

    (* HM 27/03/02: Changed to use correct version in SysU1
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
    *)

  Begin
    Try
      CurrDlg := 1;
      CompDetail1 := Nil;
      CompDetail2 := Nil;
      CompDetail3 := Nil;
      CompDetail4 := Nil;
      CompDetail5 := Nil;

      Repeat
        ExCode := ' ';

        Case CurrDlg Of
          1 : Begin
                If Not Assigned(CompDetail1) Then Begin
                  CompDetail1 := TCompDetail1.Create(Application);

                  With Company^, CompDetail1 Do Begin
                    Editing := Not NewComp;
                    OrigCode := Trim(CompDet.CompCode);
                    cpCode.Text := Trim(CompDet.CompCode);
                    cpName.Text := Trim(CompDet.CompName);

                    If (Not InitComp) Then
                      NextBtn.Caption := '&Finish';
                  End; { With }
                End; { If }

                CompDetail1.ShowModal;

                ExCode := CompDetail1.ExitCode;

                If (Not InitComp) And (ExCode = 'N') Then Begin
                  { Exit loop }
                  ExCode := DoneCode;
                End; { If }
              End;
          2 : Begin
                If Not Assigned(CompDetail2) Then Begin
                  CompDetail2 := TCompDetail2.Create(Application);

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

                    If (Syss.USRCntryCode = '061') Then cpCountry.ItemIndex := 0      { Australia }
                    Else If (Syss.USRCntryCode = '064') Then cpCountry.ItemIndex := 1 { New Zealand }
                    Else If (Syss.USRCntryCode = '065') Then cpCountry.ItemIndex := 2 { Singapore }
                    Else If (Syss.USRCntryCode = '027') Then cpCountry.ItemIndex := 3 { South Africa }
                    Else cpCountry.ItemIndex := 4;                                    { UK }
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
                If Not Assigned(CompDetail5) Then Begin
                  CompDetail5 := TCompDetail5.Create(Application);

                  With CompDetail5, Syss Do Begin
                    cpYearStart.DateValue := MonWk1;
                    CpPeriods.Value       := PrinYr;
                  End; { With }
                End; { If }

                CompDetail5.ShowModal;

                ExCode := CompDetail5.ExitCode;

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

      If (ExCode = DoneCode) Then Begin
        If Assigned (CompDetail1) And (Not IsUpdate) Then
          { Copy company information into setup record }
          Syss.UserName := Trim(CompDetail1.cpName.Text);

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

            Case cpCountry.ItemIndex Of
              0 : Syss.USRCntryCode := '061';      { Australia }
              1 : Syss.USRCntryCode := '064';      { New Zealand }
              2 : Syss.USRCntryCode := '065';      { Singapore }
              3 : Syss.USRCntryCode := '044';      { South Africa - set to UK as they use VAT}
              4 : Syss.USRCntryCode := '044';      { United Kingdom }
            Else
                  Syss.USRCntryCode := '044';      { United Kingdom }
            End; { Case }
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

        If Assigned (CompDetail1) Then
          With Company^, CompDet Do Begin
            { Copy company information into new company record }
            CompCode := FullCompCode(Trim(CompDetail1.cpCode.Text));
            If (Not IsUpdate) Then
              CompName := Syss.UserName
            Else
              CompName := Trim(CompDetail1.cpName.Text);
          End; { With }
      End; { If }
    Finally
      { Free the forms }
      If Assigned(CompDetail1) Then CompDetail1.Free;
      If Assigned(CompDetail2) Then CompDetail2.Free;
      If Assigned(CompDetail3) Then CompDetail3.Free;
      If Assigned(CompDetail4) Then CompDetail4.Free;
      If Assigned(CompDetail5) Then CompDetail5.Free;
    End;

    Result := (ExCode = DoneCode);
  End;

Begin
{ShowMessage ('InitCompany.ExeDir: ' + ExeDir + #10#13 +
             'DataDir: ' + DataDir + #10#13 +
             'InstDir: ' + InstDir + #10#13 +
             'InitSecurity: ' + IntToStr(Ord(InitSecurity)) + #10#13 +
             'WantMainSec: ' + IntToStr(Ord(WantMainSec)) + #10#13 +
             'InitComp: ' + IntToStr(Ord(InitComp)) + #10#13 +
             'IsDemo: ' + IntToStr(Ord(IsDemo)) + #10#13 +
             'IsUpdate: ' + IntToStr(Ord(IsUpdate)));}

  { Get path of help file }
  Application.HelpFile := ExeDir + 'ENTREAD.HLP';

  If Check4BtrvOk Then Begin
    GetMem (MainSyss, SizeOf (MainSyss^));
    GetMem (ModSyss,  SizeOf (ModSyss^));
    GetMem (CDSyss, SizeOf (CDSyss^));
    GetMem (CDMod,  SizeOf (CDMod^));

    If IsDemo Then Begin
      { Get Licence info from supplied EXCHQSS.DAT on CD }
      GetShippedSecurity;
    End; { If }

    { Get existing security from main company }
    If WantMainSec Then
      GetMainSecurity;

    If DllStatusOk Then Begin
      { Set Data Path }
      SetDrive := DataDir;

      { Open new companies system setup file }
      Status := Open_File(F[SysF], DataDir + FileNames[SysF], 0);
      If StatusOk Then Begin
        { Open company database }
        Status := Open_File(F[CompF], ExeDir + FileNames[CompF], 0);
        If StatusOk Then Begin
          { Get and lock system setup record in NEW company }
          If GetCompanySyss Then Begin
            { Get and lock company details record or initialise a new record to add }
            GetCompanyDets;

            If (Not IsDemo) And ((Not IsUpdate) Or (IsUpdate And NewComp)) Then
              { Display wizard for user entry }
              If Not CompanyWizard Then
                DllStatus := 1001;

            { Reset security codes as necessary }
            If InitSecurity And DllStatusOk Then Begin
              If WantMainSec Then Begin
                { Copy security and users in from main company record }
                Syss.ExUsrSec   := MainSyss^.ExUsrSec;
                Syss.ExUsrRel   := MainSyss^.ExUsrRel;
                Syss.UsrRelDate := MainSyss^.UsrRelDate;
                Syss.ExSecurity := MainSyss^.ExSecurity;
                Syss.ExRelease  := MainSyss^.ExRelease;
                Syss.RelDate    := MainSyss^.RelDate;

                { HM 20/01/98: Added copying of Module Release info }
                Move (ModSyss^, SyssMod^, SizeOf (SyssMod^));
              End { If }
              Else Begin
                { Reset the security release code }
                ResetSecurity;

                If IsDemo Then Begin
                  { HM 30/06/98: Added copying of Module Release info for Demo Systems }
                  { from ExchQss.Dat shipped in CD Root                                }
                  Move (CDMod^, SyssMod^, SizeOf (SyssMod^));
                End; { If }
              End; { If }
            End; { If }

            If StatusOk and DllStatusOk Then Begin
              MainSyss^ := Syss;

              { Retrieve Syss Record }
              Move(SyssLockPos,Syss,Sizeof(SyssLockPos));
              Status:=GetDirect(F[SysF],SysF,RecPtr[SysF]^,0,0);

              Syss := MainSyss^;

              { Save changes to system setup record }
              Status := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, SysK);
            End; { If }
            { Unlock system setup record }
            UnLockMultiSing(F[SysF], SysF, SyssLockPos);

            If StatusOk and DllStatusOk Then Begin
              { Retrieve SyssVAT Record }
              Move(VATLockPos,Syss,Sizeof(VATLockPos));
              Status:=GetDirect(F[SysF],SysF,RecPtr[SysF]^,0,0);

              Move (SyssVat^, Syss, SizeOf (Syss));

              { Save changes to VAT record }
              Status := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, SysK);
            End; { If }
            { Unlock VAT setup record }
            UnLockMultiSing(F[SysF], SysF, VATLockPos);

            { HM 20/01/98: Added copying of Module Release info }
            If StatusOk and DllStatusOk Then Begin
              { Retrieve SyssMod Record }
              Move(ModLockPos,Syss,Sizeof(ModLockPos));
              Status:=GetDirect(F[SysF],SysF,RecPtr[SysF]^,0,0);

              Move (SyssMod^, Syss, SizeOf (Syss));

              { Save changes to Module Release Codes record }
              Status := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, SysK);
            End; { If }
            { Unlock Module Release Codes record }
            UnLockMultiSing(F[SysF], SysF, ModLockPos);

            If DllStatusOk Then Begin
              { Warn user to remember company code }
              MessageDlg ('This company has a code of ' +
                           UpperCase(Trim(Company^.CompDet.CompCode)) +
                           ', please make a note of this code as it will be needed to use the OLE Server.'
                            , mtInformation, [mbOk], 0);

              If NewComp Then
                { Add new company record }
                Status := Add_Rec(F[CompF], CompF, RecPtr[CompF]^, CompCodeK)
              Else Begin
                { take temp copy of comp }
                TmpCompany := Company^;

                { Restore position }
                Status := GetPos(F[CompF], CompF, CompLockPos);

                { copy rec back }
                Company^ := TmpCompany;

                { Update existing company record }
                Status := Put_Rec(F[CompF], CompF, RecPtr[CompF]^, CompCodeK);
              End; { Else }
            End; { IF }

            If (Not NewComp) Then
              { Unlock company record }
              UnLockMultiSing(F[CompF], CompF, CompLockPos);
          End; { If }

          { Close file }
          Close_File(F[CompF]);
        End; { If }

        { Close file }
        Close_File(F[SysF]);
      End; { If }
    End; { If }

    {If (Not StatusOK) Or (DllStatus <> 0) Then Begin
      DllStatus := 1;
      MessageDlg ('An error has occurred in the Company Setup Wizard' + #10#13#10#13 +
                  'Status: ' + IntToStr(Status) + ' / ' + IntToStr(DllStatus), mtError, [mbOk], 0);
    End; { If }

    { Stop Btrieve }
    Stop_B;

    FreeMem (CDMod,  SizeOf (CDMod^));
    FreeMem (CDSyss, SizeOf (CDSyss^));
    FreeMem (ModSyss,  SizeOf (ModSyss^));
    FreeMem (MainSyss, SizeOf (MainSyss^));
  End; { If }

  {ShowMessage ('EntInitCompany DLLStatus: ' + IntToStr(DLLStatus));}
End;


end.
