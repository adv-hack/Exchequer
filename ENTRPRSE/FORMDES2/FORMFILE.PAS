{ Defines the btrieve files used by the form designer }
unit FormFile;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Dialogs, Forms, SysUtils, WinTypes, BtrvU2, BTSupU1, GlobVar, GlobType, DataDict;

Const
  StartFormFiles = 18;
  TotFormFiles   = 3;

  { Paper Sizes }
  PaperSizeF       = 19;
  PaperSizeName    = 'PaprSize.Dat';
  PaperSizeSegs    = 1;
  Key_PS_Descr     = 0;

  { Data Dictionary = File 18 }
  { DataDict.Pas }

  { Form Details }
  FormDetsF        = 20;
  FormDetsName     = '';             { Name is unknown until run-time }
  FormDetsSegs     = 2;
  Key_Dets_Class   = 0;

Type
  { Paper Sizes: Btrieve info declaration }
  PaperSizeFileDef = Record
    RecLen    : SmallInt;
    PageSize  : SmallInt;
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    Reserved  : Array [1..4] of Char;
    KeyBuff   : Array [1..PaperSizeSegs] of KeySpec;
    AltColt   : AltColtSeq;
  end;

  { Form Details: Btrieve info declaration }
  FormDetsFileDef = Record
    RecLen    : SmallInt;
    PageSize  : SmallInt;
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    Reserved  : Array [1..4] of Char;
    KeyBuff   : Array [1..FormDetsSegs] of KeySpec;
    AltColt   : AltColtSeq;
  end;

Var
  PaperSizeRec  : ^PaperSizeType;
  PaperSizeFile : ^PaperSizeFileDef;

  FormDetsRec   : ^FormDefRecType;
  FormDetsFile  : ^FormDetsFileDef;

  CreateSet     : Set Of Byte;

{ Public declarations }
Function  FF_OpenFile (Const FileNo : SmallInt;Const Create : Boolean;Const FilePath : ShortString = '') : Boolean;
Function  FF_OpenFiles : Boolean;
Procedure FF_CloseFiles (ByFile  :  Boolean);
Procedure FF_Loadsys;
Procedure FF_GetData;
Function FF_OpenFile2 (Const FileNo : SmallInt) : Boolean;

Function GetCompanyName : ShortString; Export;

Procedure FF_DefineFormDets;

{$IFDEF EDLL}
Procedure GetTempFilePath (Var TempPath : ShortString); StdCall; export;
{$ENDIF}

Implementation

Uses VarConst,
     PaprSize,
     {$IFDEF EDLL}
       Excep3U,
     {$ENDIF}
     EntLicence,
     VAOUtil,
     BtKeys1U;


{ defines the Btrieve structure for the paper sizes file }
Procedure FF_DefinePaperSizes;
  Const
    Idx = PaperSizeF;
  begin { FF_DefinePaperSizes }
    With PaperSizeFile^ do Begin
      FileSpecLen[Idx] := Sizeof(PaperSizeFile^);
      Fillchar(PaperSizeFile^,FileSpecLen[Idx],0);
      RecLen   := Sizeof(PaperSizeRec^);
      PageSize := DefPageSize;
      NumIndex := 1;
      Variable := B_Variable;

      { 0 - Description  }
      KeyBuff[1].KeyPos   := 3;
      KeyBuff[1].KeyLen   := 30;
      KeyBuff[1].KeyFlags := DupMod{ + AltColSeq};

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    end; {With..}

    FileRecLen[Idx]:=Sizeof(PaperSizeRec^);

    Fillchar(PaperSizeRec^,FileRecLen[Idx],0);
    RecPtr[Idx]:=@PaperSizeRec^;
    FileSpecOfs[Idx]:=@PaperSizeFile^;
    FileNames[Idx] := FormsPath + PaperSizeName;
  End;  { FF_DefinePaperSizes }


{ defines the Btrieve structure for the Form Register file }
Procedure FF_DefineFormDets;
  Const
    Idx = FormDetsF;
  begin { FF_DefineFormDets }
    With FormDetsFile^, FormDetsRec^ do Begin
      FileSpecLen[Idx] := Sizeof(FormDetsFile^);
      Fillchar(FormDetsFile^,FileSpecLen[Idx],0);
      RecLen   := Sizeof(FormDetsRec^);
      PageSize := DefPageSize;
      NumIndex := 1;
      Variable := B_Variable;

      { 0 - Class + FieldOrder }
      KeyBuff[1].KeyPos   := 1;
      KeyBuff[1].KeyLen   := SizeOf (fdRepClass);
      KeyBuff[1].KeyFlags := ModSeg;

      KeyBuff[2].KeyPos     := KeyBuff[1].KeyPos + KeyBuff[1].KeyLen;
      KeyBuff[2].KeyLen     := SizeOf (fdFieldOrder);
      KeyBuff[2].KeyFlags   := Modfy + ExtType;
      KeyBuff[2].ExtTypeVal := BInteger;
    end; {With..}

    FileRecLen[Idx]:=Sizeof(FormDetsRec^);

    Fillchar(FormDetsRec^,FileRecLen[Idx],0);
    RecPtr[Idx]:=@FormDetsRec^;
    FileSpecOfs[Idx]:=@FormDetsFile^;

    { Set at run-time }
    {FileNames[Idx] := FormsPath + FormDetsName;}
  End;  { FF_DefineFormDets }


{ Opens a specified file }
Function FF_OpenFile (Const FileNo : SmallInt;Const Create : Boolean;Const FilePath : ShortString = '') : Boolean;
  Const
    NoAttempts     =  100;   {* No of retries before giving up *}
  Var
    NoTrys, SetAccel : SmallInt;
    mbRet            : Word;
    BaseDir          : ShortString;
  Begin
    Result := True;

    { =========== Set Accelrated mode ============ }
    mbRet:=0;
    SetAccel:=-1*Ord(AccelMode);

    { =========== Open File ========== }
    Ch:=ResetKey;

    NoTrys:=0;

    {$I-}
      If (Check4BtrvOK) then Begin
        NoTrys:=0;

        Repeat
          Elded:=BOff;

          (* HM 04/04/02 - Disabled as doesn't work under Toolkit DLL
          // HM 26/03/02: Extended Form Designer to only use DictNary.Dat from App Dir
          If (FileNo <> DictF) Then
            BaseDir := SetDrive
          Else
            BaseDir := ExtractFilePath (Application.ExeName);
          *)

          //BaseDir := SetDrive;

          // MH 01/05/07: If a path is passed in then use it instead of SetDrive
          If (FilePath = '') Then
            BaseDir := SetDrive
          Else
            BaseDir := FilePath;


          If (FileNames[FileNo][2] <> ':') Then
            Status:=Open_File(F[FileNo],BaseDir+FileNames[FileNo],SetAccel)
          Else
            Status:=Open_File(F[FileNo],FileNames[FileNo],SetAccel);

          If (Status <> 0) and (NoTrys > NoAttempts) then Begin
            If (Debug) then Status_Means(Status);
            Elded:=BOff;

            mbRet:=MessageDlg('Error in File:'+FileNames[FileNo]+' Type '+IntToStr(Status),mtInformation,[mbOk],0);

            If (Not (Status In [85,86])) Then Begin
              { General error }
              mbRet:=MessageDlg('Create new file?',mtConfirmation,mbOkCancel,0)
            End { If }
            Else Begin
              { File Locked / File Table Full }
              mbRet:=MessageDlg('About to Abort',mtInformation,[mbOk],0);
            End; { Else }

            If (mbRet=IdOk) and (Not (Status In [85,86])) then Begin
              Status:=Make_File(F[FileNo],BaseDir+FileNames[FileNo],FileSpecOfs[FileNo]^,FileSpecLen[FileNo]);
              Include (CreateSet, FileNo);

              If (Debug) then Status_Means(Status);
            End { If }
            Else Begin
              {Halt;}
              Result := False;
              Break;
            End; { Else }
          End { If }
          Else
            If (Status=0) Then
              Elded:=BOn
            Else
              Inc(NoTrys);
        Until (Elded) or (Ch=#27);

        If (Status<>0) then Begin
          mbRet:=MessageDlg('Btrieve Error!'+InttoStr(Status),mtInformation,[mbOk],0);
          {Halt;}
          Result := False;
        End; { If }
      End { If }
      Else Begin
        { Btrieve not running }
        ShowMessage ('Btrieve not running');
        {Halt;}
        Result := False;
      End; { Else }

      Elded:=BOff;
    {$I+}
  end;

{ Opens a specified file without any error messages or create option }
Function FF_OpenFile2 (Const FileNo : SmallInt) : Boolean;
  Const
    NoAttempts     =  100;   {* No of retries before giving up *}
  Var
    NoTrys, SetAccel : SmallInt;
    mbRet            : Word;
    BaseDir          : ShortString;
  Begin
    Result := True;

    { =========== Set Accelrated mode ============ }
    mbRet:=0;
    SetAccel:=-1*Ord(AccelMode);

    { =========== Open File ========== }
    Ch:=ResetKey;

    NoTrys:=0;

    {$I-}
      If (Check4BtrvOK) then Begin
        NoTrys:=0;

        Repeat
          Elded:=BOff;

          // HM 26/03/02: Extended Form Designer to only use DictNary.Dat from App Dir
          If (FileNo <> DictF) Then
            BaseDir := SetDrive
          Else
            BaseDir := ExtractFilePath (Application.ExeName);

          If (FileNames[FileNo][2] <> ':') Then Begin
            Status:=Open_File(F[FileNo],BaseDir+FileNames[FileNo],SetAccel);
          End { If }
          Else Begin
            Status:=Open_File(F[FileNo],FileNames[FileNo],SetAccel);
          End; { Else }

          Result := (Status = 0);

          If Result Then
            Elded:=BOn
          Else
            Inc(NoTrys);
        Until (Elded) Or (NoTrys > NoAttempts) Or (Ch=#27);
      End { If }
      Else Begin
        { Btrieve not running }
        ShowMessage ('Btrieve not running');
        Result := False;
      End; { Else }

      Elded:=BOff;
    {$I+}
  end;


{ Opens all the files }
Function FF_OpenFiles : Boolean;
  Var
    Choice :  Integer;
    bOK : Boolean;
  Begin
    Result := True;

//ShowMessage ('VAOInfo.vaoCompanyDir: ' + VAOInfo.vaoCompanyDir + #13 +
//             'VAOInfo.vaoAppsDir: ' + VAOInfo.vaoAppsDir);

    For Choice := StartFormFiles To (StartFormFiles + TotFormFiles - 1) Do
      If Not (Choice In [FormDetsF]) Then Begin
        // MH 01/05/07: Modified to pickup Dictnary.Dat from the main company directory only
        If (Choice <> DictF) Then
          bOK := FF_OpenFile (Choice, True)
        Else
          bOK := FF_OpenFile (Choice, True, VAOInfo.vaoCompanyDir);

        If (Not bOK) Then Begin
          Result := False;
          Break;
        End; { If }
      End; { If }

    { Initialise any newly created files }
    If Result And (PaperSizeF In CreateSet) Then AddDefaultPaperSizes;
  end;


{ Closes all the files }
Procedure FF_CloseFiles (ByFile : Boolean);
  Var
    Choice  :  Byte;
    FSpec   : FileSpec;
  Begin { FF_CloseFiles }
    {$I-}
      If (Debug) Or (ByFile) Or (ResetBtOnExit) Then Begin
        For Choice := 1 {StartFormFiles} To (StartFormFiles + TotFormFiles - 1) Do Begin
          {* Check file is open b4 closing it *}
          Status:=GetFileSpec(F[Choice],Choice,FSpec);

          If (StatusOk) then
            Status:=Close_File(F[Choice])
          Else
            { HM 01/04/99: Causes Error 3 messages under debug builds if not present }
            Status:=0;
        End; { For }

        { HM 01/04/99: Can knacker Btrieve files in other systems }
        //Status := Reset_B;
      end
      else
        Status := Stop_B;

      If (Debug) then
        Status_Means(Status);
    {$I+}
  end;  { FF_CloseFiles }

(*
Function FF_FileExist (Const FName : Str255) : Boolean;
Var
  TestFile : File of Byte;
  FileName : Str255;
Begin
  {$I-}

  FileName := SetDrive + FormsPath + FName;
  Assign (TestFile, FileName);
  Reset (TestFile);

  Result := (IOResult = 0);

  If Result then Close (TestFile);

  {$I+}
end; {Func..}
*)

Procedure FF_Loadsys;
Var
  Locked : Boolean;
begin
  { HM 08/03/99: Extended to read in new system setup records }
  Locked := False; GetMultiSys(True, Locked, EDI3R);
  Locked := False; GetMultiSys(True, Locked, EDI2R);
  Locked := False; GetMultiSys(True, Locked, EDI1R);
  Locked := False; GetMultiSys(True, Locked, JobSR);

  Locked := False; GetMultiSys(True, Locked, VATR);
  Locked := False; GetMultiSys(True, Locked, DEFR);
  Locked := False; GetMultiSys(True, Locked, FormR);

  { HM 28/09/99: Modified for increased currency table }
  //Locked := False; GetMultiSys(True, Locked, CurR);
  //Locked := False; GetMultiSys(True, Locked, GCUR);
  Locked := False; GetMultiSysCur(True, Locked);
  Locked := False; GetMultiSysGCur(True, Locked);



  { Load main sysrec last as otherwise the others will overwrite it }
  Locked := False; GetMultiSys(True, Locked, SysR);


  // MH 09/05/06: Set module licencing flags
  RepWrtOn := (EnterpriseLicence.elModules[modRepWrt] <> mrNone) Or (EnterpriseLicence.elModules[modVisualRW] <> mrNone);
  JBCostOn := (EnterpriseLicence.elModules[modJobCost] <> mrNone);
  EuroVers := (EnterpriseLicence.elCurrencyVersion = cvEuro);
  eCommsModule := (EnterpriseLicence.elModules[modPaperless] <> mrNone);
  eBusModule := (EnterpriseLicence.elModules[modEBus] <> mrNone);
  CommitAct := (EnterpriseLicence.elModules[modEBus] <> mrNone);

  TeleSModule := (EnterpriseLicence.elModules[modTeleSale] <> mrNone);
  AnalCuStk := (EnterpriseLicence.elModules[modAccStk] <> mrNone);

  FullWOP := (EnterpriseLicence.elModules[modProWOP] <> mrNone);
  STDWOP := (EnterpriseLicence.elModules[modStdWOP] <> mrNone);
  WOPOn := STDWOP Or FullWOP;

  FullJAP := (EnterpriseLicence.elModules[modAppVal] <> mrNone);
  // StdJAP - Not Used
  JAPOn := FullJAP;

  FullStkSysOn := (EnterpriseLicence.elModules[modFullStock] <> mrNone);

  CISOn := JBCostOn And (EnterpriseLicence.elModules[modCISRCT] <> mrNone);

  RetMOn := (EnterpriseLicence.elModules[modGoodsRet] <> mrNone);
end;


Procedure FF_GetData;
Var
  KeyS : Str255;
  Stat : SmallInt;
begin
  { Get first sales invoice }
  KeyS := 'SIN' + #0;
  Stat := Find_Rec (B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, KeyS);
  If (Stat = 0) Then Begin
    { got an invoice of some description - get customer }
    KeyS := FullCustCode (Inv.CustCode);
    Stat := Find_Rec (B_GetGEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, KeyS);

    { try to get a detail line }
    KeyS := FullNomKey (Inv.FolioNum);
    Stat := Find_Rec (B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyS);
  End; { If }
end;


Function GetCompanyName : ShortString;
Begin
  Result := Syss.UserName;
End;

{$IFDEF EDLL}
  Procedure GetTempFilePath (Var TempPath : ShortString);
  Begin { GetTempFilePath }
    TempPath := SetDrive + GetSwapDir;
  End; { GetTempFilePath }
{$ENDIF}

Initialization
  CreateSet := [];

  GetMem (PaperSizeRec, SizeOf (PaperSizeRec^));
  GetMem (PaperSizeFile, SizeOf (PaperSizeFile^));
  GetMem (FormDetsRec, SizeOf (FormDetsRec^));
  GetMem (FormDetsFile, SizeOf (FormDetsFile^));

  FF_DefinePaperSizes;
  FF_DefineFormDets;
Finalization
  FreeMem (PaperSizeRec, SizeOf (PaperSizeRec^));
  FreeMem (PaperSizeFile, SizeOf (PaperSizeFile^));
  FreeMem (FormDetsRec, SizeOf (FormDetsRec^));
  FreeMem (FormDetsFile, SizeOf (FormDetsFile^));
end.
