UNIT INITDLLU;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{F+}
{$IFNDEF COMPRICE}
  {$DEFINE COMTK}
{$ENDIF}
{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 21/07/93                      }
{                                                              }
{                     Internal Export Modeule                  }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


Interface

Uses
  GlobVar,
  {$IFDEF WIN32}
    VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3;

  {..$I Exchdll.inc}
  {$I Version.Inc}

{$IFNDEF WIN32}
Type
  ShortString = String;
{$ENDIF}

const
  MAX_FILE_NUM = 30;

type
  TFileNumSet = set of 1..MAX_FILE_NUM;

Function  EX_INITDLL  :  SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
Function  EX_CLOSEDLL  :  SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
FUNCTION  EX_INITBTRIEVE : SMALLINT; EXPORT;
Procedure EX_TESTMODE (MODE : WORDBOOL); {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
Function  EX_VERSION : SHORTSTRING;  {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
Procedure EX_SETRELEASECODE(RELCODE  :  PCHAR);  {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
Function  EX_INITDLLPATH(EXPATH    :  PCHAR;
                         MCSYSTEM  :  WORDBOOL) :  SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
Function EX_GETDATAPATH(VAR EXDATAPATH  :  PCHAR)  :  SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
Function EX_CLOSEDATA : SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
Function EX_OVERRIDEINI(SETTING, VALUE : PCHAR) : SMALLINT;  {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
Function EX_READINIVALUE(SETTING : PCHAR; VAR VALUE : PCHAR) : SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

{ Functions not exported as part of the Toolkit DLL }
function  CalcPriceBtrieveInit : smallint;
function  Open_Sys(FileNums : TFileNumSet) : integer;
procedure DClose_Files(FileNums : TFileNumSet; ResetBtrieve : boolean;
            HeapCleanUp : boolean = true);

// Waits for up to NoSecs seconds for the Toolkit to be available
// before calling Ex_InitDLL
FUNCTION EX_INITDLLWAIT (Const NoSecs : SmallInt) : SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;


{$IFDEF COMTK}
  // Functions Split out for the COM Toolkit

  // Returns the path for ExchDll.Ini
  Function FindExchDllIniFile : ShortString;

  // Initialises the ExSyss structure containing the ExchDll.Ini flags
  Procedure InitExSyss;

  // Open data file, initialise structures etc...
  FUNCTION InitialiseDLLMain(FileNums : TFileNumSet; StartMode : integer) : SMALLINT;

  // Reads ExchDll.Ini file
  Function Process_File(DFName  :  Str255)  :  Integer;

{$ENDIF}


Var
  // Global Lock flag to prevent multiple usage within the same
  // instance of the Toolkit DLL in memory.
  GlobalTKLock : LongInt;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  FileCtrl,
  SysUtils,
  ETStrU,
  ETDateU,
  ETMiscU,
  EBusTKit,
  DLLErrU,

{$IFDEF WIN32}
  Forms,
  DateUtils,
  Windows,
  Registry,
  BtrvU2,
  BTSupU1,
  HelpSupU,
  varfposu, { JF 4/8/1999 - fix compilation problem }
  BTKeys1U,
{$ELSE}
  WinTypes,
  WinProcs,
  BtrvU16,
  BtSup1,
  HelpSU,
{$ENDIF}
{$IFDEF COMTK}
  LogFile,
{$ENDIF}
  oMCMSec,
  VAOUtil,
  ErrLogs,    // Login / User Count Error Logging
  Dialogs,
  EntLic,
  LicRec,
  MultiBuyVar,

  // CJS 2011-08-12 ABSEXCH-11265 - Cached data problem
  {$IFDEF EXDLL}
  CRECache,
  {$ENDIF}

{$IFDEF EXSQL}
  SQLUtils,
  TKSQLCallerU,
{$ENDIF}
  FileUtil,
  AuditInfo,

  //PR: 27/10/2011 v6.9
  CustomFieldsIntf,

  //PR: 28/10/2011 v6.9
  AuditNoteIntf,

  //PR: 15/02/2012 ABSEXCH-9795
  QtyBreakVar,

  //ODS,

  //PR: 27/07/2012 ABSEXCH-12956
  CurrencyHistoryVar,

  //PR: 02/12/2014 Order Payments
  CountryCodes,

  AdoConnect;

{$I VarCnst2.Pas}

var
  DynamicVarsAllocated : boolean;
  ToolkitOpen : Boolean;
  LoginLog : ILoginErrorLog;

procedure SetEnterpriseType;
var
  LRec : EntLicenceRecType;
  lFileName : string;
begin
  FillChar(LRec, SizeOf(LRec), 0);

  //AP 21/02/2018 ABSECH-19723:Stock & Location imports failing on v2018 R1 - Stock not licenced
  lFileName :=  GetEnterpriseDirectory + EntLicFName;
  if not FileExists(lFileName) then
  begin
    lFileName := VAOInfo.vaoAppsDir + EntLicFName;
  end;
  
  if ReadEntLic(lFileName, LRec) then
  begin
    StockOn := LRec.licEntModVer > 0;
    SPOPOn := LRec.licEntModVer > 1;
  end
  else
  begin
    StockOn := False;
    SPOPOn := False;
  end;
end;

FUNCTION EX_INITBTRIEVE : SMALLINT;
begin
  LastErDesc:='';

  if Check4BtrvOk then
    Result := 0
  else
    Result := 1;

  If (Result<>0) then
    LastErDesc:='Btrieve could not be loaded';

end;


FUNCTION EX_VERSION : SHORTSTRING;
Begin
  LastErDesc:='';

  If TestMode Then ShowMessage ('Ex_Version');
  {Result := FullVer; changed on 08.09.97 for security code }
  Result := Ver;

End;

PROCEDURE EX_TESTMODE (MODE : WORDBOOL);
Var
  ModeStr : String;
Begin
  LastErDesc:='';

  TestMode := WordBoolToBool(Mode);

  ModeStr := 'Test Mode is ';
  If TestMode Then ModeStr := ModeStr + 'On' Else ModeStr := ModeStr + 'Off';
  ShowMessage (ModeStr);
End;


// Tries to open JMiscF exclusively, returns TRUE if successful
Function ExclusiveCheck : Boolean;
Var
  iStatus : SmallInt;
Begin // ExclusiveCheck
  Result := False;
{$IFDEF EXSQL}
  If SQLUtils.UsingSQL Then
    Result := SQLUtils.ExclusiveAccess(SetDrive)
  Else
{$ENDIF}
  Begin
    // Check Btrieve is running and the file exists
    If Check4BtrvOK And FileExists(SetDrive+FileNames[JMiscF]) Then
    Begin
      // open the file exclusively
      iStatus := Open_File(F[JMiscF], SetDrive+FileNames[JMiscF], -4);
      If (iStatus = 0) then
      Begin
        // Opened OK - close the file
        iStatus := Close_File(F[JMiscF]);
        If (iStatus <> 0) Then AddExclusiveErrorLog (iStatus);
        Result := True;

        // Short pause to minimise the chance of problems before
        // the data files are opened normally
        Sleep(200);
      End; // If (iStatus = 0)
    End; // If Check4BtrvOK And FileExists(SetDrive+FileNames[JobMiscF])
  End; // Else
End; // ExclusiveCheck


{Function Open_Sys(Start,Fin  :  Integer)  :  Integer;}
function Open_Sys(FileNums : TFileNumSet) : integer;
const
  NoAttempts     =  100;   {* No of retries before giving up *}
var
  Choice,
  NoTrys,
  SetAccel       : integer;
  BtrieveRunning,
  SysFileFound   : boolean;
  {$IFDEF COMTK}
  ErrText        : ANSIString;
  {$ENDIF}
begin
  { Set Accelerated mode}
  Result:=0;
  SetAccel:=-1*Ord(AccelMode);
  BtrieveRunning := False;
  SysFileFound := False;
  Choice := 1; { Start;}
  Ch := ResetKey;

  NoTrys:=0;

  {* If (Not Check4BTrvOk) then  * Try Shelling Out and force load Btrieve
    JumpStart_Btrieve;           Won't work because heap too big..! use MUCDOS *}

{$IFDEF EXSQL}
  if SQLUtils.ValidCompany(SetDrive) then
{$ELSE}
  BtrieveRunning := Check4BtrvOK;
  SysFileFound := FileExists(SetDrive+FileNames[SysF]);

  if BtrieveRunning and SysFileFound then
{$ENDIF}
  begin
    while (Choice <= MAX_FILE_NUM){(Fin)} and (Ch<>#27) do
    begin
      NoTrys:=0;

      if Choice in FileNums then
      begin
        repeat
          Elded:=BOff;
          Status:=Open_File(F[Choice],SetDrive+FileNames[Choice],SetAccel);

          if (Status=0) then
            Elded:=BOn
          else
            Inc(NoTrys);

        until (Elded) or (NoTrys>NoAttempts);

        if (Status<>0) then
        begin
          {$IFDEF COMTK}
            // Display useful message
            //PR 11/04/03 Change to avoid showing dialogs
{            ErrText := 'An error ' + IntToStr(Status) + ' occurred trying to open ' + QuotedStr(SetDrive+FileNames[Choice]);
            Application.MessageBox(PCHAR(ErrText), 'Error in OpenToolkit', MB_OK + MB_ICONERROR);
            // Return Btrieve Error
            Result:=Status;}

            DlgMessageString := 'An error ' + IntToStr(Status) + ' occurred trying to open ' + QuotedStr(SetDrive+FileNames[Choice]);
            // Return Btrieve Error
            Result:=Status + 30000;



            // Break out of loop after first error }
            Break;
          {$ELSE}
{            ShowMessage('Unable to open '+SetDrive+FileNames[Choice]);
            Result:=Status;}
            DlgMessageString := 'Unable to open '+SetDrive+FileNames[Choice] + '. Error ' + IntToStr(Status);
            Result:=Status + 30000;
          {$ENDIF}
        end;
      end;
      inc(Choice);
    end; { while}
  end
  else
  begin
    { 16/04/1999 - Ensure system file not being found has its own error code }
    { previously system file not found would also give error 20 }
    if not SysFileFound then
      Result := 12;
    if not BtrieveRunning then
      Result := 20;
  end;

  Elded:=BOff;
end;



{ ============ Open/Close Files ============ }

Procedure Open_SetUp(DFnam  :  Str255;
                     Mode   :  Byte;
                 Var TmpIO  :  Integer);

Var
  LoopCnt  :  Integer;

Begin

  TmpIO:=0;

  FileMode:=66;

  {$I-}

  AssignFile(SetUpF,DFnam);
  LoopCnt:=0;

  Case Mode of

    0  :  Begin
            Repeat


              Reset(SetUpF);
              TmpIO:=IOResult;

              Inc(LoopCnt);

            Until (TmpIO<>32) or (LoopCnt>999);

          end;

    1  :  begin
            ReWrite(SetUpF);
            TmpIO:=IOResult;
          end;

  end; {Case..}



  {$I+}

end;

Function TClose_SetUp  :  Integer;
var
  TmpIO  :  Integer;
Begin

  TmpIO:=0;
  {$I-}
  Close(SetUpF);
  {$I+}

  If (IOResult<>0) then
    TmpIO:=12346;

  TClose_SetUp:=TmpIO;

end;


Procedure Close_SetUp;

Begin
  {$I-}

  Close(SetUpF);

  {$I+}

  If (IOResult<>0) then ;
end;


{=======================================================}

Function FullDate2IntDate(FDate  :  Str8)  :  LongDate;

Var
  SDD,SMM,SYY  :  Word;

Begin
  DateStr(Strip('A',['/','\','.','-',#32],FDate),SDD,SMM,SYY);

  FullDate2IntDate:=StrDate(SYY,SMM,SDD);

end;



{ ====== Procedure to Interpret SetUp Lines ====== }

Procedure Read_SetLine(LineNo  :  Longint;
                       Line    :  Str255);
Const
  SWON  :  Array[FALSE..TRUE] of String[3] = ('OFF','ON');
Var
  GenStr  :  Str255;
Begin
  GenStr:='';
  With ExSyss do
  Case LineNo of
    1   :   AutoSetPr:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    2   :   DefNom:=IntStr(ExtractWords(2,1,Line));
    3,4 :   DefCCDep[(LineNo=3)]:=FullCCDepKey (ExtractWords(2,1,Line));
    5   :   Begin
              GenStr:=ExtractWords(2,1,Line);
              DefVAT:=GenStr[1];
            end;
    6   :   AutoSetStkCost:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    7   :   DeductBOM:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    8   :   UseMLoc:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    9   :   OverWORef:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    10  :   OverWNPad:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    11  :   UseExCrRate:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    12  :   AllowEdit:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    13  :   Begin
              RepPrn:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
              RPrnNo:=IntStr(ExtractWords(3,1,Line));
            end;
    14  :   Begin
              RepFile:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
              RFileN:=ExtractWords(3,1,Line);
            end;
    15  :   ExPath:=ExtractWords(2,1,Line);
    16  :   MCMode:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    17  :   DefCur:=IntStr(ExtractWords(2,1,Line));
    18  :   UpAccBal:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    19  :   UpStkBal:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    20  :   JBIgnore:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    21  :   LastDate:=FullDate2IntDate(ExtractWords(2,1,Line));
    22  :   AllowQtyDel:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    23  :   AllowTotWeight:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    24  :   AllowTotCost:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    25  :   NoTranToClosedJob:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);
    26  :   begin
              GenStr:=ExtractWords(2,1,Line);
              if Trim(GenStr) = '' then
                DiscountDec := 2
              else
                DiscountDec := IntStr(GenStr);
            end;
    27  :   begin
              GenStr:=ExtractWords(2,1,Line);
              if Trim(GenStr) = ''then
                SQLCachingMode := 0
              else
                SQLCachingMode := IntStr(GenStr);
            end;
    28  :   begin
              GenStr:=ExtractWords(2,1,Line);
              if Trim(GenStr) = ''then
                SQLReloadCacheInterval := 0
              else
                SQLReloadCacheInterval := IntStr(GenStr);
            end;

    //PR: 15/10/2013 MRD 2.5.18
    31   :  begin
              GenStr:=ExtractWords(2,1,Line);
              if Trim(GenStr) = '' then
                AddressPostcodeMapping := 0
              else
                AddressPostcodeMapping := IntStr(GenStr);

              //Can currently only be 0 or 1
              if AddressPostcodeMapping > 1 then
                AddressPostcodeMapping := 1;

            end;

    //PR: 29/10/2013 ABSEXCH-14705
    32  :   begin
              GenStr:=ExtractWords(2,1,Line);
              if Trim(GenStr) = '' then
                DefaultUser := ''
              else
                DefaultUser := Trim(GenStr);
            end;

    //PR: 29/10/2013 ABSEXCH-14705
    33  :   begin
              GenStr:=ExtractWords(2,1,Line);
              if Trim(GenStr) = '' then
                ExSyss.DefaultCountryCode := ''
              else
                ExSyss.DefaultCountryCode := Trim(GenStr);
            end;
  end; {Case..}

end; {Proc..}



{ ====== Procedure to Store SetUp Lines ====== }

Procedure Write_SetLine(LineINo :  Byte;
                    Var TmpIO   :  Integer);

Const
  SWONBO  :  Array[BOff..BOn] of String[3] = ('OFF','ON');


Var
  GenStr  :  Str255;


Begin

  {$I-}

  GenStr:='';


  Case LineINo of

    1   :   GenStr:=SWONBO[ExSyss.AutoSetPr];

    2   :   GenStr:=Form_Int(ExSyss.DefNom,0);

    3,4
        :   GenStr:=ExSyss.DefCCDep[(LineINo=3)];

    5   :   GenStr:=ExSyss.DefVAT;

    6   :   GenStr:=SWONBO[ExSyss.AutoSetStkCost];

    7   :   GenStr:=SWONBO[ExSyss.DeductBOM];

    8   :   GenStr:=SWONBO[ExSyss.UseMLoc];

    9   :   GenStr:=SWONBO[ExSyss.OverWORef];

    10  :   GenStr:=SWONBO[ExSyss.OverWNPad];

    11  :   GenStr:=SWONBO[ExSyss.UseExCrRate];

    12  :   GenStr:=SWONBO[ExSyss.AllowEdit];

    13  :   Begin

              GenStr:=SWONBO[ExSyss.RepPrn]+Spc(2)+Form_Int(ExSyss.RPrnNo,0);

            end;

    14  :   Begin

              GenStr:=SWONBO[ExSyss.RepFile]+Spc(2)+ExSyss.RFileN;

            end;

    15  :   GenStr:=ExSyss.ExPath;

    16  :   GenStr:=SWONBO[ExSyss.MCMode];

    17  :   GenStr:=Form_Int(ExSyss.DefCur,0);

    18  :   GenStr:=SWONBO[ExSyss.UpAccBal];

    19  :   GenStr:=SWONBO[ExSyss.UpStkBal];

    20  :   GenStr:=SWONBO[ExSyss.JBIgnore];

    21  :   GenStr:=PoutDate(ExSyss.LastDate);

  end; {Case..}

  WriteLn(SetUpF,LJVar(SetUpSw[LineINo],Sizeof(SetUpSw[1])),'  ',GenStr);

  {$I+}

  TmpIO:=IOResult;

end; {Proc..}


Function Store_SetUp(DFName  :  Str255)  :  Integer;

Var
  Line  :  Str255;
  IOFlg :  Boolean;
  N     :  Byte;

Begin

  Open_SetUp(DFName,1,Result);

  If (Result=0) then
  Begin
    For n:=1 to NoSws do
      If (Result=0) then
        Write_SetLine(N,Result);

    Close_SetUp;

  end; {IF Opned Ok..}

end; {Proc..}


{ ====== Process SetUp File ====== }

Function Process_File(DFName  :  Str255)  :  Integer;

Var
  Line  :  Str255;

  ChkStat,
  TmpIO :  Integer;
  FoundOk,
  TmpBo,
  Abort
        :  Boolean;
  N     :  LongInt;

Begin

  FoundOk:=BOff;  N:=0;

  Result:=0;
  ChkStat:=0;


  Open_SetUp(DFName,0,Result);

  If (Result=0) then
  Begin
    {$I-}

    ReadLn(SetUpF,Line);

    Abort:=EOF(SetUpF);

    TmpIO:=IOResult;

    While (TmpIO=0) and (Not Abort) do
    Begin

      Abort:=EOF(SetUpF);

      N:=1;  FoundOk:=BOff;

      While (N<=NoSws) and (Not FoundOk) do
      Begin

        FoundOk:=Match_Glob(Succ(Length(Line)),SetUpSW[N],Line,TmpBo);

        If (Not FoundOk) then
          Inc(n);

      end; {While..}

      If (FoundOk) then
        Read_SetLine(N,Line);

      ReadLn(SetUpF,Line);

      TmpIO:=IOResult;

    end; {While..}

    If (TmpIO<>0) then
     Result:=TmpIO;

    ChkStat:=TClose_SetUp;

  end; {IF Opned Ok..}

  (*
  else
    Result:=Store_SetUp(DFname);
  *)

  {$I+}

  If (Result=0) and (ChkStat<>0) then
    Result:=ChkStat;

  If ExSyss.DiscountDec = 0 then
    ExSyss.DiscountDec := 2;

  if ExSyss.SQLCachingMode = 0 then
  begin
    if ExSyss.SQLReloadCacheInterval < 1 then
      ExSyss.SQLReloadCacheInterval := 300;
  end;
end; {Proc..}


Function PathChk(Var TPath : Str255) : Boolean;
const
  LastChar   = '\';
var
  I,
  TmpLength  :  SmallInt;
  ChkStatus  :  Boolean;
  TmpStr     :  String[1];

begin
  ChkStatus:=(DirectoryExists(TPath));
  If (ChkStatus) then
  begin
    TmpLength:=Length(TPath);
    TmpStr:=Copy(TPath,TmpLength,1);
    If (TmpStr<>LastChar) then
      TPath:=TPath+LastChar;
  end;
  PathChk:=ChkStatus;
end;
(*
Function CurrTimeSec : LongInt;
Var
  HH,MM,SS,MSS    :  Word;
  TimeInSec       :  LongInt;
begin
  TimeInSec:=0;
  DecodeTime(Now,HH,MM,SS,MSS);
  TimeInSec:=((((HH*60)+MM) * 60)+SS);  {* currenct time in seconds *}
  CurrTimeSec:=TimeInSec;
end;
*)


{ HM 09/10/00: Split out for COM Toolkit }
Function FindExchDllIniFile : ShortString;
Var
  IniPara          : Boolean;
  Ini_FilePath     : String[255];
  LengthModuleName : Integer;
  ModuleNameBuffer : Array[0..255] of char;
Begin { FindExchDllIniFile }
  Result := 'EXCHDLL.INI';

  {$IFDEF WIN32}
    // Help file states that the INI file is looked for in the DLL's directory
    //  - actually looked for in EXE's directory.  Maintain this for backward
    //  compatibility.

    Ini_FilePath:='';
    Ini_FilePath:=ParamStr(1);
    IniPara:=(Ini_FilePath<>'') and (Copy(Ini_FilePath,1,3)=INIFileSwitch);

    if IniPara then begin
      Ini_FilePath:=Copy(Ini_FilePath,4,Length(Ini_FilePath));
      Result := ExtractFileDir(Ini_FilePath)+'\EXCHDLL.INI'
    end
    else
      Result := ExtractFileDir(ParamStr(0))+'\EXCHDLL.INI';

    { Now check in DLL's directory }
    If (Not FileExists(Result)) Then Begin
      // HM 17/08/04: Modified for VAO compatibility - to keep backward compatibility
      // keep using the Apps directory unless we are running in VAO mode where the
      // apps directory could be any Enterprise directory.
      If (VAOInfo.vaoMode = smVAO) Then
        Result := IncludeTrailingPathDelimiter(VAOInfo.vaoCompanyDir) + 'EXCHDLL.INI'
      Else
        Result := IncludeTrailingPathDelimiter(VAOInfo.vaoAppsDir) + 'EXCHDLL.INI';

//      LengthModuleName := GetModuleFileName(HInstance, ModuleNameBuffer, SizeOf(ModuleNameBuffer));
//      if LengthModuleName > 0 then
//        Result := ExtractFileDir(ModuleNameBuffer) + '\EXCHDLL.INI';
    End; { If (Not FileExists(Result)) }
  {$ELSE}
    FindExchDllIniFile := ExtractFilePath(ParamStr(0))+'EXCHDLL.INI';
  {$ENDIF} { IFDEF WIN32 section }
End; { FindExchDllIniFile }


Procedure InitExSyss;
begin
  FillChar (ExSyss, Sizeof(ExSyss), 0);
  With ExSyss Do Begin
    UserName:='Exchequer DLL';
    RFileN:='EXImport.LOG';

    RepFile:=BOn;
    ImpDisplay:=BOn;
    UpAccBal:=BOn;
    WarnFError:=BOn;
    AllowEdit:=BOn;
    DelBatFile:=BOn;
    DeductBOM:=BOff;
    UseEOFFlg:=BOff;
    UpAccBal:=BOff;
    UpStkBal:=BOff;
  End; { With ExSyss }
end;


// HM 14/09/01: Added to allow the Enterprise Directory to be found aoutomatically
Function FindEnterpriseDir : ShortString;
Var
  ClsId  : ShortString;
Begin { FindEnterpriseDir }
  If (VAOInfo.vaoMode = smVAO) Then
  Begin
    Result := VAOInfo.vaoCompanyDir;
  End // If (VAOInfo.vaoMode = smVAO)
  Else
  Begin
    Result := '';

    // Lookup OLE Server in Registry to determine the Enterprise Directory
    With TRegistry.Create Do
    Begin
      Try
        { Require minimal permissions }
        Access := Key_Read;

        { Lookup OLE Server in Class Regestration section }
        RootKey := HKEY_CLASSES_ROOT;
        If KeyExists('Enterprise.OLEServer\Clsid') Then
          { OLE Server Key exists - get CLSID }
          If OpenKey('Enterprise.OLEServer\Clsid', False) Then
            If KeyExists('') Then Begin
              ClsId := ReadString ('');
              CloseKey;

              { Open CLSID up and get registered executable name }
              If OpenKey('Clsid\'+ClsId+'\LocalServer32', False) Then Begin
                ClsId := ReadString ('');

                // Check FileExists
                If FileExists (ClsId) Then
                  { Got File - Check its in current directory }
                  Result := IncludeTrailingBackSlash(Trim(ExtractFilePath(ClsId)));
              End; { If OpenKey('Clsid\'+ClsId+'\LocalServer32', False) }
            End; { If KeyExists('') }
      Finally
        Free;
      End;
    End; // With TRegistry.Create
  End; // Else
End; { FindEnterpriseDir}


// StandardStart , true = Toolkit, false = CalcPrice
FUNCTION InitialiseDLLMain(FileNums : TFileNumSet; StartMode : integer) : SMALLINT;
(*
Pre : StartMode : 0 = Normal start up of DLL via Toolkit user (true)
                  1 = Start up without normal checks e.g. via CalcPrice DLL
                  2 = Start up in eBusiness mode
                  3 = COM Toolkit
*)
var
  InitStr   :  Array[0..254] of Char;
  lLocked, GotRec,
  Locked,
  GotExclusive,
  SysRes    :  Boolean;
  CloseStat :  Integer;
  TempStr   :  ShortString;
  Res       :  LongInt;
  ExitTime  :  TDateTime;
  UCount    : Integer;
begin
  GotExclusive := False;
  {$IFDEF COMTK}
  LogF.AddLogMessage('InitDllU', 'InitialiseDLLMain', 'Start');
  {$ENDIF}
  Result := 0;

  {* ----- To check Release Code - 08.09.97 ------ *}

    { ***************************** Must Be Changed **************************}
    TotFiles:=MultiBuyF;
    { ***************************** --------------- **************************}

    Date_Inp_On:=BOff;
    GotPassWord:=BOff;
    GotSecurity:=BOff;

    {$IFDEF WIN32}
    New(CCVATName);
    FillChar(CCVATName^,Sizeof(CCVATName^),0);
    {$ENDIF}

    New(RepScr);
    New(RepFile);

    New(MiscRecs);
    New(MiscFile);
    FillChar(MiscRecs^,Sizeof(MiscRecs^),0);

    New(EntryRec);
    FillChar(EntryRec^,Sizeof(EntryRec^),0);

    New(JobMisc);
    New(CJobMisc);
    New(JobMiscFile);
    FillChar(CJobMisc^,Sizeof(CJobMisc^),0);

    New(JobRec);
    New(CJobRec);
    New(JobRecFile);
    FillChar(CJobRec^,Sizeof(CJobRec^),0);

    New(JobCtrl);
    New(JobCtrlFile);

    New(JobDetl);
    New(CJobDetl);
    New(JobDetlFile);
    FillChar(CJobDetl^,Sizeof(CJobDetl^),0);

    New(NomView);
    New(NomViewFile);


    New(MLocCtrl); {20.12.96}
    New(MLocFile);

    New(SyssVAT);
    New(SyssCurr);
    New(SyssDEF);
    New(SyssGCuR);
    New(SyssCurr1P);
    New(SyssGCur1P);

    New(SyssForms);
    New(SyssMod);
    New(SyssJob);  {* Added on 13.07.98 *}
    {Added on 16.11.98}
    New(SyssEDI1);
    New(SyssEDI2);
    New(SyssEDI3);

    // HM 07/09/01 (4.40): Added new global records
    New(UserProfile);
    FillChar(UserProfile^,Sizeof(UserProfile^),0);
    New(SyssCstm);
    FillChar(SyssCstm^,Sizeof(SyssCstm^),0);
    New(SyssCstm2);
    FillChar(SyssCstm2^,Sizeof(SyssCstm2^),0);

    New(CId);
    New(CInv);
    New(CStock);
    New(JBCostName);
    {$IFDEF WIN32}
    New(GlobalAllocRec);
    Fillchar(GlobalAllocRec^, SizeOf(GlobalAllocRec^), 0);
    New(DocStatus);
    FillChar(DocStatus^, SizeOf(DocStatus^), 0);
    {$ENDIF}

    DynamicVarsAllocated := true;

    FillChar(SyssVAT^,SizeOf(SyssVAT^),#0);
    FillChar(SyssCurr^,SizeOf(SyssCurr^),#0);
    FillChar(SyssGCUR^,SizeOf(SyssGCUR^),#0);
    FillChar(SyssDEF^,SizeOf(SyssDEF^),#0);
    FillChar(SyssForms^,SizeOf(SyssForms^),#0);
    FillChar(SyssMod^,SizeOf(SyssMod^),#0);
    FillChar(CId^,SizeOf(CId^),#0);
    FillChar(CInv^,SizeOf(CInv^),#0);
    FillChar(CStock^,SizeOf(CStock^),#0);
    FillChar(JBCostName^,SizeOf(JBCostName^),#0);

    DefineCust;
    DefineDoc;
    DefineIDetail;
    DefineNominal;

    {If (DeBug) then
      Ch:=ReadKey;}

    DefineStock;
    DefineNumHist;
    DefineCount;
    DefinePassWord;
    DefineMiscRecs;
    DefineJobMisc;
    DefineJobRec;
    DefineJobDetl;
    DefineJobCtrl;
    DefineMLoc;   {20.12.96}
    DefineRepScr;
    DefineSys;
    DefineNomView;

    if (StartMode <> 3) Then
      InitExSyss;

    { Read the Toolkit DLL INI file}
    if (StartMode in [0,2]) Then
    begin
      SetUpFN := FindExchDllIniFile;
    end; { StartMode }

    { ================================================ }

    FillChar(InitStr, SizeOf(InitStr), #0);
    {StrPCopy(InitStr,'/P:2048/u:2/m:48/b:1/f:128');}

    {$IFNDEF WIN32}
      Result:=BTRVINIT(InitStr);
    {$ELSE}
      Result:=Ord(Not Check4BtrvOk);
    {$ENDIF}

    if (Result = 0) and (StartMode in [0, 2]) then
    begin
      Result:=Process_File(SetUpFN);      {* process Exchdll.INI file *}
      {Returns standard run-time error code}
      {Map onto error 18 - "Cannot read INI file"}
      if (Result <> 0) then
        {$IFDEF HM}
        Result := 1000 + Result;
        {$ELSE}
        Result := 18;
        {$ENDIF}

      If (OVExPath) then
        ExSyss.ExPath:=OVExPathName;    {* If path is defined before calling Ini file *}

      If (OVMCSW) then                  {* If Override MCMode *}
        ExSyss.MCMode:=OVMCMode;

      If ((Result=0) and (Not EmptyKey(ExSyss.ExPath,80))) then
      begin
        If (PathChk(ExSyss.ExPath)) then  {* validate Path and "\" end 18.3.97 *}
          SetDrive:=EXSyss.ExPath         {* Exchequer Path *}
        else
          Result:=12;                     {* Invalid Exchequer Path *}
      end; {if..}
    end; {if..}

    {* To check Single/Multi Currency System 06.05.98 *}
    If (Result=0) and (StartMode in [0, 2, 3]) then
    begin
      If (ExSyss.MCMode) then
      begin
        If ((FileExists(ExSyss.ExPath+'DEF044.SYS')) or (FileExists(ExSyss.ExPath+'DEFPF044.SYS'))) then
          Result:=15;
      end
      else  {Multi Currency OFF }
      begin
        If ((FileExists(ExSyss.ExPath+'DEFMC044.SYS'))) then
          Result:=16;
      end; {if..}
    end; {if..}

    // EBusiness mode = 2
    SetFileNames(StartMode = 2);

    if Result=0 then
    begin
      // HM 05/11/04: Added exclusivity check to allow user counts to be reset
      GotExclusive := ExclusiveCheck;

      Result:=Open_Sys(FileNums); { was (1,TotFiles);}
    End; // if Result=0

    if Result=0 then  {* Get System file *}
      Init_AllSys;

    // Check Toolkit release code - if no backdoor code specified
    If (Result = 0) And CheckRelease And (Not Check_ModRel(4, BOn)) Then
      // No Toolkit Release Code
      Result := 32767;

    If (Result = 0) And CheckRelease Then Begin
     // Check User Count Licence and Add Login Reference
     Try
      With TMCMSecurity.Create (ssToolkit, SyssMod^.ModuleRel.CompanyID, FindEnterpriseDir) Do
        Try
          If Loaded Then Begin
            // EntComp.Dll loaded successfully

            // MH 16/01/06: Modified to use a record lock mechanism so that only one toolkit instance
            // can Login/Logout at a time in an attempt to kill User Count Corruption which appears
            // to be caused by the parallel nature of the code before this time.
//ODS.OutputString ('InitialiseDLLMain.LockControlRec');
            If LockControlRec Then
              Try
                // MH 23/01/2017 2017-R1 ABSEXCH-13259: Removed the ExchqSS User Count for the Toolkits
                // due to repeated problems in the MSSQL Edition.

                // HM 05/11/04: Added exclusivity check to allow user counts to be reset
                // Code copied from R&D\ELoginU.Pas
                If GotExclusive Then
                Begin
//ODS.OutputString ('InitialiseDLLMain.ResetForExclusive');

                  // Reset any user counts for the Company Id across all components (Entrprse, Toolkit, Trade, etc...
                  Res := ResetToolkitSecurityEx;
                  If (Res <> 0) Then
                  Begin
                    // Failed to reset MCM User Counts - Add error log and notify user
                    ResetUserCountErrorLog (Res, 'Error in ResetToolkitSecurityEx');
                  End; // If (Res <> 0) 
                End; // If GotExclusive

                If (Result = 0) Then
                Begin
                  // HM 05/11/02: Modified to automatically retry if certain errors are received
                  ExitTime := IncSecond(Now, 5); // Retry automatically for 5 seconds
                  Repeat
                    // Check to see if there are any user counts free
                    Res := AddLoginRefEx;

                    If (Res <> 0) And (Res <> 1003) Then
                      // Wait for random period between 1/100 and 1/5th of a second
                      Delay(10 + Random(190), True);
                  Until (Res = 0) Or (Res = 1003) Or (ExitTime < Now);

                  Case Res Of
                    { AOK }
                    0    : Begin
                             LoginLog := New_ILoginErrorLog (msUserId, msWorkstationId)
                           End;

                    { User Count Exceeded }
                    1002 : Result := 32764;

                    { Data Set not in the active MCM }
                    1003 : Result := 32761
                  Else
                    { Unknown error checking User Count Security - Check Last Error String }
                    Result := 32763;
                    LastErDesc := 'Error ' + IntToStr(Res) + ' in AddLoginRefEx';
                  End; { Case }
                End; { If (Result = 0) }
              Finally
//ODS.OutputString ('InitialiseDLLMain.UnlockControlRec');
                UnlockControlRec;
              End // Try..Finally
            Else
              // Timeout in User Security Sub-System
              Result := 32759;
          End { If Loaded }
          Else
            // Failed to load User Count Security Functions
            Result := 32766;
        Finally
          Free;
        End;
      Except
        //PR 11/04/03 Error loading security dll
        on E:Exception do
        begin
          if E.Message = 'Unable to load the Security Sub-System' then
            Result := 32760;
        end;
      End;
    End; { if (Result=0) and CheckRelease }

    If (Result = 0) Then Begin
      {* 06.04.2000 - Added for Customer Stock Analysis updating *}
      AnalCuStk:=(Check_ModRel(5,BOn)) or (Check_ModRel(6,BOn));

      { HM 25/08/00: Added for Paperless Module printing }
      eCommsModule := Check_ModRel(8,BOn);

      { HM 14/09/01: Added RelCode support for new Ent v5.00 modules }
      FullWOP := Check_ModRel(13,BOn);
      STDWOP := Check_ModRel(12,BOn);
      WOPOn := FullWOP or StdWOP;

//      EnSecurity := BOff; // Check_ModRel(??,BOn);
      EnSecurity := Check_ModRel(15,BOn);

      JBCostOn:=Check_ModRel(2,BOn);
      CISOn := Check_ModRel(16,BOn);
      JAPOn := Check_ModRel(17,BOn);
      SetEnterpriseType; //Sets StockOn & SPOPOn
      //PR 03/02/05 - added for full stock control
      FullStkSysOn:=(Check_ModRel(18,BOn) or WOPOn);
      VisualRWLicenced:=Check_ModRel(19,BOn);

//      ReturnsOn := Check_ModRel(19,BOn);
      RetMOn := Check_ModRel(20,BOn);
      EBankOn:=Check_ModRel(21,BOn);

      //AP 18/06/2018 v2018R1.1 Set GDPROn based on the license.
      GDPROn:=Check_ModRel(24,BOn);

      if SQLUtils.UsingSQL then
      begin
        //RB 22/08/2017 2017-R2 ABSEXCH-18933: Fix SQL connection failure issue in Toolkits
        //PR: 27/01/2014 ABSEXCH-14974 Need to initialise the global connection for SQL
        InitialiseGlobalADOConnection(SetDrive);
        StartSQLCaller(SetDrive, StockF);
        StartSQLCaller(SetDrive, MLocF);
      end;

      //PR: 27/10/2011 v6.9 Need to set the data path for the Custom Fields object.
      SetCustomFieldsPath(SetDrive);

      //PR: 02/12/2014 Order Payments. Pick up country code list from Exchequer install directory
      //AP: 20/02/2018 ABSEXCH-19722:Import of Traders failing as trying to read ISO3166-Countries.Xml from sub company not root directory
      CountryCodes.ISO3166XMLPath := VAOInfo.vaoAppsDir;
    End { If (Result = 0) }
    Else Begin
      // Error opening Toolkit - shutdown automatically
      TempStr := LastErDesc;
      Ex_CloseData;
      LastErDesc := TempStr;

      {$IFDEF COMTK}
        If (Result = 32767) Then
          // Display a warning message to inform user they need a licence
          Application.MessageBox ('The Company Data being opened is not licenced to use the COM Toolkit.' + #13#13 +
                                  'Please contact your Dealer or Distributor for information on licencing the COM Toolkit.',
                                  'Invalid Toolkit Licence', MB_OK + MB_ICONWARNING)
      {$ENDIF}
    End; { Else }

  {$IFDEF COMTK}
  LogF.AddLogMessage('InitDllU', 'InitialiseDLLMain', 'Finish. Result = ' + IntToStr(Result));
  {$ENDIF}
end; {InitialiseDLLMain}

{------------------------------------------------------------------------}

// Waits for up to NoSecs seconds for the Toolkit to be available
// before calling Ex_InitDLL
FUNCTION EX_INITDLLWAIT (Const NoSecs : SmallInt) : SMALLINT;
Var
  TimeOut : Double;
  Excep : Boolean;

  { Calculates the current time in seconds }
  Function CurrentTime : Double;
  Var
    wHour, wMin, wSec, wMSec  : Word;
    lHour, lMin, lSec, lMSec : LongInt;
  begin
    Result := 0;

    Try
      { Get current time }
      DecodeTime(Now, wHour, wMin, wSec, wMSec);

      { Copy fields into longs to force compiler to work in LongInt mode  }
      { otherwise you can get Range Check Errors as it works in Word mode }
      lHour := wHour;
      lMin  := wMin;
      lSec  := wSec;
      lMSec := wMSec;

      { Calculate number of seconds since midnight }
      Result := (lSec + (60 * (lMin + (lHour * 60)))) + (lMSec * 0.001);
    Except
{      On Ex: Exception Do
        MessageDlg ('The following exception occurred in xoCurrentTime: ' +
                    #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);}
        Excep := True;
    End;
  End;

Begin { Ex_InitDLLWait }
  Excep := False;
  // Check to see if the Toolkit is available
  If (GlobalTKLock <> 0) Then Begin
    // Record Start Time to monitor elapsed time
    TimeOut := CurrentTime + NoSecs;

    // Loop around until its free or timed-out
    While (GlobalTKLock <> 0) And (CurrentTime < TimeOut) and not Excep Do
      Application.ProcessMessages;
  End; { If (GlobalTKLock <> 0) }

  // Always call Ex_InitDLL to get errors setup correctly
  Result := Ex_InitDLL;
End; { Ex_InitDLLWait }

{------------------------------------------------------------------------}

FUNCTION EX_INITDLL : SMALLINT;
var
  i : integer;
  FileNums : TFileNumSet;
begin
  LastErDesc:='';

  // HM 24/09/01: Added instance locking to prevent data corruption
  If (GlobalTKLock = 0) Then Begin
    Inc (GlobalTKLock);

    if TestMode then
      ShowMessage ('Ex_InitDLL');

    FileNums := [];
    for i := 1 to SysF do
      include(FileNums, i);
    Include(FileNums, MultiBuyF);

    //PR: 15/02/2012 ABSEXCH-9795
    Include(FileNums, QtyBreakF);

    //PR: 27/07/2012 ABSEXCH-12956
    Include(FileNums, CurrencyHistoryF);

    Result := InitialiseDLLMain(FileNums, 0);

    ToolkitOpen := Result = 0;
  End { If (GlobalTKLock = 0) }
  Else
    // Toolkit already in use
    Result := 32762;

  // HM 04/11/04: Added ExInitDLL/OpenToolkit error log
  If (Result <> 0) Then
  Begin
    AddInitErrorLog (Result, LastErDesc);
  End; // If (Result <> 0)

  If (Result<>0) And (LastErDesc = '') then  { 10.10.2000 }
    LastErDesc:=Ex_ErrorDescription(1,Result);

  if (Result = 0) then
    InitAudit;
end;

{------------------------------------------------------------------------}

(* Replaced by specific eBusiness handling routines
FUNCTION EX_INITDLLEBUS : SMALLINT;
var
  i : integer;
  FileNums : TFileNumSet;
begin
  SetEBusinessMode(true);
  if TestMode then
    ShowMessage ('Ex_InitDLLEBus');

  FileNums := [];
  for i := 1 to SysF do
    include(FileNums, i);
  Result := InitialiseDLLMain(FileNums, 2);
end; *)

{------------------------------------------------------------------------}

function CalcPriceBtrieveInit : smallint;
var
  FileNums : TFileNumSet;
begin
  //PR: 19/04/2012 Wasn't opening new Qty Break file. ABSEXCH-12834
  FileNums := [CustF, StockF, MiscF, SysF, MultiBuyF, QtyBreakF];
  if UseLoc then
    FileNums := FileNums + [MLocF];
  Result := InitialiseDLLMain(FileNums, 1);
end;

{------------------------------------------------------------------------}

 { ========== Proc to Restore Global Heap Memory used by Pointers ========= }

procedure HeapVarTidy;
{ Note : Clears up all dynamically allocated variables from EX_InitDLL }
begin
  {$IFDEF WIN32}
  { Global variables of this sort handled differently in 16/32 bit DLLs ??? }
  if DynamicVarsAllocated then
  {$ENDIF}
  begin
    dispose(SyssDef);
    dispose(SyssCurr);
    dispose(SyssGCur);
    dispose(SyssCurr1P); {.055}
    dispose(SyssGCur1P); {.055}
    dispose(SyssJob);
    dispose(SyssVAT);
    dispose(SyssMod);       SyssMod := NIL;
    dispose(SyssForms);
    dispose(SyssEDI1);
    dispose(SyssEDI2);
    dispose(SyssEDI3);

    {$IFDEF WIN32}
    dispose(GlobalAllocRec);
    dispose(CCVATName);
    dispose(DocStatus);
    {$ENDIF}

    dispose(MiscRecs);
    dispose(MiscFile);
    dispose(RepScr);
    dispose(RepFile);
    dispose(CInv);
    dispose(CId);
    dispose(CStock);
    dispose(EntryRec);
    dispose(UserProfile);
    dispose(JBCostName);

    dispose(JobMisc);
    dispose(JobMiscFile);

    dispose(JobRec);
    dispose(JobRecFile);

    dispose(JobCtrl);
    dispose(JobCtrlFile);

    dispose(JobDetl);
    dispose(JobDetlFile);

    dispose(CJobMisc);

    dispose(CJobRec);
    dispose(CJobDetl);

    dispose(MLocCtrl);
    dispose(MLocFile);

    dispose(SyssCstm);
    dispose(SyssCstm2);

    //PR: 21/02/2011
    Dispose(NomView);
    Dispose(NomViewFile);



    DynamicVarsAllocated := false;
  end;
end; { HeapVarTidy}

{ ============= Close All Open Files ============= }

procedure DClose_Files(FileNums : TFileNumSet; ResetBtrieve : boolean;
  HeapCleanUp : boolean = true);
var
  Choice  :  Byte;
  FSpec   : FileSpec;
begin
  {$I-}
  for Choice := 1 to TotFiles do
    if Choice in FileNums then
    begin
      //PR: 06/11/2009 Removed GetFileSpec call to improve performance under SQL
      {* Check file is open b4 closing it *}
{      Status := GetFileSpec(F[Choice],Choice,FSpec);

      if (StatusOk) then}
        Status := Close_File(F[Choice]);
    end;

  if HeapCleanUp then
    HeapVarTidy;

  if ResetBtrieve then
    Status:=Reset_B;

  If (Debug) then
    Status_Means(Status);
  {$I+}
end;


{ ==== Function to Close Files and Stop BT ===== }

FUNCTION CloseTK(TestMsg : ShortString; Reset : Boolean; ErrNo  : SmallInt):  SMALLINT;
var
  i : integer;
  FileNums : TFileNumSet;
  Removed : Boolean;
begin
  {$IFDEF COMTK}
  LogF.AddLogMessage('InitDllU', 'CloseTK', 'Start');
  {$ENDIF}
  LastErDesc:='';

  if TestMode then ShowMessage (TestMsg);
  {$IFDEF COMTK}
   if not Assigned(SyssMod) then
     LogF.AddLogMessage('InitDllU', 'CloseTK', 'SyssMod = nil');
  {$ENDIF}

  // HM 14/09/01: Added Logout Code for User counts
  If CheckRelease And Assigned(SyssMod) Then Begin
    // Check User Count Licence and Add Login Reference
(*** HM 23/11/01: Temporaryiliry removed as causing problems becomes of Sharemem requirement
*) Try
    With TMCMSecurity.Create (ssToolkit, SyssMod^.ModuleRel.CompanyID, FindEnterpriseDir) Do
      Try
        If Loaded Then Begin
          // MH 16/01/06: Modified to use a record lock mechanism so that only one toolkit instance
          // can Login/Logout at a time in an attempt to kill User Count Corruption which appears
          // to be caused by the parallel nature of the code before this time.
//ODS.OutputString ('CloseTK.LockControlRec');
          If LockControlRec Then
            Try
              {$IFDEF COMTK}
              LogF.AddLogMessage('InitDllU', 'CloseTK', 'TMCMSecurity loaded');
              {$ENDIF}

              // MH 23/01/2017 2017-R1 ABSEXCH-13259: Removed the ExchqSS User Count for the Toolkits
              // due to repeated problems in the MSSQL Edition.

              Removed := False;
              If RemoveLoginRefExBool (Removed) Then
                If Removed Then Begin
                  {$IFDEF COMTK}
                  LogF.AddLogMessage('InitDllU', 'CloseTK', 'RemoveLoginRefExBool ok');
                  {$ENDIF}
                End { If Removed }
                else
                begin
                   Result := 31000;
                   LastErDesc := 'User count reference already removed';
                end;

              // HM 04/11/04: Added error log to report apps not shutting down correctly
              LoginLog.RemoveLog;
              LoginLog := NIL;
              {$IFDEF COMTK}
                LogF.AddLogMessage('InitDllU', 'CloseTK', 'After PutMultiSys');
                LogF.AddLogMessage('InitDllU', 'TMCMSecurity', '.msTotalUsers = ' + IntToStr(msTotalUsers));
              {$ENDIF}
            Finally
//ODS.OutputString ('CloseTK.UnlockControlRec');
              UnlockControlRec;
            End // Try..Finally
          Else
            // Timeout in User Security Sub-System
            Result := 32759;
        End { If Loaded }
        Else
          // Failed to load User Count Security Functions
          Result := 32766;
      Finally
        Free;
      End;
    Except
    End;
(* ***)
  End; { if (Result=0) and CheckRelease }

  FileNums := [];
  for i := 1 to SysF do
    include(FileNums, i);

  Include(FileNums, MultiBuyF);


  DClose_Files(FileNums, Reset);

  Result:=Status;

  If (GlobalTKLock > 0) Then Dec (GlobalTKLock);

  // CJS 2011-08-12 ABSEXCH-11265 - Cached data problem
  oCRECache.Clear;

  //PR 29/11/06: Stop logging error 3 (File not open) & 3006 (Invalid session)
  If not (Result in [0, 3]) and (Result <> 3006) then
  begin
    LastErDesc:=Ex_ErrorDescription(ErrNo,Result);

  // HM 04/11/04: Added ExInitDLL/OpenToolkit error log
    AddCloseErrorLog (Result, LastErDesc, TestMsg);
  End; // If (Result <> 0)

  {$IFDEF COMTK}
  LogF.AddLogMessage('InitDllU', 'CloseTK', 'End');
  {$ENDIF}

  //PR: 28/10/2011 v6.9 Destroy global Audit Notes object
  ClearAuditNoteObject;

end; {func..}

FUNCTION EX_CLOSEDLL  :  SMALLINT;
Begin { Ex_CloseDLL }
  Result := CloseTK('EX_CloseDLL', True, 2);
  ToolkitOpen := False;
End; { Ex_CloseDLL }

FUNCTION EX_CLOSEDATA : SMALLINT;
Begin { Ex_CloseData }
  Result := CloseTK('EX_CloseData', False, 121);
  ToolkitOpen := False;
  if SQLUtils.UsingSQL then
    CloseSQLCallers
End; { Ex_CloseData }

{* Not to check Release Code *}

Procedure EX_SETRELEASECODE(RELCODE  :  PCHAR);
var
  TmpStr  :  Str255;
Begin

  LastErDesc:='';

  TmpStr:=StrPas(RelCode);
  //PR: 1/03/05 Added extra backdoor for Exchequer Ireland.
  If (TmpStr=SECTESTMODE) or (TmpStr = IEDEBUGMODE) then
    CheckRelease:=BOff;

end; {proc..}

{* To overwrite ExPath and check MC system *}

Function  EX_INITDLLPATH(EXPATH    :  PCHAR;
                         MCSYSTEM  :  WORDBOOL) :  SMALLINT;
Const
  MCFileName  =  'DEFMC044.SYS';
  PFFileName  =  'DEFPF044.SYS';
  ChkFileName =  'EXCHQSS.DAT';
Var

  TExPath  :  Str255;
  ChkStat  :  Boolean;

begin

  LastErDesc:='';
  TExPath:=StrPas(ExPath);
  Result:=0;
  ChkStat:=BOn;

  If (Not EmptyKey(TExPath,80)) and (Not PathChk(TExPath)) then
    ChkStat:=BOff;

{$IFDEF EXSQL}
  if (ChkStat and SQLUtils.ValidCompany(TExPath)) then
{$ELSE}
  If (ChkStat) and (FileExists(TExPath+ChkFileName)) then
{$ENDIF}
    OVExPathName:=TExPath
  else
    ChkStat:=BOff;

  OVExPath:=ChkStat;

  If (ChkStat) then                 {* Check for MC *}
  begin
    ChkStat:= (WordBoolToBool(MCSystem) and (FileExists(TExPath+MCFileName))) or ((Not WordBoolToBool(MCSystem)) and (FileExists(TExPath+PFFileName)));

    OvMCSW:=ChkStat;

    If (ChkStat) then
      OVMCMode:=(WordBoolToBool(MCSystem) and (FileExists(TExPath+MCFileName)))
    else
      Result:=13; {File Not Found }

  end
  else
    Result:=12;  {Invalid Path}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(84,Result);

end; {func..}

{* ------ Get Exchequer Data Path ------- *}

Function EX_GETDATAPATH(VAR EXDATAPATH  :  PCHAR)  :  SMALLINT;
begin
  Result:=0;
  LastErDesc:='';

  With ExSyss do
  begin
    If (Not EmptyKey(ExPath,80)) then
      StrPCopy(ExDataPath,ExPath)
    else
      Result:=30001;
  end; {with..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(86,Result);

end; {func..}

Function EX_OVERRIDEINI(SETTING, VALUE : PCHAR) : SMALLINT;
{
  Pre  : Setting = String from INI file
         Value = string value to set to -
         use 'TRUE' or 'ON' for true; 'FALSE' or 'OFF' for false
  Post : Returns 0 if OK,
         30001 => INI file Key not found
         30002 => INI file Key can't be set
         30003 => INI file value invalid
}
var
  ValidInt,
  ValidBool,
  BoolVal : boolean;
  strSetting,
  strValue : string;
  i,
  intVal,
  SwitchNum : integer;

  procedure SetBool(var Value : boolean);
  begin
    if ValidBool then
      Value := BoolVal
    else
      Result := 30003;
  end;

begin
  LastErDesc:='';

  strSetting := Setting;
  strValue := Value;
  strValue := Trim(strValue);
  BoolVal := (UpCaseStr(Value) = 'ON') or (UpCaseStr(Value) = 'TRUE') or
    (UpCaseStr(Value) = 'YES');
  ValidBool := BoolVal or (UpCaseStr(Value) = 'OFF') or (UpCaseStr(Value) = 'FALSE') or
    (UpCaseStr(Value) = 'NO');
  IntVal := 0;
  ValidInt := false;
  if not ValidBool then
  try
    IntVal := StrToInt(Value);
    ValidInt := IntVal >= 0;
  except ;
    // Was getting an EOverflow raised here which wasn't being trapped ?
  end;

  SwitchNum := 0;
  for i := 1 to NoSws do
    if UpCaseStr(Trim(strSetting)) = UpCaseStr(SetUpSw[i]) then
      SwitchNum := i;

  Result := 0;
  with ExSyss do
    case SwitchNum of
      1 : SetBool(AutoSetPr);
      2 : if ValidInt then
            DefNom := intVal
          else
            Result := 30003;
      3 : DefCCDep[true] := strValue;
      4 : DefCCDep[false] := strValue;
      5 : if length(strValue) > 0 then
            DefVat := strValue[1];
      6 : SetBool(AutoSetStkCost);
      7 : SetBool(DeductBOM);
      8 : SetBool(UseMLoc);
      9 : SetBool(OverWORef);
      10: SetBool(OverWNPad);
      11: SetBool(UseExCrRate);
      12: SetBool(AllowEdit);
      13: Result := 30002; { Help file says ignored }
      14: Result := 30002; { Help file says ignored}
      15: Result := 30002; { Don't allow company path to be set - use Ex_InitDLLPath }
      16: Result := 30002; { Don't allow multi-currency to be set - use Ex_InitDLLPath }
      17: if ValidInt then
            DefCur := intVal
          else
            Result := 30003;
      18: SetBool(UpAccBal);
      19: SetBool(UpStkBal);
      20: SetBool(JBIgnore);
      21: LastDate := FullDate2IntDate(strValue);
      26: if ValidInt then
            DiscountDec := intVal
          else
            Result := 30003;

       //PR: 23/06/2009 Added new fields for Importer & Advanced Discounts     
      {$IFDEF IMPV6}
      29 : SetBool(ImpUseVBD);
      30 : SetBool(ImpUseMBD);
      {$ENDIF}
    else
      Result := 30001;
    end;

    If (Result<>0) then
      LastErDesc:=Ex_ErrorDescription(129,Result);

end; { EX_OVERRIDEINIBOOL}

Function EX_READINIVALUE(SETTING : PCHAR; VAR VALUE : PCHAR) : SMALLINT;
{
  Pre  : Setting = String from INI file
  Post : Value = 'ON' or 'OFF' for boolean values, the string or integer as string
         Returns 0 if OK,
         30001 => INI file Key not found
         30002 -> INI file Key can't be set
}
var
  i,
  SwitchNum : integer;
  strValue : string;

  function BoolToStr(Value : boolean) : string;
  begin
    if Value then
      Result := 'ON'
    else
      Result := 'OFF';
  end;

begin
  LastErDesc:='';

  SwitchNum := 0;
  for i := 1 to NoSws do
    if UpCaseStr(Trim(Setting)) = UpCaseStr(SetUpSw[i]) then
      SwitchNum := i;

  Result := 0;
  strValue := '';
  with ExSyss do
    case SwitchNum of
      1 : strValue := BoolToStr(AutoSetPr);
      2 : strValue := IntToStr(DefNom);
      3 : strValue := DefCCDep[true];
      4 : strValue := DefCCDep[false];
      5 : strValue := DefVAT;
      6 : strValue := BoolToStr(AutoSetStkCost);
      7 : strValue := BoolToStr(DeductBOM);
      8 : strValue := BoolToStr(UseMLoc);
      9 : strValue := BoolToStr(OverWORef);
      10: strValue := BoolToStr(OverWNPad);
      11: strValue := BoolToStr(UseExCrRate);
      12: strValue := BoolToStr(AllowEdit);
      13: Result := 30002; { Help file says ignored }
      14: Result := 30002; { Help file says ignored}
      15: strValue := ExPath;
      16: strValue := BoolToStr(MCMode);
      17: strValue := IntToStr(DefCur);
      18: strValue := BoolToStr(UpAccBal);
      19: strValue := BoolToStr(UpStkBal);
      20: strValue := BoolToStr(JBIgnore);
      21: strValue := LastDate;
      26: strValue := IntToStr(DiscountDec);
    else
      Result := 30001;
    end;
    StrPCopy(Value, strValue);

    If (Result<>0) then
      LastErDesc:=Ex_ErrorDescription(131,Result);

end; { EX_READINIVALUE }
{$UNDEF COMTK}
Initialization
  GlobalTKLock := 0;
  ToolkitOpen := False;
  LoginLog := NIL;

  // MH 26/02/2013 v7.0.2 ABSEXCH-14083: Added experimental clear-down of cache for Siclops issues
  Randomize;
Finalization
  {$IFNDEF COMTK}
  //PR 25/8/04 - Make sure tk gets closed and user count reset in the event of a crash
    if ToolkitOpen then
      Ex_CloseData;
  {$ENDIF}
end.
