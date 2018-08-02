unit RwOpenF;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ This module is used to automatically open any files }
{ needed by the report writer which are not normally  }
{ opened by Enterprise:                               }
{                                                     }
{     17  Data Dictionary                             }
{     18  Reports                                     }
{                                                     }

interface

Uses GlobVar,
     VarConst,
     BtrvU2,
     VarRec2U;

{$H-}   { Huge strings off }

{$I VarRecRP.Pas}

Const
  RepGrpLen = 10;
  ExportSig =  'ExRepExp';   { Used in the import/export routines }

Type
  PrintNotifyType = Record
    RepName  : String[10];   {  Rep Code }
  End; { PrintNotifyType }
  PrintNotifyPtr = ^PrintNotifyType;

Var
  DictRec     : ^DataDictRec;
  DictFile    : ^DataDict_FileDef;

  RepGenRecs  : ^RepGenRec;
  RepGenFile  : ^RepGen_FileDef;

  ExVersionNo : SmallInt;
  ExMultiCcy  : Boolean;

  RepRunCount : LongInt;

  GroupRepRec : ^RepGenRec;

  PrntOk      : Boolean;


Procedure Close_RW_Files;

Function FullRepCode(CCode  :  Str10) :  AnyStr;

Function FullDictCode(CCode  :  Str10) :  AnyStr;

implementation

Uses
  Dialogs,
  SysUtils,
  VarFPosU,
  {VarRPosU,}
  EtStrU,
  FileUtil;


Const
  VerParamStr = '/EXV:';

{$I VarCnst3.Pas}

Var
  ExitSave : Pointer;


Function FullRepCode(CCode  :  Str10) :  AnyStr;
Begin
  Result:=UpcaseStr(LJVar(Ccode,10));
end;

Function FullDictCode(CCode  :  Str10) :  AnyStr;
Begin
  Result:=UpcaseStr(LJVar(Ccode,8));
End;

{ Processes the command line parameters }
Procedure ProcessParams;
Var
  Tmp1       : ShortString;
  I, ErrCode : Integer;
Begin
  If (ParamCount > 0) Then
    For I := 1 To ParamCount Do Begin
      { Check for Exch Version flag }
      If (Copy (ParamStr(I), 1, Length(VerParamStr)) = VerParamStr) Then Begin
        { Got Exchequer version value }
        Tmp1 := Copy (ParamStr(I), (Length(VerParamStr) + 1), (Length(ParamStr(I)) - Length(VerParamStr)));
        Val (Tmp1, ExVersionNo, ErrCode);
      End; { If }
    End; { For }

  ExMultiCcy := (ExVersionNo >= 7);
End;


{ Closes any files opened in this module }
Procedure Close_RW_Files; Far;
Begin
  { restore ExitProc chain }
  ExitProc := ExitSave;

  { Close Btrieve files }
  Close_Files(BOn);

  { de-allocate memory }
  FreeMem (DictRec, SizeOf (DictRec^));
  FreeMem (DictFile, SizeOf (DictFile^));
  FreeMem (RepGenRecs, SizeOf (RepGenRecs^));
  FreeMem (RepGenFile, SizeOf (RepGenFile^));
  FreeMem (GroupRepRec, SizeOf (GroupRepRec^));
End;

Initialization
  { setup an ExitProc to automatically close an open files }
  ExitSave := ExitProc;
  ExitProc := @Close_RW_Files;

  ExVersionNo := 1;
  ProcessParams;

  { allocate memory for file records }
  GetMem (DictRec, SizeOf (DictRec^));
  GetMem (DictFile, SizeOf (DictFile^));
  GetMem (RepGenRecs, SizeOf (RepGenRecs^));
  GetMem (RepGenFile, SizeOf (RepGenFile^));
  GetMem (GroupRepRec, SizeOf (GroupRepRec^));

  { Define Btrieve structures }
  DefineDataDict;
  DefineRepGenRecs;
  Define_PVar;

  { open files }
  TotFiles := RepGenF;

  Open_System (RepGenF, RepGenF);

  //PR 01/05/2007: Change to allow Dictnary.dat to be in MCM dir only
  Status:=Open_File(F[DictF],GetEnterpriseDirectory+FileNames[DictF],0);
  If (Status <>0) then
  Begin
    If (Debug) then Status_Means(Status);
    MessageDlg('Error in File:'+FileNames[DictF]+' Type '+InttoStr(Status)+#13+
                            Set_StatMes(Status),mtInformation,[mbOk],0);
  end;


Finalization

end.
