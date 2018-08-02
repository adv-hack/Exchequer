unit ERC;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, FileCtrl, Forms, SysUtils, Windows,
     {$IFNDEF VWERC}
       CustDets,
       LicRec,
     {$ENDIF}
     SerialU;

{$H-}

Const
  CurrERCVer = 1;

Type
  TStr30 = String[30];
  TStr50 = String[50];

  TErcRecType = Record
    { From CustDetsO }
    ercContact    : TStr30;
    ercCompany    : TStr30;
    ercAddr       : Array[1..5] Of TStr30;
    ercEmail      : TStr50;
    ercFax        : TStr30;
    ercPhone      : TStr30;
    ercDealer     : TStr50;
    ercDealerTown : TStr50;

    { From Entrprse.Lic/Dat }
    ercLicName   : String [45];                 { Company Name }
    ercLicSNo    : SerialNoStrType;             { CD Serial-No from Licence }

    { From Syss }
    ercUserName  : String[45];                  { Company Name }
    ercDetailTel : String[15];                  { Phone }
    ercISN       : Array [1..8] Of Byte;        { ISN }
    ercSecCode   : String[10];                  { Security Code }
    ercRelDate   : Real;                        { Expiry Date }

    { From ModR }
    ercModuleSec : Array[1..25,False..True] of String[10];
    ercRelDates  : Array[1..25] of Real;

    Spare        : Array[1..1024] Of Byte;
  End; { TErcRecType }

  TErcFileO = Class(TObject)
  Private
    FFileName : TFileName;
  Protected

  Public
    ErcRec  : TErcRecType;
    VerWord : Word;

    Constructor Create;

    {$IFNDEF VWERC}
    Function BuildErcFile (Const EntDir : ShortString; Var TempLicR : EntLicenceRecType; Var CustDetsO : TCustDetsDlg) : Boolean;
    Procedure Delete;
    {$ENDIF}
    {$IFDEF VWERC}
    Function LoadErcFile (Const ErcPath : ShortString) : Boolean;
    {$ENDIF}
  Published
    Property FileName : TFileName Read FFileName;
  End; { TErcFileO }


implementation

Uses
    {$IFNDEF VWERC}
      GlobVar,
      VarConst,
    {$ENDIF}
      Crypto,
      GlobExch,
      LicFuncU;


Constructor TErcFileO.Create;
Begin { Create }
  Inherited;

  FFileName := '';
End; { Create }

{$IFNDEF VWERC}
  { Creates the Erc file from various bit of info }
  Function TErcFileO.BuildErcFile (Const EntDir : ShortString; Var TempLicR : EntLicenceRecType; Var CustDetsO : TCustDetsDlg) : Boolean;
  Var
    OutF    : TFileStream;
    FName   : TFileName;
    BaseDir : ShortString;
    I       : LongInt;
  Begin { BuildErcFile }
    Result := False;

    Try
      { Decide where to put the temporary file }
      If DirectoryExists(EntDir + 'SWAP\') Then
        BaseDir := EntDir + 'SWAP\'
      Else
        BaseDir := EntDir;

      { Generate file name }
      I := 0;
      Repeat
        Inc(I);
        FName := BaseDir + IntToStr(I) + '.ERC';
      Until Not FileExists(FName);

      FFileName := FName;

      { Create file }
      OutF := TFileStream.Create (FFileName, fmCreate or fmOpenReadWrite);
      Try
        { Populate Erc Record with info }
        FillChar (ErcRec, SizeOf(ErcRec), #0);
        With ErcRec Do Begin
          { From CustDetsO }
          ercContact    := CustDetsO.Contact;
          ercCompany    := CustDetsO.Name;
          For I := Low(ercAddr) To High(ercAddr) Do
            ercAddr[I]  := CustDetsO.Address[I];
          ercEmail      := CustDetsO.EmailAddr;
          ercFax        := CustDetsO.Fax;
          ercPhone      := CustDetsO.Phone;
          ercDealer     := CustDetsO.Dealer;
          ercDealerTown := CustDetsO.DealerTown;

          { From Entrprse.Lic/Dat }
          ercLicName   := TemplicR.licCompany;
          ercLicSNo    := TempLicR.licSerialNo;

          { From Syss }
          ercUserName  := Syss.UserName;
          ercDetailTel := Syss.DetailTel;
          For I := Low(ercISN) To High(ercISN) Do
            ercISN[I]  := Syss.ExISN[I];
          ercISN[7]    := licCalcESNByte7 (TempLicR.licISN, TempLicR.licLicType);
          ercSecCode   := Syss.ExSecurity;
          ercRelDate   := Syss.RelDate;

          { From ModR }
          For I := Low(ercModuleSec) To High(ercModuleSec) Do Begin
            ercModuleSec[I, False] := SyssMod^.ModuleRel.ModuleSec[I, False];
            ercModuleSec[I, True]  := SyssMod^.ModuleRel.ModuleSec[I, True];
          End; { For I }
          For I := Low(ercRelDates) To High(ercRelDates) Do
            ercRelDates[I] := SyssMod^.ModuleRel.RelDates[I];
        End; { With ErcRec }

        { Write Version info }
        VerWord := CurrERCVer;
        OutF.Position := 1;
        OutF.Write (VerWord, SizeOf(VerWord));

        { Write info to file }
        ChangeCryptoKey (12870);
        EncodeData (@ErcRec, SizeOf(ErcRec));

        { Write licence info to temporary file }
        OutF.Write (ErcRec, SizeOf(ErcRec));

        Result := True;
      Finally
        OutF.Free;
      End;
    Except
      On Ex:Exception Do Begin
        GlobExceptHandler(Ex);
        Result := False;
      End; { On }
    End;
  End; { BuildErcFile }

  Procedure TErcFileO.Delete;
  Begin { Delete }
    If FileExists (FFileName) Then
      SysUtils.DeleteFile (FFileName);
  End; { Delete }

{$ENDIF}

{$IFDEF VWERC}
  Function TErcFileO.LoadErcFile (Const ErcPath : ShortString) : Boolean;
  Var
    InF     : TFileStream;
    //FName  : TFileName;
    //I      : LongInt;
  Begin { LoadErcFile }
    Result := False;

    Try
      If FileExists (ErcPath) Then Begin
        InF := TFileStream.Create (ErcPath, fmOpenRead);
        Try
          { Read version word }
          InF.Position := 1;
          InF.Read (VerWord, SizeOf(VerWord));

          If (VerWord = CurrERCVer) Then Begin
            { Read licence info from temporary file }
            InF.Read (ErcRec, SizeOf(ErcRec));

            { Decrypt licence record }
            ChangeCryptoKey (12870);
            DecodeData (@ErcRec, SizeOf(ErcRec));

            Result := True;
          End { If }
          Else
            MessageDlg ('The ERC File Version is incorrect', mtError, [mbOk], 0);
        Finally
          InF.Free;
        End;
      End; { If FileExists }
    Except
      On Ex:Exception Do Begin
        GlobExceptHandler(Ex);
        Result := False;
      End; { On }
    End;
  End; { LoadErcFile }
{$ENDIF}

Initialization
  {ShowMessage ('TErcRecType: ' + IntToStr(SizeOf(TErcRecType)));}
end.
