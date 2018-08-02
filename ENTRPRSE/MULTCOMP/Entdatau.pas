unit EntDataU;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Controls, Dialogs, Forms, Messages, SysUtils, Windows;

Type
  TCopyDataMode = (cdmExchequer=0, cdmLITE=1);

Procedure CopyCompanyData (IsSQL:Boolean; Const MainComp, NewComp : ShortString; Const CopyMode : TCopyDataMode);

implementation

Uses GlobVar, VarConst, VarFPosU, BtrvU2, EntRegU, CopyDatF, CopyOptF,
     BtSupU1, RegProg, RpCommon, EtStrU, DiskU, EntLicence,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     VarRec2U, MultiBuyVar, VarSortV, EntSettings,
     // MH 03/01/2018 2018-R1 ABSEXCH-19474: Added support for Anonymisation Diary
     GDPRConst, oAnonymisationDiaryBtrieveFile, oBtrieveFile;

Const
  SpareF = ReportF;

Type                       { File    Idx        Key }
  CopyTypes = (ctCust,     { CustF   CustCntyK  TradeCode[True] }
               ctCuNot,    { PwrdF   PWK        NoteTCode + NoteCCode }
               ctSupp,     { CustF   CustCntyK  TradeCode[False] }
               ctSuNot,    { PwrdF   PWK        NoteTCode + NoteCCode }
               ctJob,      { JobF    JobCodeK   all records }
               ctJobNot,   { PwrdF   PWK        NoteTCode + NoteJCode }
               ctJBudg,    { JCtrlF  JCK        JBRCode + JBBCode }
                           { JCtrlF  JCK        JBRCode + JBMCode }
                           { JCtrlF  JCK        JBRCode + JBSCode }
               ctJAnal,    { JMiscF  JMK        JARCode + JAACode }
               ctJType,    { JMiscF  JMK        JARCode + JATCode }
               ctEmpl,     { JMiscF  JMK        JARCode + JAECode }
               ctEmpRat,   { JCtrlF  JCK        JBRCode + JBECode }
                           { JCtrlF  JCK        JBRCode + JBPCode }
               ctNom,      { NomF    NomCodeK   all records }
               ctCC,       { PwrdF   PWK        CostCCode + CSubCode[True] }
               ctDep,      { PwrdF   PWK        CostCCode + CSubCode[False] }
               ctCDisc,    { MiscF   MIK        CDDiscCode + TradeCode[True] }
               ctSDisc,    { MiscF   MIK        CDDiscCode + TradeCode[False] }
               ctCQB,      { MiscF   MIK        QBDiscCode + TradeCode[True] }
               ctKQB,      { MiscF   MIK        QBDiscCode + QBDiscSub }
               ctSQB,      { MiscF   MIK        QBDiscCode + TradeCode[False] }
               ctRepWrt,   { RepGenF RGK        all records }
               ctFlags,    { SysF    SysK       See RecFilter }
               ctForms,    { SysF    SysK       See RecFilter }
                           { *.DEF & *.LST in data directory }
                           { Forms & Bitmaps in Forms directory }
               ctUsers,    { PwrdF   PWK        PassUCode + C0 }  { Users }
                           { PwrdF   PWK        PassUCode + C1 }  { Additional Security }
                           // MH 06/07/2015 v7.0.14 ABSEXCH-16378: Added user permissions record 2 and 3
                           { PwrdF   PWK        PassUCode + C2 }  { Additional Security }
                           { PwrdF   PWK        PassUCode + C3 }  { Additional Security }
               ctWinPos,   { MiscF   MIK        btCustTCode + btCustSCode }
               ctSignatures, { *.txt in DOCMASTR direcctory }
               ctStock,    { StockF  StkCodeK   all records }
               ctBOM,      { PwrdF   PWK        BillMatTCode + BillMatSCode }
               ctStkNot,   { PwrdF   PWK        NoteTCode + NoteSCode }
               ctMuLoc,    { MLocF   MLK        CostCCode + CSubCode[False] }
                           { MLocF   MLK        CostCCode + CSubCode[True] }
               ctAltCodes, { MLocF   MLK        NoteTCode + NoteCCode }

               ctMBDCust,  { MultiBuyF   mbdAcCodeK   See RecFilter }
               ctMBDSupp,  { MultiBuyF   mbdAcCodeK   See RecFilter }
               ctMBDStock,  { MultiBuyF   mbdAcCodeK   See RecFilter }

               ctGlobalSortViews,      { SortViewF   SVViewK   See RecFilter }
               ctUserSortViews,        { SortViewF   SVViewK   See RecFilter }
               ctUserSortViewSettings, { SVUDefaultF SVUserK   All records }

               ctUserColumnSettings,   { MISC\ColSet.Dat }
               ctUserParentSettings,   { MISC\ParSet.Dat }
               ctUserWindowSettings    { MISC\WinSet.Dat }
               );


  ProcessMode = (pmAdd, pmUpdate);

  TRecFilterProc = Function (Const CopTyp : CopyTypes) : Boolean;

  TFileProcess = Class(TObject)
  Private
    FDestPath : ShortString;
    FNum : SmallInt;
    FKeyPath : SmallInt;
    FSourcePath : ShortString;
    Procedure SetFNum(Value : SmallInt);
  Public
    // MH 03/01/2018 2018-R1 ABSEXCH-19474: Made progress window public so it can be re-used by code outside of this class
    RegisterProgress : TRegisterProgress;
    Constructor Create;
    Destructor  Destroy; OverRide;

    Procedure   ClearNewFile (Capt : ShortString);
    Procedure   FileList (Const FName : ShortString);
    Procedure   FinishProgress;
    Procedure   Process (Const CopTyp             : CopyTypes;
                         Const Mode               : ProcessMode;
                         Const KeyFind, ProgTitle : Str255;
                         Const FilterProc         : TRecFilterProc);
    Procedure   Reset;
    Procedure   StartProgress;
  Published
    Property DestPath : ShortString read FDestPath write FDestPath;
    Property FileNum : SmallInt read FNum write SetFNum;
    Property KeyPath : SmallInt read FKeyPath write FKeyPath;
    Property SourcePath : ShortString read FSourcePath write FSourcePath;
  End; { TFileProcess }

Var
  CopyItem : Array [CopyTypes] Of Boolean;
  ColSettings : ^TColumnSettingsRec;
  ParSettings : ^TParentSettingsRec;
  WinSettings : ^TWindowPositionRec;


Constructor TFileProcess.Create;
Begin
  Inherited Create;

  FNum := 1;
  FKeyPath := 0;
  RegisterProgress := TRegisterProgress.Create(Application);
  With RegisterProgress Do Begin
    Title := 'Copying Data';
    Descr := 'Please wait while the data is being copied to the new company';
    ShowProgInfo := True;
    Label1.Caption := 'Copying...';
    Label2.Caption := 'Item...';
  End; { With }
End;

Destructor TFileProcess.Destroy;
Begin
  RegisterProgress.Free;

  { Close files - may or may not be open }
  Reset;

  Inherited Destroy;
End;

Procedure TFileProcess.SetFNum(Value : SmallInt);
Begin
  If (Value In [1..MaxFiles]) Then Begin
    { Close any existing file }
    Reset;

    { restart the process }
    FNum := Value;

    { Copy file specs into SpareF }
    FileNames[SpareF]    := FileNames[FNum];

    RecPtr[SpareF]       := RecPtr[FNum];
    FileRecLen[SpareF]   := FileRecLen[FNum];

    FileSpecOfs[SpareF]^ := FileSpecOfs[FNum]^;
    FileSpecLen[SpareF]  := FileSpecLen[FNum];

    { open files }
    Status := Open_File(F[FNum], SourcePath + FileNames[FNum], 0);
    If StatusOk Then
      Status := Open_File(F[SpareF], DestPath + FileNames[SpareF], 0);
  End; { If }
End;

{ Re-Initialises the object }
Procedure TFileProcess.Reset;
Begin
  Close_File (F[FNum]);
  Close_File (F[SpareF]);
End;

Procedure TFileProcess.Process (Const CopTyp             : CopyTypes;
                                Const Mode               : ProcessMode;
                                Const KeyFind, ProgTitle : Str255;
                                Const FilterProc         : TRecFilterProc);
Type
  BuffType = Array [1..4096] Of Char;
Var
  TempBuff : ^BuffType;
  KeyS     : Str255;
  ICount   : LongInt;
  WantRec  : Boolean;
  LblStr   : ShortString;
Begin
  ICount := 1;

  With RegisterProgress Do Begin
    Label3.Caption := ProgTitle;
    Show;
    Refresh;
  End; { With }

  KeyS := KeyFind;
  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While StatusOk And CheckKey(KeyFind, KeyS, Length(KeyFind), BOn) Do Begin
    { Check this record is needed }
    If Assigned (FilterProc) Then
      WantRec := FilterProc (CopTyp)
    Else
      WantRec := True;

    If WantRec Then Begin
      With RegisterProgress Do Begin
        LblStr := '';
        Case CopTyp Of
          ctCust     : LblStr := Trim(Cust.Company);
          ctCuNot    : LblStr := Trim(Password.NotesRec.Notefolio);
          ctSupp     : LblStr := Trim(Cust.Company);
          ctSuNot    : LblStr := Trim(Password.NotesRec.Notefolio);
          ctJob      : LblStr := Trim(JobRec.JobCode);
          ctJobNot   : { no useable Id in record } ;
          ctJBudg    : LblStr := Trim(JobCtrl^.JobBudg.JobCode);
          ctJAnal    : LblStr := Trim(JobMisc^.JobAnalRec.JAnalCode);
          ctJType    : LblStr := Trim(JobMisc^.JobTypeRec.JobType);
          ctEmpl     : LblStr := Trim(JobMisc^.EmplRec.EmpCode);
          ctEmpRat   : LblStr := Trim(JobCtrl^.EmplPay.EmpCode);
          ctNom      : LblStr := IntToStr(Nom.NomCode) + ' - ' + Trim(Nom.Desc);
          ctCC,
          ctDep      : LblStr := Trim(Password.CostCtrRec.PCostC) + ' - ' + Trim(Password.CostCtrRec.CCDesc);
          ctCDisc,
          ctSDisc    : LblStr := Trim(MiscRecs^.CustDiscRec.DCCode);
          ctCQB      : LblStr := Trim(MiscRecs^.QtyDiscRec.QCCode);
          ctKQB      : { no useable Id in record } ;
          ctSQB      : LblStr := Trim(MiscRecs^.QtyDiscRec.QCCode);
          ctRepWrt   : With RepGenRecs^ Do
                         Case SubType Of
                           RepNoteCode   : LblStr := Trim(RepGenRecs^.RNotesRec.NoteFolio);
                           RepHedTyp     : LblStr := Trim(RepGenRecs^.ReportHed.RepName);
                           RepNomCode    : LblStr := Trim(RepGenRecs^.ReportNom.RepName);
                           RepLineTyp,
                           ReportGenCode : LblStr := Trim(RepGenRecs^.ReportDet.RepName);
                         End; { Case }
          ctFlags    : {LblStr := Syss.IDCode};
          ctForms    : ;
          ctUsers    : If (FNum = PwrdF) Then
                         LblStr := Trim(Password.PassEntryRec.Login)
                       Else
                         LblStr := Trim(MLocCtrl^.PassDefRec.Login);
          ctWinPos   : LblStr := Trim(MiscRecs^.btCustomRec.UserName);
          ctStock    : LblStr := Trim(Stock.StockCode);
          ctBOM      : LblStr := Trim(Password.BillMatRec.FullStkCode);
          ctStkNot   : { no useable Id in record } ;
          ctMuLoc    : With MLocCtrl^ Do Begin
                          If (SubType = CSubCode[True]) Then
                           LblStr := Trim(MLocLoc.loCode) + ' - ' + Trim(MLocLoc.loName)
                         Else
                           LblStr := Trim(MStkLoc.lsLocCode) + ' - ' + Trim(MStkLoc.lsStkCode);
                       End;
          ctAltCodes : LblStr := Trim(MLocCtrl^.SDbStkRec.sdAltCode);

          // MH 11/05/2009: Added support for Multi-Buy Discounts
          ctMBDCust  : LblStr := Trim(MultiBuyDiscount.mbdAcCode) + ' - ' + Trim(MultiBuyDiscount.mbdStockCode);
          ctMBDSupp  : LblStr := Trim(MultiBuyDiscount.mbdAcCode) + ' - ' + Trim(MultiBuyDiscount.mbdStockCode);
          ctMBDStock : LblStr := Trim(MultiBuyDiscount.mbdStockCode);

          // MH 11/05/2009: Added support for Sort Views
          ctGlobalSortViews      : LblStr := 'Global - ' + Trim(SortViewRec.svrDescr);
          ctUserSortViews        : LblStr := Trim(SortViewRec.svrUserId) + ' - ' + Trim(SortViewRec.svrDescr);
          ctUserSortViewSettings : LblStr := Trim(SortViewDefaultRec.svuUserId);

          // MH 16/11/2010 v6.5: Added support for new Window Positions/Colours tables
          ctUserColumnSettings   : LblStr := Trim(ColSettings.csExeName) + ' - ' + Trim(ColSettings.csUserName) + ' - ' + Trim(ColSettings.csWindowName);
          ctUserParentSettings   : LblStr := Trim(ParSettings.psExeName) + ' - ' + Trim(ParSettings.psUserName) + ' - ' + Trim(ParSettings.psWindowName);
          ctUserWindowSettings   : LblStr := Trim(WinSettings.wpExeName) + ' - ' + Trim(WinSettings.wpUserName) + ' - ' + Trim(WinSettings.wpWindowName);
        End; { Case }
        Label4.Caption := DoubleAmpers (LblStr);
        ProgPos:=Succ(ProgPos);
        Label4.Refresh;

        {If (ICount < 5) And (CopTyp In [ctMuLoc]) Then
          ShowMessage ('Pause');}
      End; { With }

      If False And (Mode = pmAdd) Then Begin
        { Add into new company }
        Status := Add_Rec(F[SpareF],SpareF,RecPtr[SpareF]^,KeyPath);
      End { If }
      Else Begin
        { Update if already exists - else add }

        { save copy of record }
        GetMem (TempBuff, SizeOf (TempBuff^));
        Move (RecPtr[FNum]^, TempBuff[1], FileRecLen[FNum]);

        Status:=Find_Rec(B_GetEq,F[SpareF],SpareF,RecPtr[SpareF]^,KeyPath,KeyS);
        {Report_BError (SpareF, Status);}

        { Restore copy }
        Move (TempBuff[1], RecPtr[FNum]^, FileRecLen[FNum]);
        FreeMem (TempBuff, SizeOf (TempBuff^));

        { Add / Update }
        If StatusOk Then
          { Update existing record }
          Status := Put_Rec(F[SpareF],SpareF,RecPtr[SpareF]^,KeyPath)
        Else
          { Add - as record doesn't exist }
          Status := Add_Rec(F[SpareF],SpareF,RecPtr[SpareF]^,KeyPath);

        {Report_BError (SpareF, Status);}
      End;  { Else }

      Inc (ICount);

      If (ICount Mod 5) = 0 Then Application.ProcessMessages;
    End; { With }

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  End; { While }

  { HM 21/01/98: Added as it was causing the Data Copy wizard to fail incorrectly }
  If (Status = 9) Then Status := 0;
End;

{ Initialises the Progress window }
Procedure TFileProcess.StartProgress;
Begin
  Application.ProcessMessages;

  With RegisterProgress Do Begin
    ProgMin := 0;
    ProgMax := Used_Recs(F[Fnum],Fnum);
    ProgPos := 0;
  End; { With }
End;

{ finishes the progress bar }
Procedure TFileProcess.FinishProgress;
Begin
  With RegisterProgress Do Begin
    ProgPos := ProgMax;
    Refresh;
    Label3.Caption := '';
    Label4.Caption := '';
    ProgPos := 0;
    Refresh;
  End; { With }

  Application.ProcessMessages;
End;

Procedure TFileProcess.ClearNewFile (Capt : ShortString);
Var
  KeyS : Str255;
Begin
  With RegisterProgress Do Begin
    ProgMin := 0;
    ProgMax := Used_Recs(F[SpareF],SpareF);
    ProgPos := 0;
    Label3.Caption := Capt;
    Show;
    Refresh;

    KeyS := '';
    Status:=Find_Rec(B_StepFirst,F[SpareF],SpareF,RecPtr[SpareF]^,KeyPath,KeyS);

    While StatusOk Do Begin
      Status:=Delete_Rec(F[SpareF],SpareF,KeyPath);

      Status:=Find_Rec(B_StepFirst,F[SpareF],SpareF,RecPtr[SpareF]^,KeyPath,KeyS);
      ProgPos:=Succ(ProgPos);
    End; { While }
  End; { With }

  FinishProgress;
End;

{ Produces a file containing a list of the contents - development only }
Procedure TFileProcess.FileList (Const FName : ShortString);
{Type
  BuffType = Array [1..4096] Of Char;
Var
  OutF   : TextFile;
  B1, B2 : ^BuffType;
  KeyS   : Str255;
  I      : LongInt;}
Begin
  (*
  AssignFile (OutF, FName);
  Rewrite    (OutF);

  { Get first source record }
  KeyS := '';
  Status:=Find_Rec(B_GetFirst,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  If StatusOk Then Begin
    { Take copy of record }
    GetMem (B1, SizeOf (B1^));
    Move (RecPtr[FNum]^, B1[1], FileRecLen[FNum]);
    FillChar (RecPtr[FNum]^, FileRecLen[FNum], #8);

    { Get first dest record }
    KeyS := '';
    Status:=Find_Rec(B_GetFirst,F[SpareF],SpareF,RecPtr[SpareF]^,KeyPath,KeyS);
    If StatusOk Then Begin
      GetMem (B2, SizeOf (B2^));
      Move (RecPtr[SpareF]^, B2[1], FileRecLen[SpareF]);

      Writeln (OutF, 'RecLen:');
      Writeln (OutF, '  FNum:   ', FileRecLen[FNum]:3);
      Writeln (OutF, '  SpareF: ', FileRecLen[SpareF]:3);
      Writeln (OutF);
      Writeln (OutF, 'Idx   FNum   SpareF');

      For I := 1 To FileRecLen[SpareF] Do Begin
        Write (OutF, I:3,
                     '    ',
                     Ord(B1^[I]):3,
                     '     ',
                     Ord(B2^[I]):3);
        If (Ord(B1^[I]) <> Ord(B2^[I])) Then
          Writeln (OutF, '  ****', B1^[I])
        Else
          Writeln (OutF, '      ', B1^[I]);
      End; { If }

      FreeMem (B2, SizeOf (B2^));
    End; { If }

    FreeMem (B1, SizeOf (B1^));
  End; { If }
  *)
  (*
  While StatusOk Do Begin
    Case FNum Of
      MiscF   : With MiscRecs^ Do Begin
                  Writeln (OutF, RecMFix + '-' + SubType);
                End;
      JCtrlF  : With JobCtrl^ Do Begin
                  Writeln (OutF, RecPFix + '-' + SubType);
                End; { With }
      JMiscF  : With JobMisc^ Do Begin
                  Writeln (OutF, RecPFix + '-' + SubType);
                End; { With }
    End; { Case }

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  End; { While }
  *)

  {Close (OutF);}
End;


{ *************************************************************************** }

{ Called by Process to filter for specific data types }
Function RecFilter (Const CopTyp : CopyTypes) : Boolean;
Var
  KeyS : Str255;
Begin
  Result := True;

  Case CopTyp Of
    { Customer / Supplier Notes - need to get Cust/Supp record for filtering }
    ctCuNot  : With Password.NotesRec Do Begin
                 KeyS := NoteFolio;
                 Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);

                 If StatusOk And CheckKey(NoteFolio, KeyS, Length(NoteFolio), BOn) Then
                   Result := (CopyItem[ctCuNot] And (Cust.CustSupp = TradeCode[True])) Or
                             (CopyItem[ctSuNot] And (Cust.CustSupp = TradeCode[False]));
               End;

    ctFlags  : With Syss Do Begin
                 If CopyItem[ctFlags] Then Begin
                   { System Setup Information }
                   { HM 06/10/99: Added missing System Setup Records:- GCurR, EDI1R..EDI3R }
                   Result := (IDCode = SysNames[SysR]) Or (IDCode = SysNames[VATR]) Or
                             (IDCode = SysNames[CurR]) Or (IDCode = SysNames[GCuR]) Or
                             (IDCode = SysNames[JobSR]) Or (IDCode = SysNames[ModRR]) Or
                             (IDCode = SysNames[EDI1R]) Or (IDCode = SysNames[EDI2R]) Or
                             (IDCode = SysNames[EDI3R]) Or
                   // HM 04/02/03: Added missing System Setup Records
                             (IDCode = SysNames[CuR2]) Or (IDCode = SysNames[CuR3]) Or
                             (IDCode = SysNames[GCU2]) Or (IDCode = SysNames[GCU3]) Or
                             (IDCode = SysNames[CstmFR]) Or (IDCode = SysNames[CstmFR2]) Or
                             (IDCode = SysNames[CISR]);
                 End; { If }

                 // HM 08/03/01: Corrected support for copying all form sets
                 If (Not Result) And CopyItem[ctForms] Then Begin
                   { Form Information - check for standard form records }
                   Result := (IDCode = SysNames[DefR]) Or (IDCode = SysNames[FormR]);

                   If (Not Result) Then
                     // Check for additional form sets - 'FR' + Chr(100)+
                     Result := (Copy(IDCode, 1, 2) = Copy (SysNames[FormR], 1, 2)) And
                               (Ord(IDCode[3]) >= 100);
                 End; { If (Not Result) And CopyItem[ctForms] }
               End; { With }
    ctStock  : With Stock Do Begin
                 { Zero stock levels }
                 QtyInStock   := 0.0;
                 QtyPosted    := 0.0;
                 QtyAllocated := 0.0;
                 QtyOnOrder   := 0.0;
                 QtyFreeze    := 0.0;
                 QtyTake      := 0.0;
                 QtyPicked    := 0.0;
               End; {  With }
    ctMuLoc  : With MLocCtrl^, MStkLoc Do Begin
                 { Zero stock levels }
                 If (SubType = CSubCode[False]) Then Begin
                   lsQtyInStock := 0.0;
                   lsQtyOnOrder := 0.0;
                   lsQtyAlloc   := 0.0;
                   lsQtyPicked  := 0.0;
                   lsQtyFreeze  := 0.0;
                   lsQtyPosted  := 0.0;
                   lsQtyTake    := 0.0;
                 End; { If }
               End; {  With }

    // HM 06/07/04: Added re-initialisation of JPT/JST references
    ctJob    : Begin
                 JobRec.JPTOurRef := '';
                 JobRec.JSTOurRef := '';
               End;

    // HM 06/07/04: Added re-initialisation of Job Budget Valuations
    ctJBudg  : Begin
                 JobCtrl^.JobBudg.OrigValuation := 0.0;
                 JobCtrl^.JobBudg.RevValuation := 0.0;
                 JobCtrl^.JobBudg.JAPcntApp := 0.0;
               End;

    // MH 11/05/2009: Added support for Multi-Buy Discounts
    ctMBDCust  : Result := MultiBuyDiscount.mbdOwnerType = 'C';
    ctMBDSupp  : Result := MultiBuyDiscount.mbdOwnerType = 'S';
    ctMBDStock : Result := MultiBuyDiscount.mbdOwnerType = 'T';

    // MH 11/05/2009: Added support for Sort Views
    ctGlobalSortViews : Result := (Trim(SortViewRec.svrUserId) = '');
    ctUserSortViews   : Result := (Trim(SortViewRec.svrUserId) <> '');
  End; { Case }
End;


{ Copies selected data from one company to another company }
Procedure CopyCompanyData (IsSQL:Boolean; Const MainComp, NewComp : ShortString; Const CopyMode : TCopyDataMode);
Const
  DoneCode = 'D';
Var
  CopyDataWiz1 : TCopyDataWiz1;
  CopyDataWiz2 : TCopyDataWiz2;

  WantCopy     : Boolean;
  WizId        : Byte;
  ExCode       : Char;
  SelPath      : ShortString;

  { Copies files identified by fspec in sourcedir to destdir }
  Procedure CopyFiles (Const FSpec, SourceDir, DestDir : ShortString);
  Var
    SPath, DPath : PChar;
    FileInfo     : TSearchRec;
    FStatus      : SmallInt;
  Begin
    FStatus := FindFirst(SourceDir + FSpec, faReadOnly, FileInfo);

    SPath := StrAlloc (255);
    DPath := StrAlloc (255);

    While (FStatus = 0) Do Begin
      If (FileInfo.Name <> '.') And (FileInfo.Name <> '..') Then Begin
        { Copy file to dest directory }
        StrPCopy (SPath, SourceDir + FileInfo.Name);
        StrPCopy (DPath, DestDir + FileInfo.Name);

        CopyFile (SPath, DPath, False);
      End; { If }

      FStatus := FindNext(FileInfo);
    End; { While }

    SysUtils.FindClose (FileInfo);

    StrDispose (SPath);
    StrDispose (DPath);
  End;

  {$IFDEF EXSQL}

  {The SQL version of the data copy wizard function}
  function DoTheSQLBiz(const Path: String): Boolean;
  var
    lRes : Integer;
    lSourceComp,
    lDestComp, Key : String;
  Begin
    lRes := 0;
    Result := False;

//    Showmessage('copy table. loading from ' + path);
    {try loading the emulator}
    Try
      if not sqlutils.Load_DLL(Path) then
        lRes := -1;
    Except
    end;

    if lRes = 0 then
    begin
      Try
        lRes := sqlutils.OverrideUsingSQL(True);

        if lRes = 0 then
        begin
          if sqlutils.ValidCompany(SelPath) then
            lSourceComp := GetCompanyCode(SelPath);

          if sqlutils.ValidCompany(NewComp) then
            lDestComp := GetCompanyCode(NewComp);

          { NomF }
          If CopyItem[ctNom] Then Begin

              If lRes = 0 Then Begin
                { Nominal Control Codes - Complete File Contents - clear existing contents first }
    //            ClearNewFile ('General Ledger Accounts');

                {copy table fails passing key=''}
                Key := '1=1';
                lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'Nominal.DAT', Key, True);  // DeleteIfExists
//If (lRes = 10) Then
//  ShowMessage(GetSQLErrorInformation(lRes));
              End { If }
              Else
                lRes := 2002;
          End; { If }

          { StockF }
          If CopyItem[ctStock] Then Begin

              If lRes = 0 Then Begin
                { Stock Records - Complete File contents }
    //            ClearNewFile ('Stock Items');
                // delete all records (ask chris/irfan)

                {copy table fails passing key=''}
                Key := '1=1';
                lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'Stock.DAT', Key, True);
              End { If }
              Else
                lRes := 2003;
          End; { If }

          { PWrdF }
          If CopyItem[ctUsers] Or CopyItem[ctCC]    Or CopyItem[ctDep] Or
             CopyItem[ctBOM]   Or CopyItem[ctCUNot] Or CopyItem[ctSUNot] Or
             CopyItem[ctStkNot] Or CopyItem[ctJobNot] Or CopyItem[ctFlags] Then Begin

              If lRes = 0 Then Begin
                { Users }
                If CopyItem[ctUsers] Then Begin
                  Key :=  ' recpfix = ' + QuotedStr(PassUCode) + ' and subtype = 0'; // + QuotedStr(C0);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);

                  Key := ' recpfix = ' + QuotedStr(PassUCode) + ' and subtype = 1'; // + QuotedStr(Chr(1));
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);

                  // MH 06/07/2015 v7.0.14 ABSEXCH-16378: Added user permissions record 2 and 3
                  Key := ' recpfix = ' + QuotedStr(PassUCode) + ' and subtype = 2';
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);

                  Key := ' recpfix = ' + QuotedStr(PassUCode) + ' and subtype = 3';
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);
                End; { If }

                { Cost Centres }
                If CopyItem[ctCC] Then Begin
                  Key := ' recpfix = ' + QuotedStr(CostCCode) + ' and subtype = ' + IntToStr(Ord(CSubCode[True]));
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);
If (LRes = 10) Then
  ShowMessage('DataCopyWizard[ctCC]: ' + GetSQLErrorInformation(lRes));
                End; { If }

                { Departments }
                If CopyItem[ctDep] Then Begin
                  Key := ' recpfix = ' + QuotedStr(CostCCode) + ' and subtype = ' + IntToStr(Ord(CSubCode[False]));
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);
                End; { If }

                { Bill Of Materials }
                If CopyItem[ctBOM] Then Begin
                  Key := ' recpfix = ' + QuotedStr(BillMatTCode) + ' and subtype = ' + IntToStr(Ord(BillMatSCode));

                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);
                End; { If }

                { Customer Notes }
                If CopyItem[ctCuNot] Or CopyItem[ctSuNot] Then Begin

                  Key := ' recpfix = ' + QuotedStr(NoteTCode) + ' and subtype = ' + IntToStr(Ord(NoteCCode));

                  If CopyItem[ctCuNot] And CopyItem[ctSuNot] Then
                  Begin
                    { Want both - just copy the lot }
                    lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);
                  End // If CopyItem[ctCuNot] And CopyItem[ctSuNot]
                  Else
                  begin
                    { Want either - need to filter }

                    Key := '  notefolio in ( select accode from custsupp where ' +
                      '( (accustsupp = ' + QuotedStr(TradeCode[True])  + ') or (accustsupp = ' +
                      QuotedStr(TradeCode[False])  + ' ) ) )  ';

                    lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);
                  end; { begin }
                End; { If }

                { Stock Notes }
                If CopyItem[ctStkNot] Then Begin
                  Key := ' recpfix = ' + QuotedStr(NoteTCode) + ' and subtype = ' + IntToStr(Ord(NoteSCode));

                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);
                End; { If }

                { Job Notes }
                If CopyItem[ctJobNot] Then Begin
                  Key := ' recpfix = ' + QuotedStr(NoteTCode) + ' and subtype = ' + IntToStr(Ord(NoteJCode));

                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);
                End; { If }

                { Duplicate Security }
                If CopyItem[ctFlags] Then Begin
                  Key := ' recpfix = ' + QuotedStr(PostUCode) + ' and subtype = 86'; // + QuotedStr('V');

                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqChk.DAT', Key, True);
                End; { If }
              End { If }
              Else
                lRes := 2004;
          End; { If }

          { CustF }
          If CopyItem[ctCust] Or CopyItem[ctSupp] Then Begin

              // copy everything if both are set
              If lRes = 0 Then
              Begin
                { Customers }
                If CopyItem[ctCust] Then Begin
                  // Customer Records
                  Key := ' accustsupp = ' + QuotedStr(TradeCode[True]);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'CUSTSUPP.DAT', Key, True);

                  // Anonymisation Diary Entries for Customers
                  Key := ' adEntityType = 0';
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ANONYMISATIONDIARY.DAT', Key, True);
                End; { If }

                { Suppliers }
                If CopyItem[ctSupp] Then Begin
                  // Supplier Records
                  Key := ' accustsupp = ' + QuotedStr(TradeCode[False]);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'CUSTSUPP.DAT', Key, True);

                  // Anonymisation Diary Entries for Customers
                  Key := ' adEntityType = 1';
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ANONYMISATIONDIARY.DAT', Key, True);
                End; { If }
              End { If }
              Else
                lRes := 2001;
          End; { If }

          { MiscF }
          If CopyItem[ctCDisc] Or CopyItem[ctSDisc] Or CopyItem[ctWinPos] Or
             CopyItem[ctCQB]   Or CopyItem[ctKQB]   Or CopyItem[ctSQB] Then Begin

              If lRes = 0 Then Begin

                If CopyItem[ctCDisc] Then Begin
                  { Customer Discounts }
                  Key := ' recmfix = ' + QuotedStr(CDDiscCode) + ' and subtype = ' + QuotedStr(TradeCode[True]);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExStkChk.DAT', Key, True)
                End; { If }

                If CopyItem[ctCQB] Then Begin
                  { Customer Quantity Breaks }
                  Key := ' recmfix = ' + QuotedStr(QBDiscCode) + ' and subtype = ' + QuotedStr(TradeCode[True]);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExStkChk.DAT', Key, True)
                End; { If }

                If CopyItem[ctSDisc] Then Begin
                  { Supplier Disounts }
                  Key := ' recmfix = ' + QuotedStr(CDDiscCode) + ' and subtype = ' + QuotedStr(TradeCode[False]);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExStkChk.DAT', Key, True)
                End; { If }

                If CopyItem[ctSQB] Then Begin
                  { Supplier Quantity Breaks }
                  Key := ' recmfix = ' + QuotedStr(QBDiscCode) + ' and subtype = ' + QuotedStr(TradeCode[False]);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExStkChk.DAT', Key, True)
                End; { If }

                If CopyItem[ctKQB] Then Begin
                  { Stock Quantity Breaks }
                  Key := ' recmfix = ' + QuotedStr(QBDiscCode) + ' and subtype = ' + QuotedStr(QBDiscSub);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExStkChk.DAT', Key, True)
                End; { If }

                If CopyItem[ctWinPos] Then Begin
                  { Window Colours/Positions }
                  Key := ' recmfix = ' + QuotedStr(btCustTCode) + ' and subtype = ' + QuotedStr(btCustSCode);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExStkChk.DAT', Key, True)
                End; { If }
              End { If }
              Else
                lRes := 2005;
          End; { If }

          { SysF }
          If CopyItem[ctFlags] Or CopyItem[ctForms] Then Begin

              If lRes = 0 Then Begin
                { System Setup }

                   Key := ' (IDCode = ' + StringToHex(SysNames[SysR], 0, true)   + ' ) Or (IDCode = ' + StringToHex(SysNames[VATR], 0, true)    + ') Or ' +
                          ' (IDCode = ' + StringToHex(SysNames[CurR], 0, true)   + ' ) Or (IDCode = ' + StringToHex(SysNames[GCuR], 0, true)    + ') Or ' +
                          ' (IDCode = ' + StringToHex(SysNames[JobSR], 0, true)  + ' ) Or (IDCode = ' + StringToHex(SysNames[ModRR], 0, true)   + ') Or ' +
                          ' (IDCode = ' + StringToHex(SysNames[EDI1R], 0, true)  + ' ) Or (IDCode = ' + StringToHex(SysNames[EDI2R], 0, true)   + ') Or ' +
                          ' (IDCode = ' + StringToHex(SysNames[EDI3R], 0, true)  + ' ) Or ' +
                          ' (IDCode = ' + StringToHex(SysNames[CuR2], 0, true)   + ' ) Or (IDCode = ' + StringToHex(SysNames[CuR3], 0, true)    + ') Or ' +
                          ' (IDCode = ' + StringToHex(SysNames[GCU2], 0, true)   + ' ) Or (IDCode = ' + StringToHex(SysNames[GCU3], 0, true)    + ') Or ' +
                          ' (IDCode = ' + StringToHex(SysNames[CstmFR], 0, true) + ' ) Or (IDCode = ' + StringToHex(SysNames[CstmFR2], 0, true) + ') Or ' +
                          ' (IDCode = ' + StringToHex(SysNames[CISR], 0, true)   + ' )';

                lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqSS.DAT', Key, True);

                // MH 19/10/2011 v6.9: Added support for copying new Custom Fields table
                If (lRes = 0) Then
                Begin
                  Key := '1=1';
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'CustomFields.DAT', Key, True);
                End; // If (lRes = 0)

                // MH 21/05/2015 v7.0.14 ABSEXCH-16284: Added support for copying new SystemSetup table
                If CopyItem[ctFlags] And (lRes = 0) Then
                Begin
                  Key := '1=1';
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'SystemSetup.DAT', Key, True);
                End; // If (lRes = 0)

                If CopyItem[ctForms] Then Begin
                  { Copy bitmaps and forms from \FORMS directory }
                  { and *.DEF, *.LST from data directory         }
//                  CopyFiles ('*.DEF', SelPath, NewComp);
//                  CopyFiles ('*.LST', SelPath, NewComp);
                  CopyFiles ('*.BMP', SelPath+'Forms\', NewComp+'Forms\');
    {$IFDEF EX600}
                  CopyFiles ('*.EFX', SelPath+'Forms\', NewComp+'Forms\');
    {$ELSE}
                  CopyFiles ('*.EFD', SelPath+'Forms\', NewComp+'Forms\');
    {$ENDIF}
                End; { If }
              End { If }
              Else
                lRes := 2006;
          End; { If }

          { IncF }
          If CopyItem[ctJob] Or CopyItem[ctStock] Then Begin

              If lRes = 0 Then Begin

                If CopyItem[ctJob] Then Begin
                  { Job Folio Number }
                  Key := 'sscounttype = ' + QuotedStr(DocNosXlate[JBF]);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqNum.DAT', Key, True)
                End; { If }

                If CopyItem[ctStock] Then Begin
                  { Stock Folio Number }
                  Key := 'sscounttype = ' + QuotedStr(DocNosXlate[SKF]);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ExchqNum.DAT', Key, True)
                End; { If }
              End { If }
              Else Begin
                lRes := 2012;
              End; { Else }
          End; { If }

          { JobF }
          If CopyItem[ctJob] Then Begin

              If lRes = 0 Then Begin
                { Job Records }
                {copy table fails passing key=''}
                Key := '1=1';
                lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'JobHead.DAT', Key, True)
              End { If }
              Else
                lRes := 2008;
          End; { If }

          { JMiscF }
          If CopyItem[ctEmpl] Or CopyItem[ctJType] Or CopyItem[ctJAnal] Then Begin
              If lRes = 0 Then Begin
                If CopyItem[ctEmpl] Then Begin
                  { Employee Records }
                  Key := ' recpfix = ' + QuotedStr(JARCode) + ' and subtype = ' + QuotedStr(JAECode);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'JobMisc.DAT', Key, True);

                  // Anonymisation Diary Entries for Employees
                  Key := ' adEntityType = 2';
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'ANONYMISATIONDIARY.DAT', Key, True);
                End; { If }

                If CopyItem[ctJType] Then Begin
                  { Job Types }
                  Key := ' recpfix = ' + QuotedStr(JARCode) + ' and subtype = ' + QuotedStr(JATCode);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'JobMisc.DAT', Key, True);
                End; { If }

                If CopyItem[ctJAnal] Then Begin
                  { Job Analysis }
                  Key := ' recpfix = ' + QuotedStr(JARCode) + ' and subtype = ' + QuotedStr(JAACode);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'JobMisc.DAT', Key, True);
                End; { If }
              End { If }
              Else
                lRes := 2009;
          End; { If }

          { JCtrlF }
          If CopyItem[ctJob] Or CopyItem[ctJBudg] Or CopyItem[ctEmpRat] Then Begin

              If lRes = 0 Then Begin
                If CopyItem[ctJob] Or CopyItem[ctJBudg] Then Begin
                  Key := ' recpfix = ' + QuotedStr(JBRCode) + ' and subtype = ' + QuotedStr(JBMCode);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'JobCtrl.DAT', Key, True)
                End; { If }

                If CopyItem[ctJBudg] Then Begin
                  { Job Budgets }
                  Key := ' recpfix = ' + QuotedStr(JBRCode) + ' and subtype = ' + QuotedStr(JBBCode);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'JobCtrl.DAT', Key, True);

                  Key := ' recpfix = ' + QuotedStr(JBRCode) + ' and subtype = ' + QuotedStr(JBSCode);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'JobCtrl.DAT', Key, True)
                End; { If }

                If CopyItem[ctEmpRat] Then Begin
                  { Employee Rates Of Pay }
                  Key := ' recpfix = ' + QuotedStr(JBRCode) + ' and subtype = ' + QuotedStr(JBECode);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'JobCtrl.DAT', Key, True);

                  Key := ' recpfix = ' + QuotedStr(JBRCode) + ' and subtype = ' + QuotedStr(JBPCode);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'JobCtrl.DAT', Key, True)
                End; { If }
              End { If }
              Else
                lRes := 2010;
          End; { If }

          { MLocF }
          If CopyItem[ctMuLoc] Or CopyItem[ctAltCodes] Or CopyItem[ctUsers] Then Begin

              If lRes = 0 Then Begin
                If CopyItem[ctMuLoc] Then Begin
                  { Locations }
                  Key := ' recpfix = ' + QuotedStr(CostCCode) + ' and subtype = ' + QuotedStr(CSubCode[False]);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'MLocStk.DAT', Key, True);

                  { Stock/Location XRef }
                  Key := ' recpfix = ' + QuotedStr(CostCCode) + ' and subtype = ' + QuotedStr(CSubCode[True]);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'MLocStk.DAT', Key, True);
                End; { If }

                If CopyItem[ctAltCodes] Then Begin
                  { Alternative Stock Codes }
                  Key := ' recpfix = ' + QuotedStr(NoteTCode) + ' and subtype = ' + QuotedStr(NoteCCode);
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'MLocStk.DAT', Key, True);
                End; { If }

                If CopyItem[ctUsers] Then Begin
                  { Alternative Stock Codes }
                  Key := ' recpfix = ' + QuotedStr(PASSUCode) + ' and subtype = ' + QuotedStr('D');
                  lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'MLocStk.DAT', Key, True);
                End; { If }
              End { If }
              Else
                lRes := 2011;
          End; { If }

          { MultiBuy Discounts }
          if CopyItem[ctMBDCust] Or CopyItem[ctMBDSupp] Or CopyItem[ctMBDStock] Then
          begin
            If lRes = 0 Then
            Begin
              If CopyItem[ctMBDCust] Then
              Begin
                { Customer Multi-Buy Discounts}
                Key := ' mbdOwnerType = ' + QuotedStr('C');
                lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'MULTIBUY.DAT', Key, True);
              end;
              If CopyItem[ctMBDSupp] Then
              Begin
                { Supplier Multi-Buy Discounts}
                Key := ' mbdOwnerType = ' + QuotedStr('S');
                lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'MULTIBUY.DAT', Key, True);
              end;
              If CopyItem[ctMBDStock] Then
              Begin
                { Stock Multi-Buy Discounts}
                Key := ' mbdOwnerType = ' + QuotedStr('T');
                lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'MULTIBUY.DAT', Key, True);
              end;
            end;
          end;

          if CopyItem[ctGlobalSortViews] Or CopyItem[ctUserSortViews] Then
          begin
            if lRes = 0 then
            begin
              if CopyItem[ctGlobalSortViews] then
              begin
                { Global Sort Views }
                Key := ' svrUserID = ' + QuotedStr('');
                lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'SORTVIEW.DAT', Key, True);
              end;
              if CopyItem[ctUserSortViews] then
              begin
                { Global Sort Views }
                Key := ' svrUserID <> ' + QuotedStr('');
                lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'SORTVIEW.DAT', Key, True);
              end;
            end;
          end;

          if CopyItem[ctUserSortViewSettings] then
          begin
            if lRes = 0 then
            begin
              if CopyItem[ctUserSortViewSettings] then
              begin
                { User Defaults }
                Key := '1=1';
                lRes := sqlutils.CopyTable(lSourceComp, lDestComp, 'SVUSRDEF.DAT', Key, True);
              end;
            end;
          end;

          //------------------------------

          // MH 16/11/2010 v6.5: Added support for new Window Positions/Colours tables
          If CopyItem[ctWinPos] Then
          Begin
            Key := '1=1';

            if lRes = 0 then
              lRes := sqlutils.CopyTable(lSourceComp, lDestComp, ColumnTableName + '.DAT', Key, True);
            if lRes = 0 then
              lRes := sqlutils.CopyTable(lSourceComp, lDestComp, ParentTableName + '.DAT', Key, True);
            if lRes = 0 then
              lRes := sqlutils.CopyTable(lSourceComp, lDestComp, WindowTableName + '.DAT', Key, True);
          End; // If CopyItem[ctWinPos]

          //------------------------------

          { Fax & Email Signatures - *.TXT * *.TX2 in DOCMASTR directory }
          If CopyItem[ctSignatures] Then Begin
            CopyFiles ('*.TXT', SelPath+'DocMastr\', NewComp+'DocMastr\');
            CopyFiles ('*.TX2', SelPath+'DocMastr\', NewComp+'DocMastr\');
          End; { If }
        end;
      Finally
        sqlutils.Unload_DLL;
      End;
    end
    else
      lRes := -1;

    Result := (lRes = 0);
  End; {Function DoTheSQLBiz : Boolean;}
  {$ENDIF}

  //-------------------------------------------------------------------------

  // MH 03/01/2018 2018-R1 ABSEXCH-19474: Added support for Anonymisation Diary
  Procedure CopyAnonymisationDiary(FileProcess : TFileProcess; Const FromPath, ToPath : ANSIString; Const EntityType : TAnonymisationDiaryEntity);
  Var
    FromFile, ToFile : TAnonymisationDiaryBtrieveFile;
    Res : Integer;
  Begin // CopyAnonymisationDiary
    // Note: As the Anonymisation Diary table isn't supported by the global btrieve file
    // arrays we need to use Btrieve File Objects to copy the data.
    FromFile := TAnonymisationDiaryBtrieveFile.Create;
    ToFile := TAnonymisationDiaryBtrieveFile.Create;
    Try
      // Open From File
      If (FromFile.OpenFile (IncludeTrailingPathDelimiter(FromPath) + AnonymisationDiaryFileName, True) = 0) Then
      Begin
        If (ToFile.OpenFile (IncludeTrailingPathDelimiter(ToPath) + AnonymisationDiaryFileName, True) = 0) Then
        Begin
          // The progress window will already be on display from copying prior records, so just re-use it
          With FileProcess.RegisterProgress Do
          Begin
            ProgMin := 0;
            ProgMax := FromFile.GetRecordCount;
            ProgPos := 0;

            Label3.Caption := AnonDiaryEntityTypeDesc[EntityType] + ' Anonymisation Diary';
            Label3.Refresh;
            Label4.Caption := '';
            Label4.Refresh;
          End; { With }

          FromFile.Index := adIdxTypeCode;
          Res := FromFile.GetGreaterThanOrEqual(FromFile.BuildTypeCodeKey(EntityType, ''));
          While (Res = 0) And (FromFile.AnonymisationDiary.adEntityType = EntityType) Do
          Begin
            With FileProcess.RegisterProgress Do
            Begin
              Label4.Caption := DoubleAmpers (Trim(FromFile.AnonymisationDiary.adEntityCode));
              ProgPos:=Succ(ProgPos);
              Label4.Refresh;
            End; // With FileProcess.RegisterProgress

            ToFile.AnonymisationDiary := FromFile.AnonymisationDiary;
            Res := ToFile.Insert;

            Res := FromFile.GetNext;
          End; // While (Res = 0) And (FromFile.AnonymisationDiary.adEntityType = EntityType)

          ToFile.CloseFile;
        End; // If (ToFile.OpenFile (IncludeTrailingPathDelimiter(ToPath) + AnonymisationDiaryFileName, True) = 0)
        FromFile.CloseFile;
      End; // If (FromFile.OpenFile (IncludeTrailingPathDelimiter(FromPath) + AnonymisationDiaryFileName, True) = 0)
    Finally
      FromFile.Free;
      ToFile.Free;
    End; // Try..Finally
  End; // CopyAnonymisationDiary

  //-------------------------------------------------------------------------

  { Controls the copying of data }
  Function DoTheBiz : Boolean;
  Var
    FileProcess : TFileProcess;
    Key         : Str255;
  Begin
    FileProcess := TFileProcess.Create;
    Try
      With FileProcess Do Begin
        SourcePath := SelPath;
        DestPath := NewComp;
      End; { With }

      { CustF }
      If CopyItem[ctCust] Or CopyItem[ctSupp] Then Begin
        With FileProcess Do Begin
          FileNum := CustF;
          KeyPath := CustCntyK;

          If StatusOk Then Begin
            { Customers }
            StartProgress;
            If CopyItem[ctCust] Then Begin
              Key := TradeCode[True];
              Process (ctCust, pmAdd, Key, 'Customer Account Details', Nil);
            End; { If }

            { Suppliers }
            If CopyItem[ctSupp] Then Begin
              Key := TradeCode[False];
              Process (ctSupp, pmAdd, Key, 'Supplier Account Details', Nil);
            End; { If }
            FinishProgress;
          End { If }
          Else
            DllStatus := 2001;
        End; { With }
      End; { If }

      { NomF }
      If CopyItem[ctNom] Then Begin
        With FileProcess Do Begin
          FileNum := NomF;
          KeyPath := NomCodeK;

          If StatusOk Then Begin
            { Nominal Control Codes - Complete File Contents - clear existing contents first }
            ClearNewFile ('General Ledger Accounts');

            StartProgress;

            Key := '';
            Process (ctNom, pmUpdate, Key, 'General Ledger Accounts', Nil);

            FinishProgress;
          End { If }
          Else
            DllStatus := 2002;
        End; { With }
      End; { If }

      { StockF }
      If CopyItem[ctStock] Then Begin
        With FileProcess Do Begin
          FileNum := StockF;
          KeyPath := StkCodeK;

          If StatusOk Then Begin
            { Stock Records - Complete File contents }
            ClearNewFile ('Stock Items');

            StartProgress;

            Key := '';
            Process (ctStock, pmAdd, Key, 'Stock Items', RecFilter);

            FinishProgress;
          End { If }
          Else
            DllStatus := 2003;
        End; { With }
      End; { If }

      { PWrdF }
      If CopyItem[ctUsers] Or CopyItem[ctCC]    Or CopyItem[ctDep] Or
         CopyItem[ctBOM]   Or CopyItem[ctCUNot] Or CopyItem[ctSUNot] Or
         CopyItem[ctStkNot] Or CopyItem[ctJobNot] Or CopyItem[ctFlags] Then Begin
        With FileProcess Do Begin
          FileNum := PWrdF;
          KeyPath := PWK;

          If StatusOk Then Begin
            { Users }
            StartProgress;
            If CopyItem[ctUsers] Then Begin
              Key := PassUCode + C0;
              Process (ctUsers, pmAdd, Key, 'User Details && Security', Nil);

              Key := PassUCode + Chr(1);
              Process (ctUsers, pmAdd, Key, 'User Details && Security', Nil);

              // MH 06/07/2015 v7.0.14 ABSEXCH-16378: Added user permissions record 2 and 3
              Key := PassUCode + Chr(2);
              Process (ctUsers, pmAdd, Key, 'User Details && Security', Nil);

              Key := PassUCode + Chr(3);
              Process (ctUsers, pmAdd, Key, 'User Details && Security', Nil);
            End; { If }

            { Cost Centres }
            If CopyItem[ctCC] Then Begin
              Key := CostCCode + CSubCode[True];
              Process (ctCC, pmAdd, Key, 'Cost Centres', Nil);
            End; { If }

            { Departments }
            If CopyItem[ctDep] Then Begin
              Key := CostCCode + CSubCode[False];
              Process (ctDep, pmAdd, Key, 'Departments', Nil);
            End; { If }

            { Bill Of Materials }
            If CopyItem[ctBOM] Then Begin
              Key := BillMatTCode + BillMatSCode;

              Process (ctBOM, pmAdd, Key, 'Bill Of Materials', Nil);
            End; { If }

            { Customer Notes }
            If CopyItem[ctCuNot] Or CopyItem[ctSuNot] Then Begin
              { Open customer / suppier file }
              Status := Open_File(F[CustF], SelPath + FileNames[CustF], 0);

              Key := NoteTCode + NoteCCode;

              If CopyItem[ctCuNot] And CopyItem[ctSuNot] Then
                { Want both - just copy the lot }
                Process (ctCuNot, pmAdd, Key, 'Customer/Supplier Account Notes', Nil)
              Else
                { Want either - need to filter }
                Process (ctCuNot, pmAdd, Key, 'Customer/Supplier Account Notes', RecFilter);

              Close_File(F[CustF]);
            End; { If }

            { Stock Notes }
            If CopyItem[ctStkNot] Then Begin
              Key := NoteTCode + NoteSCode;

              Process (ctStkNot, pmAdd, Key, 'Stock Notes', Nil);
            End; { If }

            { Job Notes }
            If CopyItem[ctJobNot] Then Begin
              Key := NoteTCode + NoteJCode;

              Process (ctJobNot, pmAdd, Key, 'Job Notes', Nil);
            End; { If }

            { Duplicate Security }
            If CopyItem[ctFlags] Then Begin
              Key := PostUCode + 'V';

              Process (ctFlags, pmUpdate, Key, '', Nil);
            End; { If }

            FinishProgress;
          End { If }
          Else
            DllStatus := 2004;
        End; { With }
      End; { If }

      { MiscF }
      If CopyItem[ctCDisc] Or CopyItem[ctSDisc] Or CopyItem[ctWinPos] Or
         CopyItem[ctCQB]   Or CopyItem[ctKQB]   Or CopyItem[ctSQB] Then Begin
        With FileProcess Do Begin
          FileNum := MiscF;
          KeyPath := MIK;

          If StatusOk Then Begin
            { Report Writer Reports - Complete File contents }
            StartProgress;

            If CopyItem[ctCDisc] Then Begin
              { Customer Discounts }
              Key := CDDiscCode + TradeCode[True];
              Process (ctCDisc, pmAdd, Key, 'Customer Discounts', Nil);
            End; { If }

            If CopyItem[ctCQB] Then Begin
              { Customer Quantity Breaks }
              Key := QBDiscCode + TradeCode[True];
              Process (ctCQB, pmAdd, Key, 'Customer Quantity Breaks', Nil);
            End; { If }

            If CopyItem[ctSDisc] Then Begin
              { Supplier Disounts }
              Key := CDDiscCode + TradeCode[False];
              Process (ctSDisc, pmAdd, Key, 'Supplier Discounts', Nil);
            End; { If }

            If CopyItem[ctSQB] Then Begin
              { Supplier Quantity Breaks }
              Key := QBDiscCode + TradeCode[False];
              Process (ctSQB, pmAdd, Key, 'Supplier Quantity Breaks', Nil);
            End; { If }

            If CopyItem[ctKQB] Then Begin
              { Stock Quantity Breaks }
              Key := QBDiscCode + QBDiscSub;
              Process (ctKQB, pmAdd, Key, 'Stock Quantity Breaks', Nil);
            End; { If }

            If CopyItem[ctWinPos] Then Begin
              { Window Colours/Positions }
              Key := btCustTCode + btCustSCode;
              Process (ctWinPos, pmAdd, Key, 'User Customisation', Nil);
            End; { If }

            FinishProgress;
          End { If }
          Else
            DllStatus := 2005;
        End; { With }
      End; { If }

      { SysF }
      If CopyItem[ctFlags] Or CopyItem[ctForms] Then Begin
        With FileProcess Do Begin
          FileNum := SysF;
          KeyPath := SysK;

          If StatusOk Then Begin
            { System Setup }
            StartProgress;

            Key := '';
            Process (ctFlags, pmUpdate, Key, 'System Setup', RecFilter);

            // MH 19/10/2011 v6.9: Added support for copying new Custom Fields table
            CopyFiles ('CustomFields.Dat', SelPath+'Misc\', NewComp+'Misc\');

            // MH 21/05/2015 v7.0.14 ABSEXCH-16284: Added support for copying new SystemSetup table
            If CopyItem[ctFlags] Then
              CopyFiles ('SystemSetup.Dat', SelPath+'Misc\', NewComp+'Misc\');

            If CopyItem[ctForms] Then Begin
              { Copy bitmaps and forms from \FORMS directory }
              { and *.DEF, *.LST from data directory         }
              CopyFiles ('*.DEF', SelPath, NewComp);
              CopyFiles ('*.LST', SelPath, NewComp);
              CopyFiles ('*.BMP', SelPath+'Forms\', NewComp+'Forms\');
{$IFDEF EX600}
              CopyFiles ('*.EFX', SelPath+'Forms\', NewComp+'Forms\');
{$ELSE}
              CopyFiles ('*.EFD', SelPath+'Forms\', NewComp+'Forms\');
{$ENDIF}
            End; { If }

            FinishProgress;
          End { If }
          Else
            DllStatus := 2006;
        End; { With }
      End; { If }

      { IncF }
      If CopyItem[ctJob] Or CopyItem[ctStock] Then Begin
        With FileProcess Do Begin
          FileNum := IncF;
          KeyPath := IncK;

          If StatusOk Then Begin
            { Report Writer Reports - Complete File contents }
            StartProgress;


            If CopyItem[ctJob] Then Begin
              { Job Folio Number }
              Key := DocNosXlate[JBF];
              Process (ctFlags, pmUpdate, Key, '', Nil);
            End; { If }

            If CopyItem[ctStock] Then Begin
              { Stock Folio Number }
              Key := DocNosXlate[SKF];
              Process (ctFlags, pmUpdate, Key, '', Nil);
            End; { If }

            FinishProgress;
          End { If }
          Else Begin
            DllStatus := 2012;
          End; { Else }
        End; { With }
      End; { If }

      { RepGenF }
      If CopyItem[ctRepWrt] Then Begin
        // HM 11/06/04: Need to re-initialise the Report File details as they are
        //              overwritten by the GroupF details during startup.  This is
        //              the only section of the MCM which references Reports.Dat so
        //              I haven't fixed the overwrite as this seemed safer.
        DefineRepGenRecs;
        With FileProcess Do Begin
          FileNum := RepGenF;
          KeyPath := RGK;

          If StatusOk Then Begin
            { Report Writer Reports - Complete File contents }
            StartProgress;

            Key := '';
            Process (ctRepWrt, pmAdd, Key, 'Report Writer Reports', Nil);

            FinishProgress;
          End { If }
          Else Begin
            DllStatus := 2007;
          End; { Else }
        End; { With }
      End; { If }

      { JobF }
      If CopyItem[ctJob] Then Begin
        With FileProcess Do Begin
          FileNum := JobF;
          KeyPath := JobCodeK;

          If StatusOk Then Begin
            { Job Records }
            StartProgress;

            Key := '';
            Process (ctJob, pmAdd, Key, 'Job Records', RecFilter);

            FinishProgress;
          End { If }
          Else
            DllStatus := 2008;
        End; { With }
      End; { If }

      { JMiscF }
      If CopyItem[ctEmpl] Or CopyItem[ctJType] Or CopyItem[ctJAnal] Then Begin
        With FileProcess Do Begin
          FileNum := JMiscF;
          KeyPath := JMK;

          If StatusOk Then Begin
            StartProgress;

            If CopyItem[ctEmpl] Then Begin
              { Employee Records }
              Key := JARCode + JAECode;
              Process (ctEmpl, pmAdd, Key, 'Employee Records', Nil);
            End; { If }

            If CopyItem[ctJType] Then Begin
              { Job Types }
              Key := JARCode + JATCode;
              Process (ctJType, pmAdd, Key, 'Job Types', Nil);
            End; { If }

            If CopyItem[ctJAnal] Then Begin
              { Job Analysis }
              Key := JARCode + JAACode;
              Process (ctJAnal, pmAdd, Key, 'Job Analysis', Nil);
            End; { If }

            FinishProgress;
          End { If }
          Else
            DllStatus := 2009;
        End; { With }
      End; { If }

      { JCtrlF }
      If CopyItem[ctJob] Or CopyItem[ctJBudg] Or CopyItem[ctEmpRat] Then Begin
        With FileProcess Do Begin
          FileNum := JCtrlF;
          KeyPath := JCK;

          If StatusOk Then Begin
            StartProgress;

            If CopyItem[ctJob] Or CopyItem[ctJBudg] Then Begin
              { Job Totals - HM 15/05/00: Moved from Job Budgets only section on EL's advise }
              Key := JBRCode + JBMCode;
              Process (ctJBudg, pmAdd, Key, 'Job Budgets', RecFilter);
            End; { If }

            If CopyItem[ctJBudg] Then Begin
              { Job Budgets }
              Key := JBRCode + JBBCode;
              Process (ctJBudg, pmAdd, Key, 'Job Budgets', RecFilter);

              {Key := JBRCode + JBMCode;
              Process (ctJBudg, pmAdd, Key, 'Job Budgets', Nil);}

              Key := JBRCode + JBSCode;
              Process (ctJBudg, pmAdd, Key, 'Job Budgets', RecFilter);
            End; { If }

            If CopyItem[ctEmpRat] Then Begin
              { Employee Rates Of Pay }
              Key := JBRCode + JBECode;
              Process (ctEmpRat, pmAdd, Key, 'Employee Rates Of Pay', Nil);

              Key := JBRCode + JBPCode;
              Process (ctEmpRat, pmAdd, Key, 'Employee Rates Of Pay', Nil);
              //FileList ('c:\mh.txt');
            End; { If }

            FinishProgress;
          End { If }
          Else
            DllStatus := 2010;
        End; { With }
      End; { If }

      { MLocF }
      If CopyItem[ctMuLoc] Or CopyItem[ctAltCodes] Or CopyItem[ctUsers] Then Begin
        With FileProcess Do Begin
          FileNum := MLocF;
          KeyPath := MLK;

          If StatusOk Then Begin
            StartProgress;

            If CopyItem[ctMuLoc] Then Begin
              { Locations }
              Key := CostCCode + CSubCode[False];
              Process (ctMuLoc, pmAdd, Key, 'Location', Nil);

              { Stock/Location XRef }
              Key := CostCCode + CSubCode[True];
              Process (ctMuLoc, pmAdd, Key, 'Stock/Location XRef', Nil);
            End; { If }

            If CopyItem[ctAltCodes] Then Begin
              { Alternative Stock Codes }
              Key := NoteTCode + NoteCCode;
              Process (ctAltCodes, pmAdd, Key, 'Alternative Stock Codes', Nil);
            End; { If }

            If CopyItem[ctUsers] Then Begin
              { Alternative Stock Codes }
              Key := PASSUCode + 'D';
              Process (ctUsers, pmAdd, Key, 'User Profiles', Nil);
            End; { If }

            FinishProgress;
          End { If }
          Else
            DllStatus := 2011;
        End; { With }
      End; { If }

      { MultiBuy Discounts }
      If CopyItem[ctMBDCust] Or CopyItem[ctMBDSupp] Or CopyItem[ctMBDStock] Then
      Begin
        With FileProcess Do Begin
          FileNum := MultiBuyF;
          KeyPath := mbdAcCodeK;

          If StatusOk Then Begin
            StartProgress;

            If CopyItem[ctMBDCust] Then
            Begin
              { Customer Multi-Buy Discounts }
              Key := '';
              Process (ctMBDCust, pmAdd, Key, 'Customer Multi-Buy Discounts', RecFilter);
            End; { If }

            If CopyItem[ctMBDSupp] Then
            Begin
              { Customer Multi-Buy Discounts }
              Key := '';
              Process (ctMBDSupp, pmAdd, Key, 'Supplier Multi-Buy Discounts', RecFilter);
            End; { If }

            If CopyItem[ctMBDStock] Then
            Begin
              { Customer Multi-Buy Discounts }
              Key := '';
              Process (ctMBDStock, pmAdd, Key, 'Stock Multi-Buy Discounts', RecFilter);
            End; { If }

            FinishProgress;
          End { If }
          Else
            DllStatus := 2013;
        End; { With }
      End; { If }

      // MH 11/05/2009: Added support for Sort Views
      If CopyItem[ctGlobalSortViews] Or CopyItem[ctUserSortViews] Then
      Begin
        With FileProcess Do Begin
          FileNum := SortViewF;
          KeyPath := SVViewK;

          If StatusOk Then Begin
            StartProgress;

            If CopyItem[ctGlobalSortViews] Then
            Begin
              { Global Sort Views }
              Key := '';
              Process (ctGlobalSortViews, pmAdd, Key, 'Global Sort Views', RecFilter);
            End; { If }

            If CopyItem[ctUserSortViews] Then
            Begin
              { User Sort Views }
              Key := '';
              Process (ctUserSortViews, pmAdd, Key, 'User Sort Views', RecFilter);
            End; { If }

            FinishProgress;
          End { If }
          Else
            DllStatus := 2014;
        End; { With }
      End; { If }

      //------------------------------

      If CopyItem[ctUserSortViewSettings] Then
      Begin
        With FileProcess Do Begin
          FileNum := SVUDefaultF;
          KeyPath := SVUserK;

          If StatusOk Then Begin
            StartProgress;

            { User Sort View Settings }
            Key := '';
            Process (ctUserSortViewSettings, pmAdd, Key, 'User Sort View Settings', NIL);

            FinishProgress;
          End { If }
          Else
            DllStatus := 2015;
        End; { With }
      End; { If }

      //------------------------------

      // MH 16/11/2010 v6.5: Added support for new Window Positions/Colours tables
      If CopyItem[ctWinPos] Then
      Begin
        // As new tables aren't in EL's global arrays we will re-purpose the SortView element of the global arrays

        // Column Settings -----------------------------------------
        GetMem(ColSettings, SizeOf(ColSettings^));
        Try
          FileNames[SortViewF] := ColumnFileName;
          RecPtr[SortViewF] := @ColSettings^;
          FileRecLen[SortViewF] := SizeOf(ColSettings^);

          With FileProcess Do
          Begin
            FileNum := SortViewF;
            KeyPath := 0;

            If StatusOk Then
            Begin
              Key := '';
              StartProgress;
              Process (ctUserColumnSettings, pmAdd, Key, 'User Column Settings', NIL);
              FinishProgress;
            End { If }
            Else
              DllStatus := 2016;
          End; { With }
        Finally
          FreeMem(ColSettings);
        End; // Try..Finally

        // Column Settings -----------------------------------------
        GetMem(ParSettings, SizeOf(ParSettings^));
        Try
          FileNames[SortViewF] := ParentFileName;
          RecPtr[SortViewF] := @ParSettings^;
          FileRecLen[SortViewF] := SizeOf(ParSettings^);

          With FileProcess Do
          Begin
            FileNum := SortViewF;
            KeyPath := 0;

            If StatusOk Then
            Begin
              Key := '';
              StartProgress;
              Process (ctUserParentSettings, pmAdd, Key, 'User Parent Settings', NIL);
              FinishProgress;
            End { If }
            Else
              DllStatus := 2017;
          End; { With }
        Finally
          FreeMem(ParSettings);
        End; // Try..Finally

        // Column Settings -----------------------------------------
        GetMem(WinSettings, SizeOf(WinSettings^));
        Try
          FileNames[SortViewF] := WindowFileName;
          RecPtr[SortViewF] := @WinSettings^;
          FileRecLen[SortViewF] := SizeOf(WinSettings^);

          With FileProcess Do
          Begin
            FileNum := SortViewF;
            KeyPath := 0;

            If StatusOk Then
            Begin
              Key := '';
              StartProgress;
              Process (ctUserWindowSettings, pmAdd, Key, 'User Window Settings', NIL);
              FinishProgress;
            End { If }
            Else
              DllStatus := 2017;
          End; { With }
        Finally
          FreeMem(WinSettings);
        End; // Try..Finally
      End; // If CopyItem[ctWinPos]

      //------------------------------

      // MH 03/01/2018 2018-R1 ABSEXCH-19474: Added support for Anonymisation Diary
      If CopyItem[ctCust] Then
        CopyAnonymisationDiary(FileProcess, SelPath, NewComp, adeCustomer);
      If CopyItem[ctSupp] Then
        CopyAnonymisationDiary(FileProcess, SelPath, NewComp, adeSupplier);
      If CopyItem[ctEmpl] Then
        CopyAnonymisationDiary(FileProcess, SelPath, NewComp, adeEmployee);

      //------------------------------

      { Fax & Email Signatures - *.TXT * *.TX2 in DOCMASTR directory }
      If CopyItem[ctSignatures] Then Begin
        CopyFiles ('*.TXT', SelPath+'DocMastr\', NewComp+'DocMastr\');
        CopyFiles ('*.TX2', SelPath+'DocMastr\', NewComp+'DocMastr\');
      End; { If }
    Finally
      FileProcess.Free;
    End;

    Result := (DllStatus = 0);
  End;

  //------------------------------

  Function DiskSpaceOk : Boolean;
  Var
    TotalSpace, FreeSpace : Double;
    fDriveNo              : Smallint;
    SpaceReq              : LongInt;

    { returns the space used by the specified files }
    Function FileSpace (FName : ShortString) : LongInt;
    Var
      SPath, DPath : PChar;
      FileInfo     : TSearchRec;
      FStatus      : SmallInt;
    Begin
      Result := 0;
      FName := SelPath + FName;

      FStatus := FindFirst(FName, faReadOnly, FileInfo);

      While (FStatus = 0) Do Begin
        If (FileInfo.Name <> '.') And (FileInfo.Name <> '..') Then
          Result := Result + FileInfo.Size;

        FStatus := FindNext(FileInfo);
      End; { While }

      SysUtils.FindClose (FileInfo);
    End;

  Begin
    TotalSpace := 0;

    { Calculate required disk space }
    If CopyItem[ctCust] Or CopyItem[ctSupp] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[CustF]);

    If CopyItem[ctNom] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[NomF]);

    If CopyItem[ctStock] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[StockF]);

    If CopyItem[ctUsers] Or CopyItem[ctCC]    Or CopyItem[ctDep] Or
       CopyItem[ctBOM]   Or CopyItem[ctCUNot] Or CopyItem[ctSUNot] Or
       CopyItem[ctStkNot] Or CopyItem[ctJobNot] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[PwrdF]);

    If CopyItem[ctCDisc] Or CopyItem[ctSDisc] Or CopyItem[ctWinPos] Or
       CopyItem[ctCQB]   Or CopyItem[ctKQB]   Or CopyItem[ctSQB] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[MiscF]);

    If CopyItem[ctFlags] Or CopyItem[ctForms] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[SysF]);

    If CopyItem[ctMBDCust] Or CopyItem[ctMBDSupp] Or CopyItem[ctMBDStock] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[MultiBuyF]);

    // MH 11/05/2009: Added support for Sort Views
    If CopyItem[ctGlobalSortViews] Or CopyItem[ctUserSortViews] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[SortViewF]);
    If CopyItem[ctUserSortViewSettings] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[SVUDefaultF]);

    If CopyItem[ctForms] Then Begin
{$IFDEF EX600}
      TotalSpace := TotalSpace + FileSpace('*.DEF') +
                                 FileSpace('*.LST') +
                                 FileSpace('Forms\*.BMP') +
                                 FileSpace('Forms\*.EFD') +
                                 FileSpace('Forms\*.EFX');
{$ELSE}
      TotalSpace := TotalSpace + FileSpace('*.DEF') +
                                 FileSpace('*.LST') +
                                 FileSpace('Forms\*.BMP') +
                                 FileSpace('Forms\*.EFD');
{$ENDIF}
    End; { If }

    If CopyItem[ctRepWrt] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[RepGenF]);

    If CopyItem[ctJob] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[JobF]);

    If CopyItem[ctEmpl] Or CopyItem[ctJType] Or CopyItem[ctJAnal] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[JMiscF]);

    If CopyItem[ctJBudg] Or CopyItem[ctEmpRat] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[JCtrlF]);

    If CopyItem[ctMuLoc] Then
      TotalSpace := TotalSpace + FileSpace(FileNames[MLocF]);

    { Calculate drive number }
    fDriveNo:=Ord(UPCase(NewComp[1]))-64;

    { get free space on drive }
    FreeSpace := sbsDiskFree(fDriveNo);

    { Check it }
    Result := (FreeSpace > TotalSpace) Or (FreeSpace <= 0);

    If (Not Result) Then Begin
      { Not enough disk space }
      SpaceReq := Trunc(TotalSpace-FreeSpace) Div 1024;
      Result := (MessageDlg ('There is not enough disk space free to install the ' +
                             'files in the drive you specified. Another ' + IntToStr(SpaceReq) + 'k is required.' +
                             #10#13#10#13 +
                             'Do you want to continue anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes);
    End; { If }
  End;

Begin
  DllStatus := 0;

  { Get path of help file }
  //Application.HelpFile := MainComp + 'ENTREAD.HLP';

  If Check4BtrvOk Then Begin
{$IFDEF EXSQL}
    if SQLUtils.ValidSystem(MainComp) then
{$ELSE}
    If FileExists (MainComp + MultCompNam) Then
{$ENDIF}
    Begin
      //showmessage('open file');
      
      { Open company database }
      Status := Open_File(F[CompF], MainComp + FileNames[CompF], 0);
      If StatusOk Then Begin
        Try
          CopyDataWiz1 := Nil;
          CopyDataWiz2 := Nil;

          WizId := 1;
          WantCopy := False;

          JBCostOn := EnterpriseLicence.elModules[modJobCost] <> mrNone;
//          JBCostOn := FileExists (MainComp + JBCostName^);
          RepWrtOn :=  EnterpriseLicence.elModules[modRepWrt] <> mrNone;
//          RepWrtOn := FileExists (MainComp + Path5 + RepRepNam) And
//                      FileExists (NewComp + Path5 + RepRepNam);

          FillChar (CopyItem, SizeOf (CopyItem), #0);

          Repeat
            Case WizId Of
              1 : Begin
                    If Not Assigned(CopyDataWiz1) Then
                    Begin
                      // MH 06/02/2008: Added separate LoadCompanies function to allow the current
                      //                company to be removed from the list under SQL
                      CopyDataWiz1 := TCopyDataWiz1.Create (Application);
                      CopyDataWiz1.LoadCompanies(Trim(UpperCase(NewComp)));
                    End; // If Not Assigned(CopyDataWiz1)

                    If DllStatusOk Then Begin
                      CopyDataWiz1.ShowModal;

                      ExCode := CopyDataWiz1.ExitCode;

                      If (ExCode = 'N') Then Begin
                        WantCopy := CopyDataWiz1.WantCopy;

                        { Get path of selected company }
                        SelPath := CopyDataWiz1.CompanyPath;
{$IFNDEF EXSQL}
                        If RepWrtOn Then
                          RepWrtOn := FileExists (SelPath + Path5 + RepRepNam);
{$ENDIF}                          
                      End; { If }
                    End; { If }
                  End;

              2 : If WantCopy Then Begin
                    If Not Assigned(CopyDataWiz2) Then
                      CopyDataWiz2 := TCopyDataWiz2.Create (Application);

                    CopyDataWiz2.CopyMode := TCopyMode(CopyMode);
                    CopyDataWiz2.SourceCompany := CopyDataWiz1.CompanyCode + ' - ' + CopyDataWiz1.CompanyName;

                    CopyDataWiz2.ShowModal;

                    ExCode := CopyDataWiz2.ExitCode;

                    If (ExCode = 'N') Then
                      ExCode := DoneCode
                  End { If }
                  Else
                    { Finish wizard as we don't want to copy any data }
                    ExCode := DoneCode;
            Else
              WizId := 1;
            End; { Case }

            Case ExCode Of
              'B' : Dec (WizId);
              'N' : Inc (WizId);
            End; { Case }
          Until (ExCode In [DoneCode, 'X']);

          If (ExCode <> DoneCode) Then
            DllStatus := 1001 { Exit Installation }
          Else
            If DllStatusOk And WantCopy Then Begin
              { Copy flags into local variables so forms can be freed }
              If Assigned(CopyDataWiz2) Then
                With CopyDataWiz2 Do Begin
                  { Accounts }
                  CopyItem[ctCust] := Chk_Cust.Checked;
                  CopyItem[ctCuNot] := Chk_CustNote.Checked;
                  CopyItem[ctSupp] := Chk_Supp.Checked;
                  CopyItem[ctSuNot] := Chk_SuppNote.Checked;

                  { Job Costing }
                  CopyItem[ctJob] := Chk_Job.Checked;
                  CopyItem[ctJobNot] := CopyItem[ctJob];
                  CopyItem[ctJBudg] := Chk_JobBudg.Checked;
                  CopyItem[ctJAnal] := Chk_JobAnal.Checked;
                  CopyItem[ctJType] := Chk_JobType.Checked;
                  CopyItem[ctEmpl] := Chk_Empl.Checked;
                  CopyItem[ctEmpRat] := Chk_EmplRate.Checked;

                  { Misc }
                  CopyItem[ctNom] := Chk_Nom.Checked;
                  CopyItem[ctCC] := Chk_CCDep.Checked;
                  CopyItem[ctDep] := CopyItem[ctCC];
                  CopyItem[ctCDisc] := Chk_Disc.Checked;      { Cust Discs }
                  CopyItem[ctSDisc] := CopyItem[ctCDisc];     { Supp Discs }
                  CopyItem[ctCQB] := CopyItem[ctCDisc];     { Cust Qty Discs }
                  CopyItem[ctKQB] := CopyItem[ctCDisc];     { Stock Qty Discs }
                  CopyItem[ctSQB] := CopyItem[ctCDisc];     { Supp Qty Discs }
                  CopyItem[ctRepWrt] := Chk_RepWrt.Checked And Chk_RepWrt.Visible;

                  { Setup }
                  CopyItem[ctFlags] := Chk_Flags.Checked;
                  CopyItem[ctForms] := Chk_Forms.Checked;
                  CopyItem[ctUsers] := Chk_Users.Checked;
                  CopyItem[ctWinPos] := Chk_UsWinPos.Checked;
                  CopyItem[ctSignatures] := chkSignatures.Checked;

                  { Stock }
                  CopyItem[ctStock] := Chk_Stock.Checked;
                  CopyItem[ctBOM] := CopyItem[ctStock];
                  CopyItem[ctStkNot] := Chk_StkNotes.Checked;
                  CopyItem[ctMuLoc] := Chk_MLStock.Checked;
                  CopyItem[ctAltCodes] := Chk_AltCodes.Checked;

                  { MultiBuy Discounts }
                  CopyItem[ctMBDCust]  := Chk_Cust.Checked And Chk_Stock.Checked And Chk_Disc.Checked;
                  CopyItem[ctMBDSupp]  := Chk_Supp.Checked And Chk_Stock.Checked And Chk_Disc.Checked;
                  CopyItem[ctMBDStock] := Chk_Stock.Checked And Chk_Disc.Checked;

                  // MH 11/05/2009: Added support for Sort Views
                  CopyItem[ctGlobalSortViews] := Chk_SortView.Checked;
                  CopyItem[ctUserSortViews] := Chk_SortView.Checked And Chk_Users.Checked;
                  CopyItem[ctUserSortViewSettings] := Chk_SortView.Checked And Chk_Users.Checked;
                End; { With }
            End; { If }
        Finally
          { De-Allocate any forms which were created }
          If Assigned(CopyDataWiz1) Then CopyDataWiz1.Free;
          If Assigned(CopyDataWiz2) Then CopyDataWiz2.Free;
        End;

        If DllStatusOk And WantCopy Then Begin
          { Check disk space }
          If DiskSpaceOk Then Begin
          {$IFDEF EXSQL}
            if IsSQL then
            begin
              if not DoTheSQLBiz(MainComp) then
                DllStatus := 1;
            end
            else If Not DoTheBiz Then
                DllStatus := 1;
          {$ELSE}
            If Not DoTheBiz Then
              DllStatus := 1;
          {$ENDIF}
          End { If }
          Else
            DllStatus := 2;
        End; { If }
      End { If }
      Else
        DllStatus := Status;
    End { If }
    Else
      { Error: Company.Dat not found }
      DllStatus := 1;

    { Stop Btrieve }
    Stop_B;
  End; { If }
End;

Initialization
  DefineMultiBuyDiscounts;
  DefineSortView;
  DefineSortViewDefault;
end.
