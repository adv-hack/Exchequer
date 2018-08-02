unit EntLic;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$IFDEF WIN32}
  {$ALIGN 1}  { Variable Alignment Disabled }
{$ENDIF}


interface

Uses

{$IFDEF WIN32}
  Classes, Dialogs, Forms, SysUtils, Windows,
   {$IFDEF COMP}
     GlobVar, VarConst,

   {$ENDIF}

{$ELSE}
  OPDOS,
  ETPrompt,
{$ENDIF}

     LicRec;


Type
  SigBytesType = Array [1..5] Of Byte;

  EntLicRecType = Record
    elSigBytes  : SigBytesType;
    elVerByte   : Byte;
    elLicR      : EntLicenceRecType;
  End; { EntLicRecType }

Const
  EntLicFName  = 'ENTRPRSE.DAT';

  SigBytes : SigBytesType = (255, 254, 253, 254, 255);

  v440VerByte = 1;
  v600VerByte = 2;
  {$IFDEF LIC600}
  VerByte     : Byte = v600VerByte;
  {$ELSE}
  VerByte     : Byte = 1;
  {$ENDIF}

{$IFDEF WIN32}
  {$IFNDEF PF_On}

  Var
    ExMainCoPath : ^ShortString;

  {$ENDIF}
{$ENDIF}


Function ReadEntLic (Const FileName          : String;
                     Var   LicR              : EntLicenceRecType) : Boolean;

Function WriteEntLic (Const FileName         : String;
                            LicR             : EntLicenceRecType) : Boolean;

(* HM 21/06/01: Moved to EntLic2 to removed the dependency on core Enterprise modules
Procedure UpdateEntLic(IsMCFlg  :  Boolean);
*)




 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  DateUtils,
  {$IFNDEF WIN32}
    { Exchequer }
    GlobVar,
    HelpSupU,
    VarConst,
    VarFPosU,
  {$ELSE}
    { Enterprise }

    {$IFDEF PF_On}
      // HM 10/07/02: Removed as not used and causing unwanted modules to be compiled into the Forms TK
      //HelpSupU,
      {$IFNDEF COMP}
        VarConst,
      {$ENDIF}
      VarFPosU,
    {$ENDIF}
  {$ENDIF}

  Crypto;

// MH 08/03/07: Rewrote for Exchequer v6.00 Licensing Changes
{$IFDEF WIN32}
  Function ReadEntLic (Const FileName  : String; Var LicR : EntLicenceRecType) : Boolean;
  Var
    InF : TFileStream;
    sPath : String;
    LicSigBytes : SigBytesType;
    LicVer : Byte;
    Bored : Boolean;
    TimeoutTime : TDateTime;

    //------------------------------

    Procedure Read440Lic;
    Var
      ReadLic : OldEnt440LicenceRecType;
      I       : SmallInt;
    Begin // Read440Lic
      // Read and decrypt v4.40 format Licence
      InF.Read (ReadLic, SizeOf(ReadLic));
      DecodeDataKey (25637, @ReadLic, SizeOf(ReadLic));

      // Copy fields across to the v6.00 format licence
      FillChar(LicR, SizeOf(LicR), #0);
      LicR.licLicType := ReadLic.licLicType;
      LicR.licType := ReadLic.licType;
      LicR.licCountry := ReadLic.licCountry;
      LicR.licCompany := ReadLic.licCompany;
      LicR.licISN := ReadLic.licISN;
      LicR.licSerialNo := ReadLic.licSerialNo;
      LicR.licEntCVer := ReadLic.licEntCVer;
      LicR.licEntModVer := ReadLic.licEntModVer;
      LicR.licEntClSvr := ReadLic.licEntClSvr;
      LicR.licUserCnt := ReadLic.licUserCnt;
      LicR.licClServer := ReadLic.licClServer;
      LicR.licCSUserCnt := ReadLic.licCSUserCnt;
      For I := Low(ReadLic.licModules) To High(ReadLic.licModules) Do
        LicR.licModules[I] := ReadLic.licModules[I];
      LicR.licExpiry := ReadLic.licExpiry;
      LicR.licDealer := ReadLic.licDealer;
      LicR.licResetModRels := ReadLic.licResetModRels;
      LicR.licESN2 := ReadLic.licESN2;
      LicR.licResetCountry := ReadLic.licResetCountry;
      For I := Low(ReadLic.licUserCounts) To High(ReadLic.licUserCounts) Do
        LicR.licUserCounts[I] := ReadLic.licUserCounts[I];
      LicR.licAutoUpgIssue := ReadLic.licAutoUpgIssue;
      LicR.licPSQLWGEVer := ReadLic.licPSQLWGEVer;
      LicR.licProductType := ReadLic.licProductType;
      LicR.licCDKey := ReadLic.licCDKey;
      LicR.licEntEdition := ReadLic.licEntEdition;

      {$IFDEF LIC600}
      LicR.licEntDB := DBBtrieve;
      {$ENDIF}
    End; // Read440Lic

    //------------------------------

    Procedure Read600Lic;
    Var
      ReadLic : EntLicenceRecType;
    Begin // Read600Lic
      // Read 600 Licence
      InF.Read (ReadLic, SizeOf(ReadLic));
      DecodeDataKey (25637, @ReadLic, SizeOf(ReadLic));
      LicR := ReadLic;
    End; // Read600Lic

    //------------------------------

  Begin // ReadEntLic
    Result := False;

    // Check to see if the filename is already pathed correctly, if so use path, else use ExMainCoPath
    sPath := ExtractFilePath(FileName);
    If (sPath = '') Or (Not FileExists(FileName)) Then
      sPath := ExMainCoPath^+FileName
    Else
      sPath := FileName;

    If FileExists (sPath) Then
    Begin
      // MH 18/06/08: Modified as Neil was getting read errors in BGA bespoke where it is
      // reading the licence dozens of times a second
      //InF := TFileStream.Create (sPath, fmOpenRead, fmShareDenyNone);

      Bored := False;
      TimeOutTime := IncSecond(Now, 10);
      Repeat
        Try
          InF := TFileStream.Create (sPath, fmOpenRead, fmShareDenyNone);
        Except
          InF := NIL;
          Bored := (Now > TimeOutTime);
          If (Not Bored) Then
            Sleep(10)
          Else
            Raise Exception.Create('EntLic.ReadEntLic: Error reading licence file');
        End; // Try..Except
      Until Assigned(InF) Or Bored;

      If Assigned(InF) and (Not Bored) Then
      Begin
        Try
          // Read header signature bytes
          InF.Read (LicSigBytes, SizeOf(LicSigBytes));
          If (LicSigBytes[1] = SigBytes[1]) And
             (LicSigBytes[2] = SigBytes[2]) And
             (LicSigBytes[3] = SigBytes[3]) And
             (LicSigBytes[4] = SigBytes[4]) And
             (LicSigBytes[5] = SigBytes[5]) Then
          Begin
            // Read header version byte
            InF.Read (LicVer, SizeOf(LicVer));

            Result := (LicVer In [v440VerByte, v600VerByte]);

            If Result Then
            Begin
              Case LicVer Of
                v440VerByte : Read440Lic;
                v600VerByte : Read600Lic;
              End; // Case LicVer
            End; // If Result
          End; // If (LicSigBytes[1] = SigBytes[1]) And ...
        Finally
          InF.Free;
        End; // Try..Finally
      End; // If Assigned(InF) and (Not Bored)
    End; // If FileExists (sPath)
  End; // ReadEntLic

{$ELSE}

  MH 08/03/07: DOS - Needs updating to handle different licence formats, if working in Delphi you need the EXWIN compiler def

  Function ReadEntLic (Const FileName  : String;
                       Var   LicR      : EntLicenceRecType) : Boolean;
  Var
    InF     : File Of EntLicRecType;
    EntLicR : EntLicRecType;

    IoRes   : Integer;

    {$IFNDEF WIN32}
      Result: Boolean;
    {$ELSE}
      AutoRetry : Boolean;
    {$ENDIF}

    sPath : String;
  Begin { ReadEntLic }
    Result := False;
    IORes:=0;

  {$IFDEF WIN32 }

  // HM 21/01/02: Added Report Loop to fix a unidentifiable problem reading the
  //              Enterprise Licence on an Enterprise System on Paul Rutherfords
  //              macahine.  This problem caused an Invalid Filename exception on
  //              the call to RESET, but worked fine the 2nd time, stepping through
  //              the code provided no clues and no other attempts to fix the problem
  //              met any success.

    AutoRetry := False;
    Repeat
      Try
  {$ELSE}
      {$I-}
  {$ENDIF}

        { Check file exists before opening it }

        {$IFDEF WIN32}
        // MH 09/02/06: After yet another case of frigging ExMainCoPath breaking the reading of the
        // licence I decided to write in a permanent fix to this code.

        // Check to see if the filename is already pathed correctly, if so use path, else use ExMainCoPath
        sPath := ExtractFilePath(FileName);
        If (sPath = '') Or (Not FileExists(FileName)) Then
          sPath := ExMainCoPath^+FileName
        Else
          sPath := FileName;

        If FileExists (sPath) Then Begin
        {$ELSE}
        sPath := ExMainCoPath^+FileName;
        If ExistFile (sPath) Then Begin
        {$ENDIF}
          { Open file }
          Assign (InF, sPath);
          Reset (InF);

          { Read signature, version and licence details }
          Read (InF, EntLicR);

          {$IFNDEF WIN32}
            IORes:=IOResult;

            Report_IOError(IORes,FileName);

          {$ENDIF}

          { Check the file signature and version }
          If (EntLicR.elSigBytes[1] = SigBytes[1]) And (EntLicR.elSigBytes[2] = SigBytes[2]) And
             (EntLicR.elSigBytes[3] = SigBytes[3]) And (EntLicR.elSigBytes[4] = SigBytes[4]) And
             (EntLicR.elSigBytes[5] = SigBytes[5]) And (EntLicR.elVerByte = VerByte)
             And (IORes=0) Then
          Begin
            { Decrypt licence info }
            ChangeCryptoKey (25637);
            DecodeData (@EntLicR.elLicR, SizeOf(EntLicR.elLicR));

            LicR := EntLicR.elLicR;

            Result := True;
          End; { If }

          {$IFDEF WIN32 }
            CloseFile(InF);
          {$ELSE}
            Close (InF);
            IORes:=IOResult;
          {$ENDIF}
        End; { If FileExists }

    {$IFDEF WIN32 }
      Except
        On Ex:Exception Do Begin
          Result := False;
          AutoRetry := Not AutoRetry;
        End;
      End;
    Until Result Or (Not AutoRetry);
    {$ELSE}

    {$I+}
    ReadEntLic:=Result;

    {$ENDIF}
  End; { ReadEntLic }
{$ENDIF}

{---------------------------------------------------------------------------}

Function WriteEntLic (Const FileName : String;
                            LicR     : EntLicenceRecType) : Boolean;
Var
  OutF    : File Of EntLicRecType;
  EntLicR : EntLicRecType;
  IORes   : Integer;
  sPath   : String[255];

  {$IFNDEF WIN32}
    Result: Boolean;

  {$ENDIF}


Begin { WriteEntLic }
  Result := False;  IORes:=0;

  {$IFDEF WIN32 }
  Try

    // MH 06/03/06: After yet another case of frigging ExMainCoPath breaking the writing of the
    // licence I decided to write in a permanent fix to this code.

    // Check to see if the filename is already pathed correctly, if so use path, else use ExMainCoPath
    sPath := ExtractFilePath(FileName);
    If (sPath = '') Or (Not DirectoryExists(sPath)) Then
      sPath := ExMainCoPath^+FileName
    Else
      sPath := FileName;

  {$ELSE}

    {$I-}

    sPath := ExMainCoPath^+FileName;

  {$ENDIF}

    { Open file }
    Assign (OutF, sPath);
    Rewrite (OutF);

    {$IFNDEF WIN32}
      IORes:=IOResult;

      Report_IOError(IORes,FileName);

    {$ENDIF}

    If (IORes=0) then
    Begin

      FillChar (EntLicR, SizeOf(EntLicR), #0);
      With EntLicR Do Begin
        elSigBytes := SigBytes;
        elVerByte  := VerByte;
        elLicR     := LicR;
      End; { With EntLicR }

      { Encrypt licence info }
      ChangeCryptoKey (25637);
      EncodeData (@EntLicR.elLicR, SizeOf(EntLicR.elLicR));

      Write (OutF, EntLicR);

      {$IFNDEF WIN32}
        IORes:=IOResult;

        Report_IOError(IORes,FileName);

        {$IFDEF SCUD1X}
           PopAnyKey(3,PopGenW,ExMainCoPAth^+FileName+' written OK!');

        {$ENDIF}
      {$ENDIF}

      Result := True;

    {$IFDEF WIN32 }
      CloseFile(OutF);
    {$ELSE}
      Close (OutF);

      {$I+}

    {$ENDIF}

    end; {If IO result =0}
  {$IFDEF WIN32 }
  Except
    On Ex:Exception Do
      Result := False;
  End;
  {$ELSE}

    WriteEntLic:=Result;


  {$ENDIF}
End; { WriteEntLic }

(*
Function WriteEntLic (Const FileName         : String;
                            LicR             : LicenceRecType) : Boolean;
Var
  dupLicR     : ^LicenceRecType;
  FStream     : TFileStream;
Begin { WriteEntLic }
  Result := False;

  Try
    FStream := TFileStream.Create (FileName, fmCreate Or fmOpenReadWrite);
    Try
      { Write 5 Header Signature bytes }
      FStream.Write (SigBytes, SizeOf(SigBytes));

      { Write Version Info }
      FStream.Write (VerByte, SizeOf(VerByte));

      { Write Licence Record }
      New (dupLicR);
      dupLicR^ := LicR;
      ChangeCryptoKey (25637);
      EncodeData (dupLicR, SizeOf(dupLicR^));
      FStream.Write (dupLicR^, SizeOf(dupLicR^));
      Dispose (dupLicR);

      Result := True;
    Finally
      FStream.Free;
    End;
  Except
    On Ex:Exception Do
      Result := False;
  End;
End; { WriteEntLic }
*)


{* Mark this probably will not compile for you, so you will need to place an empty version of UpdateEntLic for
   yourself and use compiler switches at this point to expose the dummy or correct version as desired *}
(*
  Procedure UpdateEntLic(IsMCFlg  :  Boolean);
  {$IFNDEF TRADE}
  {$IFNDEF SETD}
  {$IFNDEF EBEX}  { eBusiness Export }
  {$IFNDEF HKSEC} { Hook Security DLL }
  Const
    RelTxLate  :  Array[1..ModLast] of Integer =
             {(0, modJobCost, modRepWrt, modToolDLLR, modTeleSale,modAccStk,modEBus,0,0,0,0,0);}
             (0, modJobCost, modRepWrt, modToolDLLR, modTeleSale,modAccStk,modEBus,modPaperless,modOLESave,modCommit,
              modTrade,0,0);



  Var
    LicRec  :  LicenceRecType;
    n,Idx   :  Integer;


  {* Status flags opposite way around than mod rel, function copies them around. *}

  Function  SetLicMod(Idx  :  Integer)  :  Integer;

  Begin
    Case Idx of

      1    :  SetLicMod:=3-Idx;
      else    SetLicMod:=0;

    end; {Case..}

  end;


  Begin

    If Not (ReadEntLic (EntLicFName,LicRec)) then
      FillChar (LicRec, SizeOf(LicRec), #0);

    With LicRec do
    Begin
      {$IFNDEF COMP}
        {$IFDEF MC_On}
           LicEntCVer:=1+(1*Ord(ModRelMode(1)<>0));
        {$ELSE}
           {$IFDEF SCUD1}
             If (IsMCFlg) then
               LicEntCVer:=1+(1*Ord(ModRelMode(1)<>0))
             else
               LicEntCVer:=0;

           {$ELSE}
             LicEntCVer:=0;

          {$ENDIF}
        {$ENDIF}
      {$ELSE}
        { Multi-Company Manager - if multi-currency then recalculate currency version }
        If (LicEntCVer > 0) Then
          LicEntCVer:=1+(1*Ord(ModRelMode(1)<>0));
      {$ENDIF}

      With Syss do
        LicUserCnt:=DeCode_Usrs(ExUsrSec,ExUsrRel);

      For n:=2 to ModLast do
      If (n<=High(RelTxLate)) then
      Begin
        Idx:=ModRelMode(n);

        If (RelTxLate[n]<>0) then
        Begin
          {$IFDEF WIN32}
            If (Not Check_RelDateExp(n,False)) then
          {$ELSE}
            If (Not Check_RelDateExp(n)) then
          {$ENDIF}

            LicModules[RelTxlate[n]]:=1
          else
            LicModules[RelTxlate[n]]:=SetLicMod(Idx);

        end;
      end;

      If (Not WriteEntLic (EntLicFName,LicRec)) then {* Display a suitable message *}
      Begin
        {$IFDEF WIN32}
          ShowMessage('It was not possible to update the Exchequer Licence File.');
        {$ELSE}
          PopAnyKey(3,PopGenW,'It was not possible to update the Exchequer Licence File.');
        {$ENDIF}
      end;
    end;

  {$ELSE}
  begin
  {$ENDIF}
  {$ELSE}
  begin
  {$ENDIF}
  {$ELSE}
  begin
  {$ENDIF}
  {$ELSE}
  begin
  {$ENDIF}
  end;
*)



{---------------------------------------------------------------------------}

{$IFDEF WIN32}
Initialization

  {$IFNDEF PF_On}

    New (ExMainCoPath);
    ExMainCoPath^ := '';
  {$ENDIF}

Finalization
  {$IFNDEF PF_On}

    Dispose (ExMainCoPath);

  {$ENDIF}

{$ENDIF}
end.
