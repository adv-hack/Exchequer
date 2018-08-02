unit PRNTFRM5;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{* Printing of Form(s) using SBSForm.DLL *}

interface

Uses Classes, Dialogs,
  GlobVar,
  VarConst,
  VarCnst3,
  RpDevice, GlobType, PrntMsgU;

FUNCTION EX_INITPRINTFORM(DATAPATH  :  PCHAR)  :  SMALLINT;  STDCALL; EXPORT;

FUNCTION EX_ADDTRANSFORM(REFNO     :  PCHAR;
                         FORMNAME  :  PCHAR)  :  SMALLINT;  STDCALL; EXPORT;

FUNCTION EX_PRINTFORM(PREVIEWSTAT :  WORDBOOL;
                      NOOFCOPIES  :  SMALLINT )  :  SMALLINT;  STDCALL; EXPORT;

PROCEDURE EX_ENDPRINTFORM;  STDCALL;  EXPORT;

Procedure EX_PRINTFILETO (Const PrnInfo             : TSBSPrintSetupInfo;
                          Const PrintFile, WinTitle : ShortString);  STDCALL;  EXPORT;

Function Ex_Print2(Const WHeading  :  Str255;
                   Const PInfo     :  TSBSPrintSetupInfo)  :  SmallInt; STDCALL;  EXPORT;

Function EX_DEFAULTFORM (P : POINTER; PSIZE : LONGINT) : SmallInt; STDCALL;  EXPORT;

Function EX_DEFAULTEMAILDETS (P           : Pointer;
                              PSize       : LongInt;
                              ToRecip     : PChar;
                              CCRecip     : PChar;
                              BCCRecip    : PChar;
                              MsgText     : PChar;
                              UserCode    : PChar;
                              AcCode      : PChar) : SmallInt; STDCALL;  EXPORT;

Function EX_PRINTTOEMAIL (P           : Pointer;
                          PSize       : LongInt;
                          ToRecip     : PChar;
                          CCRecip     : PChar;
                          BCCRecip    : PChar;
                          MsgText     : PChar;
                          Attachments : PChar) : SmallInt; STDCALL;  EXPORT;

FUNCTION EX_ADDACSTATFORM(ACCODE   :  PCHAR;
                          FORMNAME :  PCHAR) : SMALLINT; STDCALL;  EXPORT;


{* ========================================================================== *}

implementation

{* ========================================================================== *}

Uses
  SysUtils,
  WinProcs,
  FileCtrl,
  Forms,
  BtrvU2,
  BTKeys1U,
  DLLErrU,
  BTSupU1,
{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}
  TKIntf;


Var
  _MyGSRHandle : THandle;
  (*
  _Init   : Function (    SysInfo : SystemInfoType;
                      Var CRTab   : Boolean) : Boolean;
  *)
  _Init   : Function (Const MsgForm  : Pointer;
                      Const DataPath : PChar) : Boolean; StdCall;
  _DeInit : Procedure;
  _Clear  : Function : Boolean;
  _AddJob : Function (Const PrBatch : PrintBatchRecType) : Boolean;
  (*
  _Print  : Function (Const WinTitle : ShortString;
                      Const PrnInfo  : TSBSPrintSetupInfo) : Boolean;
  *)
  _Print  : Function (Const pPrnBatch : Pointer) : Boolean; StdCall;
  _PrintFileTo : Procedure(Const PrnInfo             : TSBSPrintSetupInfo;
                           Const PrintFile, WinTitle : ShortString);

  DLLLoaded : Boolean;

Function pfFind_DefaultPrinter(DefName  :  Str255)  :  Integer;
Var
  n         :  Integer;
  FoundOk   :  Boolean;
Begin
  FoundOk:=BOff;

  For n:=0 to Pred(RpDev.Printers.Count) do
  Begin
    FoundOk:=(CheckKey(DefName,RpDev.Printers[n],Length(DefName),BOff)) and (DefName<>'');

    If (FoundOk) then
      Break;
  end;

  If (FoundOk) then
    Result:=n
  else
    If (RpDev.Printers.Count>0) then
      Result:=RpDev.DeviceIndex
    else
      Result:=-1;
end;



{* ========================================================================== *}

{* Initialise SBSForm.DLL *}

FUNCTION EX_INITPRINTFORM(DATAPATH  :  PCHAR)  :  SMALLINT;
Const
  ResNames : Array[0..6] of PChar = ('SBSForm2',
                                     //'sbsForm_Initialise',
                                     'sbsForm_TKDLL_Initialise',
                                     'sbsForm_DeInitialise',
                                     'PrintBatch_ClearBatch',
                                     'PrintBatch_AddJob',
                                     //'PrintBatch_Print',
                                     'TKDLL_PrintBatch',
                                     'PrintFileTo');

Var
  DLLAddr    : TFarProc;
  {SysInfo    : SystemInfoType;}
  CRTab      : Boolean;
  I          : Byte;
  TDataPath  :  ANSIString;

begin

  LastErDesc:='';
  Result:=0;
  TDataPath:=IncludeTrailingPathDelimiter(StrPas(DataPath));

  If Not DLLLoaded Then Begin
    { Check Datapath points to a valid Enterprise system }
{$IFDEF EXSQL}
    if SQLUtils.ValidCompany(TDataPath) then
{$ELSE}
    If FileExists (TDataPath + 'ExchQss.Dat') And
       DirectoryExists (TDataPath + 'Forms') Then
{$ENDIF}
    Begin

      { Check DLL is in current directory }
      If FileExists (ExtractFilePath(Application.ExeName) + 'SBSForm2.DLL') Then Begin
        _Init := Nil;
        _DeInit := Nil;
        _Clear  := Nil;
        _AddJob := Nil;
        _Print  := Nil;
        _PrintFileTo  := Nil;
        _MyGSRHandle:=LoadLibrary(ResNames[0]);

        try
          If (_MyGSRHandle > HInstance_Error) Then Begin
            { Get handles for procedures }
            For I := 1 To High(ResNames) Do Begin
              DLLAddr := GetProcAddress(_MyGSRHandle, ResNames[I]);
              If Assigned(DLLAddr) Then
                Case I Of
                  1 : _Init   := DLLAddr;
                  2 : _DeInit := DLLAddr;
                  3 : _Clear  := DLLAddr;
                  4 : _AddJob := DLLAddr;
                  5 : _Print  := DLLAddr;
                  6 : _PrintFileTo  :=  DLLAddr;
                End { Case }
              Else
                Result := 1002; { Cannot load procedure handle }
            End; { For }

            If (Result <> 0) Then Begin
              { Somethings effed up - unload dll and set everything to Nil }
              FreeLibrary(_MyGSRHandle);
              _MyGSRHandle:=0;
              _Init := Nil;
              _DeInit := Nil;
              _Clear := Nil;
              _AddJob := Nil;
              _Print := Nil;
              _PrintFileTo  :=  Nil;
            End; { If }
          End { If }
          Else Begin
            _MyGSRHandle:=0;
            Result := 1001; { Cannot load DLL }
          End; { Else }
        Except
          FreeLibrary(_MyGSRHandle);
          _MyGSRHandle:=0;
          Result := 1003; { Exception whilst loadin DLL }

          _Init := Nil;
          _DeInit := Nil;
          _Clear := Nil;
          _AddJob := Nil;
          _Print := Nil;
          _PrintFileTo  :=  Nil;
        End; { Try }

        If (Result = 0) Then
          If Assigned (_Init) Then Begin
            PMsgForm := TPMsgForm.Create(Application);

            { Initialise the DLL }
            CRTab := False;
            With SystemInfo Do Begin
              ExVersionNo      := 11;
              MainForm         := PMsgForm;
              AppHandle        := Application;
              ExDataPath       := TDataPath;
              ControllerHandle := Nil;
              DefaultFont      := Nil;
              FormDesVer       := '';
              DebugOpen        := False;
              AppPrinter       := Nil;
            End; { With }
            //DLLLoaded := _Init(SystemInfo, CRTAb);
            DLLLoaded := _Init(PMsgForm, PCHAR(TDataPath));

            If Not DLLLoaded Then Begin
              { Cannot be initialised }
              Result := 1005 { Initialisation failed }
            end
            else
            begin
              If Assigned(_Clear) Then
                _Clear
              else
                Result:=1004;
            End; { If }
          End { If }
          Else
            Result := 1004; { DLL Not Loaded }
      End { If }
      Else
        { SBSForm.DLL Not Found }
        Result := 1000;
    End { If }
    Else
      { Datapath not valid }
      Result := 1006; { Invalid datapath }
  End; { If }

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(200,Result);

end; {func..}

{* -------- Add Form(s) as Batch -------- *}

FUNCTION EX_ADDTRANSFORM(REFNO     :  PCHAR;
                         FORMNAME  :  PCHAR)  :  SMALLINT;
Const
  Fnum  =  InvF;
  KPath =  InvOurRefK;

Var
  PrBatch      : PrintBatchRecType;
  TFolioNo     : LongInt;
  TRefNo,
  TFormName    :  Str255;

  TmpStat,
  TmpKey1      :  Integer;

  TmpAddr      :  LongInt;

  OInv         :  InvRec;

Begin
  LastErDesc:='';
  Result := 0;
  TRefNo:=StrPas(RefNo);
  TFormName:=StrPas(FormName);

  OInv:=Inv;
  TmpKey1:=GetPosKey;
  TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpAddr,BOff,BOff);


  Result:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KPath,TRefNo);
  If (Result<>0) then
    Result:=1001  {* record not found *}
  else
  begin
    TFolioNo:=Inv.FolioNum;
    // HM 12/11/01: Extended to check for PCC forms as well
    If (FileExists(SystemInfo.ExDataPath+'Forms\'+TFormName+'.EFD')) Or
{$IFDEF EX600}
       (FileExists(SystemInfo.ExDataPath+'Forms\'+TFormName+'.EFX')) Or
{$ENDIF}
       (FileExists(SystemInfo.ExDataPath+'Forms\'+TFormName+'.DEF')) then  {* Form exists ..*}
    begin
      If DLLLoaded Then Begin
        { Call PrintBatch_ClearBatch to setup a new batch }
        If Assigned(_AddJob) Then Begin
          FillChar (PrBatch, SizeOf (PrBatch), #0);
          With PrBatch Do Begin
            { ** This section needs to be built by users }
            pbDefMode   := 1;          { Invoice }
            pbEFDName   := TFormName;  { Invoice Form Name }
            pbMainFNum  := InvF;       { Document file InvF }
            pbMainKPath := InvOurRefK; { Our Ref Key }
            pbMainKRef  := TRefNo;     { Reference No SIN****** }
            pbTablFNum  := IDetailF;   { Details File IDetailF }
            pbTablKPath := IdFolioK;   { Details Folio Key }
            pbTablKRef  := '****';
            Move (TFolioNo, pbTablKRef[1], 4); { Folio Number }
            pbLabel1    := 0;
            pbLbCopies  := 1;
            pbTestMode  := BOff;

          End; { With }

          If (Not _AddJob(PrBatch)) Then
            Result := 1004; { Add To Batch failed }
        End { If }
        Else
          Result := 1003; { DLL Not Loaded }
      End { If }
      Else
        Result := 1003; { DLL Not Loaded }
    end {if }
    else
      Result:=1002; { Form not exist }
  end; {if record found..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(201,Result);

  TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpAddr,BOn,BOff);
  Inv:=OInv;

end; {Ex_AddTransForm..}


{* ------------ Print function to be used by internal programs -------------- *}

Function Ex_Print2(Const WHeading  :  Str255;
                   Const PInfo     :  TSBSPrintSetupInfo)  :  SmallInt;
Var
  PrnBatch : TTKDLLPrintBatchInfo;
begin
  LastErDesc:='';
  Result:=0;

  PrnBatch := InitTKDLLBatch ('Exchequer Enterprise Form Printing', PInfo);

  { ** Window Title needs to be set }
  If (Not _Print(@PrnBatch)) Then
    Result := 1008 { PrintFormBatch failed }
  else
  begin  { Clear after printing ...}
    If Assigned(_Clear) Then
      _Clear
    else
      Result:=1004;
  end;

  DeInitTKDLLBatch (PrnBatch);

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(205,Result);

end;
{* ------- Print Form by Batch -------*}

FUNCTION EX_PRINTFORM(PREVIEWSTAT :  WORDBOOL;
                      NOOFCOPIES  :  SMALLINT )  :  SMALLINT;

Var
  PrnInfo  : TSBSPrintSetupInfo;

Begin
  LastErDesc:='';
  Result := 0;

  If (NoOfCopies<1) then
    NoOfCopies:=1;

  If DLLLoaded Then Begin
    { Call PrintBatch_ClearBatch to setup a new batch }
    If Assigned(_Print) Then Begin
      { ** This section needs a printer dialog like Enterprise's }
      {$OPTIMIZATION OFF}
      { Bug Fix - sometime get Access Violation - this fixes it! }
      RPDev.DeviceIndex := RPDev.DeviceIndex;
      {$OPTIMIZATION ON}

      If RpDev.PrinterSetupDialog Then Begin
        PrnInfo := RpDev.SBSSetupInfo;
        { ** If labels are to be printed then the label dialog is also needed }
        With PrnInfo Do Begin
          Preview   := PreviewStat<>0;     { True = Preview, False = Print }
          NoCopies  := NoOfCopies;      { Copies of form to print }
          pbLabel1  := 1;               { Start of Label 1 Pos }
          TestMode  := BOff;            { Indicates test mode }
          LabelMode := BOff;            { Tells PrntFrm Label Mode }
        End; { With }

        EX_Print2('Exchequer Enterprise Form Printing', PrnInfo);

      End; { If }
    End { If }
    Else
      Result := 1001; { DLL Not Loaded }
  End { If }
  Else
    Result := 1001; { DLL Not Loaded }

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(202,Result);

end; {Ex_PrintForm..}

{* ----- End procedure for Printing Form ----- *}

PROCEDURE EX_ENDPRINTFORM;
Begin
  LastErDesc:='';
  If DLLLoaded Then Begin
    If Assigned(_DeInit) Then Begin
      { DeInitialise the DLL }
      _DeInit;
      _DeInit := Nil;
    End; { If }

    { Unload the DLL }
    FreeLibrary(_MyGSRHandle);
    _MyGSRHandle:=0;

    { Free the hidden message window (if required) }
    If Assigned(PMsgForm) Then
      PMsgFORM.Free;

    DLLLoaded := False;
  End; { If }

End;  {Ex_EndPrintForm..}



Procedure EX_PRINTFILETO (Const PrnInfo             : TSBSPrintSetupInfo;
                          Const PrintFile, WinTitle : ShortString);
Begin
  LastErDesc:='';
  If DLLLoaded And Assigned (_PrintFileTo) Then
    _PrintFileTo (PrnInfo, PrintFile, WinTitle);
End;

{-----------------------------------------------------------------------------}


Function LocalGetFormSet (Const FormSetNo, FormId : SmallInt;
                          Var   FormName          : ShortString) : SmallInt;
Var
  lSysForm   : ^SysRec;
  KeyS       : Str255;
  LStatus    : Integer;
Begin { LocalGetFormSet }
  New (lSysForm);

  If (FormSetNo = 0) Then
    KeyS := SysNames[FormR]
  Else
    KeyS := Copy(SysNames[FormR],1,2) + Chr(FormSetNo + 100);
  LStatus:=Find_Rec(B_GetEq, F[SysF], SysF, lSysForm^, 0, KeyS);

  If (LStatus = 0) Then Begin
    FormName := lSysForm^.FormDefs.PrimaryForm[FormId];

    Result := 0;
  End { If }
  Else
    Result := 30000 + LStatus;

  Dispose(lSysForm);
End; { LocalGetFormSet }


// Returns the Default Form Name for the specified Account Code - or global
// default if Account Code is blank
//
//  1000-1099    Btrieve Error loading Customer Details
//  2000-2099    Btrieve Error restoring customer file position
//  30000-30099  Btrieve Error loading form definition set
//  31001        Invalid Form Number
//  32766        Invalid Size
//  32767        Invalid Pointer
Function EX_DEFAULTFORM (P : POINTER; PSIZE : LONGINT) : SmallInt;
Var
  lFormRec   : ^TDefaultFormRecType;
  lCust      : ^CustRec;
  KeyS       : Str255;
  LStatus, PosStatus    : Integer;
  RecPos     : LongInt;
  FormSetNo  : Byte;
  FName      : ShortString;
Begin { Ex_DefaultForm }

  LastErDesc:='';

  Result:=32767;
  FormSetNo := 0;

  // Check pointer is assigned and correctly sized
  If Assigned(P) and (PSize = Sizeof(TDefaultFormRecType)) Then Begin
    lFormRec := P;

    // Check the Form Number is valid
    If (lFormRec^.dfFormNo >= 1) And (lFormRec^.dfFormNo <= MaxForms) Then Begin
      // Check for Account Code
      LStatus := 0;
      If (Trim(lFormRec^.dfAccount) <> '') Then Begin
        // Load Account Details and get form set
        New (lCust);

        // Save any existing position - NOTE: May not be a valid position
        PosStatus := GetPos (F[CustF], CustF, RecPos);

        // Get Customer/Supplier
        KeyS := FullCustCode(lFormRec^.dfAccount);
        LStatus := Find_Rec(B_GetEq, F[CustF], CustF, lCust^, 0, KeyS);
        If (LStatus = 0) Then
          // Get Form Set No
          FormSetNo := lCust^.FDefPageNo
        Else
          // Error loading customer
          Result := LStatus + 1000;

        If (PosStatus = 0) Then Begin
          // Restore position
          SetDataRecOfsPtr(CustF, RecPos, lCust^);
          LStatus := GetDirect(F[CustF], CustF, lCust^, 0, 0);
          If (LStatus <> 0) Then Result := LStatus + 2000;
        End; { If (LStatus = 0) }

        Dispose (lCust);
      End { If }
      Else
        FormSetNo := 0;

      If (LStatus = 0) Then Begin
        Result := LocalGetFormSet (FormSetNo, lFormRec^.dfFormNo, FName);

        // If Form Name not defined then fallback to global set
        If (Result = 0) And (Trim(FName) = '') And (FormSetNo > 0) And (lFormRec^.dfCheckGlobal <> 0) Then
          Result := LocalGetFormSet (0, lFormRec^.dfFormNo, FName);

        lFormRec^.dfFormName := FName;
      End; { If (LStatus = 0) }
    End { If (lFormRec^.dfFormNo >= 1) And (lFormRec^.dfFormNo <= MaxForms) }
    Else
      // Error - Invalid Form Number
      Result := 31001;
  End { If Assigned(P) and (PSize = Sizeof(TDefaultFormRecType)) }
  Else
    If Assigned(P) Then
      // Wrong Size
      Result := 32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(139,Result);

End; { Ex_DefaultForm }

{-----------------------------------------------------------------------------}

// Returns the Default Form Name for the specified Account Code - or global
// default if Account Code is blank
//
//  1000-1099    Btrieve Error loading Customer Details
//  2000-2099    Btrieve Error restoring customer file position
//  30000-30099  Btrieve Error loading form definition set
//  32766        Invalid Size
//  32767        Invalid Pointer
Function EX_DEFAULTEMAILDETS (P           : Pointer;
                              PSize       : LongInt;
                              ToRecip     : PChar;
                              CCRecip     : PChar;
                              BCCRecip    : PChar;
                              MsgText     : PChar;
                              UserCode    : PChar;
                              AcCode      : PChar) : SmallInt;
Var
  lEmailInfo : ^TEmailPrintInfoType;
  lCust      : ^CustRec;
  SigFile    : TStrings;
  FName      : ShortString;
  GotFile    : Boolean;
  KeyS       : Str255;
  LStatus, PosStatus    : Integer;
  RecPos                : LongInt;
Begin { Ex_DefaultEmailDets }

  LastErDesc:='';
  Result:=32767;

  // Check pointer is assigned and correctly sized
  If Assigned(P) and (PSize = Sizeof(TEmailPrintInfoType)) Then Begin
    lEmailInfo := P;
    FillChar (lEmailInfo^, SizeOf(lEmailInfo^), #0);
    With lEmailInfo^ Do Begin
      emPreview    := Ord(False);
      emCoverSheet := SyssForms^.FormDefs.PrimaryForm[43];  // Email Cover Sheet
      emSenderName := SyssEDI2^.EDI2Value.EmName;
      emSenderAddr := SyssEDI2^.EDI2Value.EmAddress;
      emSubject    := '';
      emPriority   := SyssEDI2^.EDI2Value.EmPriority;
      emSendReader := 0;
      emCompress   := Ord(False);
    End; { With }

    // Initialise PChar parameters
    StrPCopy (ToRecip, '');
    StrPCopy (CCRecip, '');
    StrPCopy (BCCRecip, '');
    StrPCopy (MsgText, '');

    // Insert User signature
    If (Trim(UserCode) <> '') Then Begin
      // Check for user specific signature
      FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + Trim(Copy(UserCode, 1, 8)) + '.txt';
      GotFile := FileExists (FName);
    End { If }
    Else
      GotFile := False;

    If (Not GotFile) Then Begin
      // No user signature - check for company signature
      FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'company.txt';
      GotFile := FileExists (FName);
    End; { If (Not GotFile) }

    If GotFile Then Begin
      // Load signature into message text
      SigFile := TStringList.Create;
      Try
        SigFile.LoadFromFile(FName);

        StrPCopy (MsgText, SigFile.Text);
      Finally
        SigFile.Destroy;
      End;
    End; { If GotFile }

    // Try to load Account Details
    If (Trim(AcCode) <> '') Then Begin
      // Load Account Details and set email address, etc...
      New (lCust);

      // Save any existing position - NOTE: May not be a valid position
      PosStatus := GetPos (F[CustF], CustF, RecPos);

      // Get Customer/Supplier
      KeyS := FullCustCode(AcCode);
      LStatus := Find_Rec(B_GetEq, F[CustF], CustF, lCust^, 0, KeyS);
      If (LStatus = 0) Then Begin
        // Extract current paperless module settings
        lEmailInfo^.emSendReader := 2 * Ord(lCust^.EmlSndRdr); // False=0, True = 2
        lEmailInfo^.emCompress := Ord(lCust^.EmlZipAtc);

        StrPCopy (ToRecip, Trim(lCust^.Company) + ';' + Trim(lCust^.EmailAddr) + ';');

        // Check for alternate form set - may have different cover sheet
        If (lCust^.FDefPageNo > 0) Then Begin
          LStatus := LocalGetFormSet (lCust^.FDefPageNo, 43, FName);
          lEmailInfo^.emCoverSheet := FName;
        End; { If (lCust^.FDefPageNo > 0) }

        Result := 0;
      End { If (LStatus = 0) }
      Else
        // Error loading customer
        Result := LStatus + 1000;

      If (PosStatus = 0) Then Begin
        // Restore position
        SetDataRecOfsPtr(CustF, RecPos, lCust^);
        LStatus := GetDirect(F[CustF], CustF, lCust^, 0, 0);
        If (LStatus <> 0) Then Result := LStatus + 2000;
      End; { If (LStatus = 0) }

      Dispose (lCust);
    End { If (Trim(AcCode) <> '') }
    Else
      // No Account Code - everything peachy
      Result := 0;
  End { If Assigned(P) and (PSize = Sizeof(TDefaultFormRecType)) }
  Else
    If Assigned(P) Then
      // Wrong Size
      Result := 32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(140,Result);

End; { Ex_DefaultEmailDets }

{-----------------------------------------------------------------------------}

// Prints the current print batch to Email
//
//  1001         DLL Not Loaded
//  2001         To Recipients cannot be blank
//  2002         Sender Name cannot be blank
//  2003         Sender Address cannot be blank
//  2004         Subject cannot be blank
//  2005         Invalid Priority
//  2006         Invalid Send Reader flag
//  32765        Paperless Module not Available
//  32766        Invalid Size
//  32767        Invalid Pointer
Function EX_PRINTTOEMAIL (P           : Pointer;
                          PSize       : LongInt;
                          ToRecip     : PChar;
                          CCRecip     : PChar;
                          BCCRecip    : PChar;
                          MsgText     : PChar;
                          Attachments : PChar) : SmallInt;
Var
  lEmailInfo : ^TEmailPrintInfoType;
  lPrnInfo   : TSBSPrintSetupInfo;
  SigFile    : TStrings;
  RdrText    : AnsiString;
  FName      : ShortString;
  OK         : Boolean;
Begin { Ex_PrintToEmail }
  LastErDesc:='';
  Result:=32767;

  // Check pointer is assigned and correctly sized
  If Assigned(P) and (PSize = Sizeof(TEmailPrintInfoType)) Then Begin
    // Check Paperless Module is available
    If eCommsModule Or (Not CheckRelease) Then Begin
      lEmailInfo := P;

      // Validate email Details
      OK := (Trim(ToRecip) <> '');
      If (Not Ok) Then Result := 2001;

      If OK Then Begin
        OK := (Trim(lEmailInfo.emSenderName) <> '');
        If (Not Ok) Then Result := 2002;
      End; { If OK }

      If OK Then Begin
        OK := (Trim(lEmailInfo.emSenderAddr) <> '');
        If (Not Ok) Then Result := 2003;
      End; { If OK }

      If OK Then Begin
        OK := (Trim(lEmailInfo.emSubject) <> '');
        If (Not Ok) Then Result := 2004;
      End; { If OK }

      If OK Then Begin
        OK := (lEmailInfo.emPriority >= 0) And (lEmailInfo.emPriority <= 2);
        If (Not Ok) Then Result := 2005;
      End; { If OK }

      If OK Then Begin
        OK := (lEmailInfo.emSendReader >= 0) And (lEmailInfo.emSendReader <= 2);
        If (Not Ok) Then Result := 2006;
      End; { If OK }

      If OK Then Begin
        // Check SBSFORM.DLL is loaded and happy
        If DLLLoaded Then Begin
          // Check got handle to PrintBatch_Print procedure
          If Assigned(_Print) Then Begin
            {$OPTIMIZATION OFF}
            // Bug Fix - sometime get Access Violation - this fixes it!
            RPDev.DeviceIndex := RPDev.DeviceIndex;
            {$OPTIMIZATION ON}

            RdrText := '';
            If (lEmailinfo^.emSendReader = 2) Then Begin
              // Load Reader Text to be inserted into start of message text
              FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'reader.txt';
              If FileExists (FName) Then Begin
                SigFile := TStringList.Create;
                Try
                  SigFile.LoadFromFile(FName);

                  RdrText := SigFile.Text;
                Finally
                  SigFile.Destroy;
                End;
              End; { If }
            End; { If (lEmailinfo^.emSendReader = 2) }

            // Build TSBSPrintSetupInfo structure for Print job
            FillChar (lPrnInfo, SizeOf(lPrnInfo), #0);
            With lPrnInfo Do Begin
              // Set printer to correct printer for attachments with default paper and bin
              DevIdx := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.EmailPrnN);
              FormNo := 0;
//              DevIdx := 1; //pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.EmailPrnN);
              FormName := '';
              BinNo := 0;
              BinName := '';
              Preview := (lEmailInfo^.emPreview <> 0);     { True = Preview, False = Print }
              NoCopies := 1;                             { Copies of form to print }
              pbLabel1 := 1;                    { N/A }  { Start of Label 1 Pos }
              TestMode := False;                { N/A }  { Indicates test mode }
              LabelMode := False;               { N/A }  { Tells PrntFrm Label Mode }
              ChequeMode := False;              { N/A }  { Enables Cheque No processing fields }
              fePrintMethod := 2;                        { Flag: 0=Printer, 1=Fax, 2=Email, 3=XML } {*en431 XML}
              feBatch := False;                          { Flag: Printing a batch - disable To details as specified later }

              feCoverSheet := lEmailinfo^.emCoversheet;  { Cover Sheet }

              feEmailMAPI     := SyssEDI2^.EDI2Value.EmUseMAPI;  { Email: Send using MAPI }
              feEmailFrom     := lEmailinfo^.emSenderName;       { Email: From Name }
              feEmailFromAd   := lEmailinfo^.emSenderAddr;       { Email: From Address }
              feEmailTo       := ToRecip;                        { Email: To Name;Addr;Name;Addr; ... }
              feEmailCc       := CCRecip;
              feEmailBcc      := BCCRecip;
              feEmailSubj     := lEmailinfo^.emSubject;          { Email: Subject }
              feEmailMsg      := RdrText + MsgText;              { Email: Message (max 10k from v4.31.004) }
              feEmailAttach   := Attachments;                    { Email: Attachments (for future use - maybe) }
              feEmailPriority := lEmailinfo^.emPriority;         { Email: Priority - 0=Low, 1=Normal, 2=High }
              feEmailReader   := (lEmailinfo^.emSendReader <> 0);{ Email: Attach Acrobat/Exchequer Reader }
              feEmailZIP      := lEmailinfo^.emCompress;         { Email: ZIP Attachment as self-extracting .EXE }
              feEmailAtType   := SyssEDI2^.EDI2Value.emAttchMode;{ Email: Attachment methodology:- 0-RPPro, 1-Adobe }
            End; { With lPrnInfo }

            Result := Ex_Print2('', lPrnInfo);
          End { If }
          Else
            Result := 1001; { DLL Not Loaded }
        End { If }
        Else
          Result := 1001; { DLL Not Loaded }
      End; { If OK }
    End { If }
    Else
      Result := 32765; { Paperless Module not available }
  End { If Assigned(P) and (PSize = Sizeof(TDefaultFormRecType)) }
  Else
    If Assigned(P) Then
      // Wrong Size
      Result := 32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(141,Result);

End; { Ex_PrintToEmail }

{-----------------------------------------------------------------------------}


{* -------- Add Form(s) as Batch -------- *}

FUNCTION EX_ADDACSTATFORM(ACCODE   :  PCHAR;
                          FORMNAME :  PCHAR) : SMALLINT;
Const
  Fnum  =  CustF;
  KPath =  ATCodeK;
Var
  PrBatch      : PrintBatchRecType;
  TRefNo,
  TFormName    :  Str255;

  TmpStat,
  TmpKey1      :  Integer;

  TmpAddr      :  LongInt;

  OCust         :  CustRec;

Begin { Ex_AddAcStatForm }
  LastErDesc:='';
  Result := 0;
  TFormName:=StrPas(FormName);

  OCust:=Cust;
  TmpKey1:=GetPosKey;
  TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpAddr,BOff,BOff);


  TRefNo:=StrPas(AcCode);
  Result:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KPath,TRefNo);
  If (Result<>0) then
    Result:=1001  {* record not found *}
  else
  begin
    If (FileExists(SystemInfo.ExDataPath+'Forms\'+TFormName+'.EFD'))
{$IFDEF EX600}
       or (FileExists(SystemInfo.ExDataPath+'Forms\'+TFormName+'.EFX'))
{$ENDIF}
       then  {* Form exists ..*}
    begin
      If DLLLoaded Then Begin
        { Call PrintBatch_ClearBatch to setup a new batch }
        If Assigned(_AddJob) Then Begin
          FillChar (PrBatch, SizeOf (PrBatch), #0);
          With PrBatch Do Begin
            { ** This section needs to be built by users }
            pbDefMode   := 3;          { Statement }
            pbEFDName   := TFormName;  { Invoice Form Name }

            // Main Record
            pbMainFNum  := FNum;       { CustF }
            pbMainKPath := KPath;      { ATCodeK - CustSupp + CustCode }
            pbMainKRef  := TRefNo;     { CustSupp + CustCode }

            // List Records
            pbTablFNum  := InvF;       { Details File IDetailF }
            pbTablKPath := InvCustK;   { CustCode + CustSupp + ... }
            pbTablKRef  := Copy (TRefNo, 2, 6) + TRefNo[1];

            pbLabel1    := 0;
            pbLbCopies  := 1;
            pbTestMode  := BOff;
          End; { With }

          If (Not _AddJob(PrBatch)) Then
            Result := 1004; { Add To Batch failed }
        End { If }
        Else
          Result := 1003; { DLL Not Loaded }
      End { If }
      Else
        Result := 1003; { DLL Not Loaded }
    end {if }
    else
      Result:=1002; { Form not exist }
  end; {if record found..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(201,Result);

  TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpAddr,BOn,BOff);
  Cust:=Ocust;
end; { Ex_AddAcStatForm }



end.
