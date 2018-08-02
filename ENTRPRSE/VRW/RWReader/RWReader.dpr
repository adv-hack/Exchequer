library RWReader;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

uses
  Sharemem,
  SysUtils,
  Classes,
  GlobVar in '..\..\R&D\GLOBVAR.PAS',
  Btrvu2 in '..\..\..\SBSLIB\WIN\WIN32\BTRVU2.PAS',
  RWRIntF in 'RWRIntF.pas',
  oReportTree in 'oReportTree.pas',
  SavePos in '..\..\FUNCS\SavePos.pas',
  oReportDetail in 'oReportDetail.pas';

{$R *.res}


Const
  RepGenF = 18;

Type
  TFileStatusType = (fsClosed, fsOpen);

  // ReportF + DictF record structures - copied in from VarRecRP.Pas
  ReportNomType = Record
    ReportKey   :  String[20];   {  RepName + LineRef}
    RepName     :  String[10];   {  Parent Code }
    RepVarNo    :  LongInt;      {  Field No. }
    VarType     :  Char;         {  R/I/H }
    PrintVar    :  Boolean;      {  Print this variable }
    Break       :  Byte;         {  Break Type Line, PAge }
    CalcField   :  Boolean;      {  Calculated Line}
    SubTot      :  Boolean;      {  Sub Total Field }
    Spare1      :  Array[1..6] of Byte;
    NomRef      :  String[10];   {  Nominal Lookup }
    RepLDesc    :  String[50];   {  Report Heading }
    VarSubSplit :  String[100];  {  Calculation String }
    NomTotals   :  Array[1..30] of Real; {* Temp Storage of Calculations *}
    RepPadNo    :  String[10];   {  Padded Line Refernce }
    Spare       :  Array[1..109] of Byte;
  End; // ReportNomType

  //------------------------------

  RNotesType = Record
      NoteNo    :  String[20];   { Folio/CustCode + NType + LineNo}
      NoteDate  :  LongDate;
      Spare3    :  Byte;
      Spare4    :  Array[1..5] of Byte;
      Spare5    :  Array[1..11] of Byte;
      NoteAlarm :  LongDate;
      NoteFolio :  String[10];
      NType     :  Char;
      LineNo    :  LongInt;
      NoteLine  :  String[100]; { Note Line }
      NoteUser  :  String[10];  { Note owner }
      Spare2    :  Array[1..326] of Byte;
  End; // RNotesType

  //------------------------------

  RepCmdType = Record
    ReportKey :  String[20];   {  RepName +Var Type + LineRef}
    RepName   :  String[10];   {  Parent Code }
    Command   :  String[255];
    Spare     :  Array[1..200] of Byte;
  End; // RepCmdType

  //------------------------------

  RepGenRec = Record
    RecPfix   :  Char;         {  Record Prefix }
    SubType   :  Char;         {  Subsplit Record Type }

      Case SmallInt of
        1  :  (ReportHed  :  ReportHedType);
        2  :  (ReportDet  :  ReportDetailType);
        3  :  (ReportNom  :  ReportNomType);
        4  :  (RNotesRec  :  RNotesType);
        5  :  (RCommand   :  RepCmdType);

  End; // RepGenRec

  //------------------------------

  RepGen_FileDef = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..4] of KeySpec;
    AltColt   :  AltColtSeq;
  End; // RepGen_FileDef


Var
  FileStatus  : TFileStatusType = fsClosed;

  ReportsRec  : RepGenRec;             // Data record
  ReportsFile : RepGen_FileDef;       // Btrieve info record

//-------------------------------------------------------------------------

// Opens the Reports.Dat in the specified directory so that the other functions
// can be used.
//
// Return values:-
//
//   1001   Invalid Data Path
//   2000+  Btrieve Error opening Reports.Dat with 2000 offset
Function rwrInit (Const DataPath : ShortString) : LongInt; Export; StdCall;
Var
  iStatus : SmallInt;

  // Defines minimal file information to allow file to be opened
  Procedure DefineReportF;
  Begin // DefineReportF
    // Setup entries within the global arrays storing the record lengths and address in memory
    FileRecLen[RepGenF]  := Sizeof(ReportsRec);
    RecPtr[RepGenF]      := @ReportsRec;

    // Setup the entries within the global arrays storing the size of the Btrieve file def
    // structure and its address in memory
    FileSpecLen[RepGenF] := Sizeof(ReportsFile);
    FileSpecOfs[RepGenF] := @ReportsFile;

    // Initialise the Record and Btrieve structures
    FillChar (ReportsRec, FileRecLen[RepGenF],  0);
    Fillchar (ReportsFile, FileSpecLen[RepGenF], 0);

    // Define the path and filename of the data file relative to the Enterprise directory
    FileNames[RepGenF] := 'Reports\Reports.Dat';
  End; // DefineReportF

Begin // rwrInit
  If DirectoryExists(DataPath) And FileExists(IncludeTrailingPathDelimiter(DataPath) + 'Reports\Reports.Dat') Then
  Begin
    Result := 0;

    // Define minimal file information to allow the reports file to be opened
    DefineReportF;

    // Try to open the reports file
    iStatus := Open_File(F[RepGenF], IncludeTrailingPathDelimiter(DataPath) + FileNames[RepGenF], -2);  // Read-Only
    If (iStatus = 0) Then
    Begin
      // Wahoo
      FileStatus := fsOpen;
    End // If (iStatus = 0)
    Else
      // SNAFU
      Result := 2000 + iStatus;  // Btrieve Error opening Reports.Dat
  End // If DirectoryExists(DataPath) And FileExists(
  Else
    Result := 1001;  // Invalid Data Path
End; // rwrInit

//-------------------------------------------------------------------------

// Closes Reports.Dat and tidies up after everything
Function rwrDeInit : LongInt; Export; StdCall;
Begin // rwrDeInit
  Result := 0;

  If (FileStatus = fsOpen) Then
  Begin
    Close_File(F[RepGenF])
  End; // If (FileStatus = fsOpen)
End; // rwrDeInit

//-------------------------------------------------------------------------

// Returns an IReportTree object which encapsulates the report tree and the reports
Function rwrGetReportTree : IReportTree; Export; StdCall;
Var
  oTree : TReportTree;

  Procedure ProcessParent (ParentCode : ShortString; TreeBranch : TReportTree);
  Var
    oTreeItem : TReportItem;
    iStatus   : SmallInt;
    sKey      : Str255;
  Begin // ProcessParent
    sKey := 'RH' + ParentCode;
    iStatus := Find_Rec(B_GetGEq, F[RepGenF], RepGenF, RecPtr[RepGenF]^, 0, sKey);
    While (iStatus = 0) And (ReportsRec.RecPfix = 'R') And (ReportsRec.SubType = 'H') And (Trim(ReportsRec.ReportHed.RepGroup) = Trim(ParentCode)) Do
    Begin
//ShowMessage (ReportsRec.ReportHed.RepName + ' - ' + ReportsRec.ReportHed.RepType);

      // HM 08/12/04: Suppressed Nominal Reports as they are not currently supported
      // by the new RW
      If (ReportsRec.ReportHed.RepType <> 'N') Then
      Begin
        With ReportsRec.ReportHed Do
        Begin
          // Add into report tree
          oTreeItem := TReportItem.Create (RepName, RepDesc, PWord, (RepType = 'H'));
        End; // With ReportsRec.ReportHed

        If (ReportsRec.ReportHed.RepType = 'H') Then
        Begin
          // Save the current position so we can restart where we left off
          With TBtrieveSavePosition.Create Do
          Begin
            Try
              // Save the current position in the file for the current key
              SaveFilePosition (RepGenF, 0);
              SaveDataBlock (@ReportsRec, SizeOf(ReportsRec));

              // Process any sub-reports of the group
              ProcessParent (ReportsRec.ReportHed.RepName, oTreeItem);

              // HM 08/12/04: Suppressed Nominal Reports as they are not currently supported
              // by the new RW
              If (oTreeItem.ReportCount > 0) Then
              Begin
                TreeBranch.AddSubReport(oTreeItem);
              End // If (oTreeItem.GetReportCount > 0)
              Else
                FreeAndNIL(oTreeItem);

              // Restore position in file
              RestoreDataBlock (@ReportsRec);
              RestoreSavedPosition;
            Finally
              Free;
            End; // Try..Finally
          End; // With TBtrieveSavePosition.Create
        End // If (ReportsRec.ReportHed.RepType = 'H')
        Else
        Begin
          TreeBranch.AddSubReport(oTreeItem);
        End; // Else
      End; // If (ReportsRec.ReportHed.RepType <> 'N')

      iStatus := Find_Rec(B_GetNext, F[RepGenF], RepGenF, RecPtr[RepGenF]^, 0, sKey);
    End; // While (iStatus = 0) And (ReportsRec.RecPfix = 'R') And (ReportsRec.SubType = 'H') And (ReportsRec.ReportHed.RepGroup = ParentCode)
  End; // ProcessParent

Begin // rwrGetReportTree
  If (FileStatus = fsOpen) Then
  Begin
    oTree := TReportTree.Create;
    ProcessParent ('          ', oTree);
    Result := oTree;
  End // If (FileStatus = fsOpen)
  Else
    Result := NIL;
End; // rwrGetReportTree

//-------------------------------------------------------------------------

// Returns an IReportDetails object for the specified report, returns NIL if
// the code is invalid
Function rwrGetReportDetails (Const ReportCode : ShortString) : IReportDetails; Export; StdCall;
Var
  oReportDets : TReportDetails;
  iStatus     : SmallInt;
  sKey        : Str255;
Begin // rwrGetReportDetails
  Result := NIL;

  // Load Report Header record
  sKey := 'RH' + ReportCode;
  iStatus := Find_Rec(B_GetEq, F[RepGenF], RepGenF, RecPtr[RepGenF]^, 1, sKey);
  If (iStatus = 0) Then
  Begin
    oReportDets := TReportDetails.Create(ReportsRec.ReportHed);
    Result := oReportDets;

    // Read Heading/Report Lines
    sKey := 'RR' + ReportCode;
    iStatus := Find_Rec(B_GetGEq, F[RepGenF], RepGenF, RecPtr[RepGenF]^, 0, sKey);
    While (iStatus = 0) And (ReportsRec.RecPfix = 'R') And (ReportsRec.SubType = 'R') And (ReportsRec.ReportDet.RepName = Result.rdReportHeader.RepName) Do
    Begin
      oReportDets.AddReportLine (ReportsRec.ReportDet);

      iStatus := Find_Rec(B_GetNext, F[RepGenF], RepGenF, RecPtr[RepGenF]^, 0, sKey);
    End; // While (iStatus = 0) And (ReportsRec.RecPfix = 'R') And (ReportsRec.SubType = 'R') And (Copy(ReportsRec.ReportHed.ReportKey, 1 10) = Result.rdReportHeader.RepName)

    // Read Input Lines
    sKey := 'RL' + ReportCode;
    iStatus := Find_Rec(B_GetGEq, F[RepGenF], RepGenF, RecPtr[RepGenF]^, 0, sKey);
    While (iStatus = 0) And (ReportsRec.RecPfix = 'R') And (ReportsRec.SubType = 'L') And (ReportsRec.ReportDet.RepName = Result.rdReportHeader.RepName) Do
    Begin
      oReportDets.AddReportLine (ReportsRec.ReportDet);

      iStatus := Find_Rec(B_GetNext, F[RepGenF], RepGenF, RecPtr[RepGenF]^, 0, sKey);
    End; // While (iStatus = 0) And (ReportsRec.RecPfix = 'R') And (ReportsRec.SubType = 'R') And (Copy(ReportsRec.ReportHed.ReportKey, 1 10) = Result.rdReportHeader.RepName)
  End; // If (iStatus = 0)
End; // rwrGetReportDetails

//-------------------------------------------------------------------------

Exports
  rwrInit,
  rwrDeInit,
  rwrGetReportTree,
  rwrGetReportDetails;
end.
