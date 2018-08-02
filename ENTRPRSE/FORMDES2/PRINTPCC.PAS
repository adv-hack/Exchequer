unit PrintPCC;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPrinter, RPCanvas, RPFPrint, RPDefine, RPBase, RPFiler, GlobType,
  GlobVar, VarConst, Scrtch1U, ExWrap1U, RpDevice, TEditVal, PCCToEFP,
  ScratchF, ScratchO, VarRec2U;

type
  ENoUnique = Class (Exception);

  RepDestType = (rdPrinter, rdPrintFile, rdPreview);

  PEFxsREC = Record
    Codes  :  Array[1..25,FALSE..TRUE] of Str10;
    OnOff  :  Array[1..25] of Boolean;
  End; { PEFxsREC }

  TForm_PrintPCC = class(TForm)
    ReportPrinter1: TReportPrinter;
    FilePrinter1: TFilePrinter;
    procedure Batch_Print(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PrintFile(Sender: TObject);
  private
    { Private declarations }
    PrnF             : TFileStream; {TextFile;}
    RepFName         : ShortString;         { Filename of .SWP file }
    PageList         : TList;
    RepType          : RepTypeType;
    TestMode         : Boolean;
    RepDest          : RepDestType;
    PageNo, JobIdx   : Word;
    CurrJob          : TPrintBatchObjType;
    RemitDoc         : String10;
    PEFxs            : PEFxsRec;
    ExLocal          : TdExLocal;
    FormName         : ShortString;
    DrivingFile      : Integer;
    FormPurpose      : Byte;     { Type of report: required for calling Link_Dict }
    PrintLine,
    AbortForm, AbortBatch : Boolean;
    Copies, MPage, TotItems : SmallInt;
    StrRec           : fdFormStringsTypePtr;
    OutMethod        : Byte;     { 0=Printer, 1=Fax, 2=Email }

    PL,PO,
    CurrILineNo,
    NoILinesPed,
    MT
               :    Integer;
    FF,CP,RL,
    ER,FirstGo,
    RFOK,Ok2Prnt,
    InIFSta
               :    Boolean;

    DKeyLen    :    Byte;

    { Document Print Order flags }
    PMMode : Boolean;
    PMType : SmallInt;

    { Serial Number setup flags }
    SNMode           : Boolean;
    SNBatch, SNWidth : SmallInt;

    // HM 09/09/03: Modified for Multi-Bin Support
    BinMode          : Boolean;
    UseByMode        : Boolean;
    StkPrioMode      : Boolean;

    // HM 14/01/04: Rewrote to optionally include additional description lines within the picking list
    PickListDescLines : Boolean;

    // MH 04/09/06: IAO/v5.71 - Added additional flags for picking lists
    PickListShowDescOnly : Boolean;  // Include non-stock/description only lines in single picking lists
    PickListInclNewLines : Boolean;  // Include TL's with 0 Picking Run Number

    // HM 04/11/04: Added 'Set Printed Status' flag so that Authoris-e can stop FDes from setting the Printed Status on transactions
    bSetPrintedStatus : Boolean;

    // MH 16/03/2009: Added support for printing Hidden BoM Lines in Single Picking Lists
    PickListShowBoM : Boolean;

    { Fax Font info }
    JobInfo      : TJobInfo;

    Procedure AddPageRef(BefPBrk, AftPBrk : LongInt);
    Procedure AdjustMain;
    Procedure AdjustTable;
    Procedure Batch_KillScratchObj;
    Procedure Consol_Pick(    Mode, Fnum, Keypath : Integer;
                          Var KeyS                : Str255);
    Procedure DoCcyConvFunc (Var NamLn, Field : Str255; Var Justify : Str80; Const FLen : Byte);
    Procedure DoCcyAgeingFunc (Var NamLn, Field : Str255; Var Justify : Str80; Const FLen : Byte);
    Procedure DoSubstringFunc (Var NamLn, Field : Str255; Var Justify : Str80; Const FLen : Byte);
    Procedure EOP(LineNo,Page  :  Integer);
    Function  GetNextLine(    Mode       :  Byte;
                              Fnum,
                              Keypath    :  Integer;
                              KeyRef     :  Str255;
                          Var sSearchKey : Str255) : Boolean;
    Function  GetField(Flen  :  Byte)  :  Str255;
    Function  GetFieldText (Const ShortCode : String10;
                                  TheDecs   : SmallInt;
                            Var   Justify   : ShortString;
                            Const FieldLen  : SmallInt) : ResultValueType;
    Function  GetNoteField(Const NoteField : String) : Str255;
    Function  Include(Mode : Byte) : Boolean;
    Function  OverRideJustfy(NamLn, GField : Str255) : Str255;
    Procedure Preview(Const PrnInfo  : TSBSPrintSetupInfo);
    procedure PrintAbort (var Msg: TMessage); message WM_PrintAbort;
    Procedure PrintData(Value: string;PageBreak:Boolean);
    Procedure PrintErrorPage (Const PageErr : Integer);
    Procedure ProcessPFx(    ProcessCh : Char;
                         Var CurrPos   : Byte);
    Procedure ProcessDot(Var CurrPos : Byte;
                             TextLn  : Str255;
                             LineLn  : Byte);
    Procedure ProcessField(Var CurrPos : Byte;
                               TextLn  : Str255;
                               LineLn  : Byte);
    Procedure Process_File(Mode          : Byte;
                           Fnum,KeyPAth  : Integer;
                           KeyRef        : Str255;
                           LastOne       : Boolean);
    Procedure ProcessIf(Var FieldNam : Str80;
                            TextLn   : Str255);
    Procedure ProcessLn(TextLn : Str255);
    Procedure SendProgress (Const CurrItem : SmallInt;Const Mode : Byte);
    function  SetDCheckKey : Str255;
    Procedure SetEffects;
    Procedure SetEscSec(EscSet  :  Str255);
    Procedure SetMT;
    Procedure SetPage(Var LineNo, Page : SmallInt);
    Procedure SetPrintedStatus;
  public
    { Public declarations }
    ScratchO       : ScratchPtr;
    DEFFile,
    NAMFile        : TextFile;
    ScratchFile    : TScratchFile;

    Procedure InitPrintType (Const ReportType  : RepTypeType;
                             Const PrinterNo   : Integer;
                             Const WantPreview : Boolean;
                             Const WantCopies  : SmallInt;
                             Const IsTestMode  : Boolean;
                             Const ChequeMode  : Boolean;
                             Const PrnInfo     : TSBSPrintSetupInfo);
    Procedure PrintReport (Const WinTitle : ShortString;
                                 PrnInfo  : TSBSPrintSetupInfo);
  end;




implementation

Uses DataDict, DicLinkU, DicLnk2U, PrintU, ETMiscU, ETDateU, ETStrU, SerialNo,
     CurrncyU, BtKeys1U, ComnU2, NoteSupU, InvListU, DocSupU1, SysU1, SysU2,
     ComnUnit, {DebugWin, }PCCUtils, PrnCodes, EPrntDef, PrntForm, PrntPrev,
     BTSupU1, BtrvU2, FormFile, PrevPCC, FormUtil, DocSort, IIFFuncs,
     EntLicence, PickListUtil, CustomFieldsIntf,
     // MH 19/09/2014 Order Payments: Added support for printing VAT Receipts
     oOPVATPayBtrieveFile, OPVATPaySingleton;

{$R *.DFM}

Const
  { ============ Print Definition Extensions ============ }
  DefExt          = '.DEF';
  NamExt          = '.LST';

  { ========= Char Triggers ======== }
  FldChr     =    '_';
  DotChr     =    '@';
  SpeChr     =    '.';
  VarChr     =    '&';
  EscDel     =    '#';

  RJChar     =    'R';  {Right Justify Trigger}
  LJChar     =    'L';  {Left     "       "   }
  NJChar     =    'N';  {No       "       "   }
  CJChar     =    'C';  {Center   "       "   }
  XJChar     =    'X';  {Leave alone      "  !}
  // HM 18/03/03: 'K' used in DoSubstringFunc to remove comma's

  JJSet      =    ['X','R','L','N','C','B'];

  { ========= Dot Equiv ======== }
  PLDc       =    'PL';
  PODc       =    'PO';
  MTDc       =    'MT';
  FFDc       =    'FF';
  RLDc       =    'RL';
  ERDc       =    'ER';
  ESDc       =    'ES';
  CPDc       =    'CP';  {If List Line Blank do Not Print}
  LADc       =    'LA';  {No Labels Across}
  SVDc       =    'SV';  {Define User def variable}
  SNDc       =    'SN';  {Set to Multiple Serial no mode}
  PMDc       =    'PM';  {Set to multiple Line order mode}
  IFDc       =    'IF';
  ELDc       =    'ELSE';
  EFDc       =    'ENDIF';

  FaxFont    =    'FXFNT'; { Name of Font for faxing PCC forms }
  FaxFontSz  =    'FXSIZ'; { Size of Font for faxing PCC forms }

  BinDc      =    'BIN';   // HM 09/09/03: Added Multi-Bin support to Picking Lists

  // HM 14/01/04: Rewrote to optionally include additional description lines within the picking list
  DescDc     =    'DESC';

  // MH 04/09/06: IAO/v5.71 - Added additional flags for picking lists
  DescOnlyDC = 'DESCONLY';  // Include non-stock/description only lines in single picking lists
  ShowNew    = 'INCLNEW';   // Include TL's with 0 Picking Run Number

  // MH 16/03/2009: v6.01  - Added support for printing hidden BoM lines
  ShowHidBom = 'SHOWBOM';

  { ========== Var Id Prefix ========== }

  RecPfx     =   'R';
  StaPfx     =   'S';
  QuoPfx     =   'Q';
  LabPFx     =   'L';
  StkPFx     =   'K';
  NtePFx     =   'N';
  JobPFx     =   'J';


  { ========== Misc Consts ========== }

  NumPfx     =   'N';

  EfxSet     =   [^A..^Z];

  { ========== Comparison Values ========== }

  EqStr      =  '=';
  NotEqStr   =  '<>';
  GTStr      =  '>';
  LTStr      =  '<';


procedure TForm_PrintPCC.FormCreate(Sender: TObject);
begin
  // HM 04/11/04: Added 'Set Printed Status' flag so that Authoris-e can stop
  // FDes from setting the Printed Status on transactions, default to setting it
  bSetPrintedStatus := True;

  ExLocal.Create;

  PageList := TList.Create;
  New(StrRec);
end;


procedure TForm_PrintPCC.FormDestroy(Sender: TObject);
begin
  Dispose(StrRec);
  PageList.Free;
  ExLocal.Destroy;
end;


Procedure TForm_PrintPCC.InitPrintType (Const ReportType  : RepTypeType;
                                        Const PrinterNo   : Integer;
                                        Const WantPreview : Boolean;
                                        Const WantCopies  : SmallInt;
                                        Const IsTestMode  : Boolean;
                                        Const ChequeMode  : Boolean;
                                        Const PrnInfo     : TSBSPrintSetupInfo);
Var
  I                    : Integer;
begin
  RepType := ReportType;
  TestMode := IsTestMode;
  InChequeMode := ChequeMode;

  OutMethod := PrnInfo.fePrintMethod;

  // HM 04/11/04: Added 'Set Printed Status' flag so that Authoris-e can stop
  // FDes from setting the Printed Status on transactions, default to setting it
  bSetPrintedStatus := Not PrnInfo.feDisablePrnStatus;

  If (OutMethod = 0) Then Begin
    { Printer }
    Copies  := WantCopies;
    If (Copies < 1) Then Copies := 1;
    If (Copies > 99) Then Copies := 99;

    If (RepType <> GlobType.rtNone) Then Begin
      { Decide whether printing to printer or previewing }
      If WantPreview Then
        RepDest := rdPreview
      Else
        If (Copies > 1) Then
          RepDest := rdPrintFile
        Else
          RepDest := rdPrinter;
    End; { If }
  End { If }
  Else Begin
    { Fax / Email }
    Copies := 1;

    { Email/Faxing - always print to file first, so the number of pages can be printed }
    If WantPreview Then
      RepDest := rdPreview
    Else
      RepDest := rdPrintFile;
  End; { Else }
end;


Procedure TForm_PrintPCC.PrintReport (Const WinTitle : ShortString;
                                            PrnInfo  : TSBSPrintSetupInfo);
Var
  Msg               : String;
  PrevCur           : TCursor;
  FVar, PreviewMode : Integer;
  I                 : SmallInt;
  Locked            : Boolean;
  oOnPrint          : TNotifyEvent;
  BaseDir           : ShortString;
begin
  Try
    If (RepType <> GlobType.rtNone) Then Begin
      { Generate Unique Filename for text file }
      If (RepDest In [rdPrintFile, rdPreview]) Then Begin
        FVar := 0;
        GetTempFilePath (BaseDir);
        Repeat
          RepFName := BaseDir + '!REP' + IntToStr(FVar) + '.SWP';
          Inc (FVar);
        Until (Not FileExists (RepFName)) Or (FVar > 9999);
        If (FVar > 9999) Then
          Raise ENoUnique.Create('Cannot Find Unique Filename');

        { Open Text File for writing }
        PrnF := TFileStream.Create(RepFName, (fmCreate Or fmOpenWrite Or fmShareExclusive));
      End; { If }

      { Set Print Job Information for data dictionary }
      PrintJobInfo^ := PrnInfo;

      { Update System records, Switches & VAT }
      Locked := False; GetMultiSys(BOff, Locked, VATR);
      Locked := False; GetMultiSys(BOff, Locked, SysR);
      { HM 28/09/99: Modified for increased currency table }
      //Locked := False; GetMultiSys(True, Locked, CurR);
      //Locked := False; GetMultiSys(True, Locked, GCUR);
      Locked := False; GetMultiSysCur(True, Locked);
      Locked := False; GetMultiSysGCur(True, Locked);

      { Clear out any existing page info }
      While (PageList.Count > 0) Do Begin
        TPageRef(PageList[0]).Free;
        PageList.Delete(0);
      End; { While }

      { Init the print stuff }
      PageNo := 0;

      If (RepDest = rdPrinter) Then Begin
        { Print to Printer }
        ReportPrinter1.Title := PrnInfo.feJobtitle;
        ReportPrinter1.Execute;
      End { If }
      Else Begin
        { Preview or multiple copies - Print to .SWP file as text }
        Batch_Print(Self);
      End; { Else }

      If (PrnInfo.fePrintMethod = 2) Then
        PrnInfo.feEmailFName := PrintJobInfo^.feEmailFName;

      If AbortBatch And (RepDest In [rdPrintFile, rdPreview]) Then Begin
        { check that they want to see it if they aborted }
        AbortBatch := (MessageDlg ('Do you want to print the processed part of batch',
                                   mtConfirmation, [mbYes, mbNo], 0) = mrYes);
      End; { If }

      // HM 08/10/02: Form Printing Toolkit requirements very different - added IfDef
      //              to allow it to be completely separate so that I don't accidentally
      //              break the normal system
      {$IFNDEF FORMTK}
        If (RepDest In [rdPrintFile, rdPreview]) Then Begin
          { Close Text File }
          PrnF.Free;

          If (Not AbortBatch) Then Begin
            Case RepDest Of
              rdPrintFile : Begin { Print Multiple Copies to Printer }
                              If (OutMethod = 0) Then Begin
                                { Printer - Print copies }
                                ReportPrinter1.Title := PrnInfo.feJobtitle;

                                oOnPrint := ReportPrinter1.OnPrint;
                                ReportPrinter1.OnPrint := PrintFile;
                                For I := 1 To Copies Do
                                  ReportPrinter1.Execute;
                                ReportPrinter1.OnPrint := oOnPrint;
                              End { If }
                              Else Begin
                                { Print PCC Text to RPPro intermediate file and use }
                                { normal EFD form functions to handle the rest }
                                RepFName := ConvertPCCToEFP (RepFName, JobInfo, PageList, True, PrnInfo.feJobtitle);

                                If (OutMethod = 1) Then Begin
                                  { Fax via MAPI or Exchequer }
                                  Case PrnInfo.feFaxMethod Of
                                    { via Exchequer }
                                    0 : SendEntFax (PrnInfo, FilePrinter1, RepFName, True);
                                    { via MAPI }
                                    1 : SendMAPIFax (PrnInfo, RepFName);
                                    { Third-Party Fax Software }
                                    2 : SendEntFax (PrnInfo, FilePrinter1, RepFName, False);
                                  Else
                                    MessageDlg ('Unknown Fax Method (' + IntToStr(PrnInfo.feFaxMethod) + ') - Fax not sent',
                                                mtError, [mbOk], 0);
                                  End; { Case }
                                End { If }
                                Else Begin
                                  { Email via MAPI/Exchequer }
                                  SendEmailFile (PrnInfo, FilePrinter1, RepFName);
                                End; { Else }
                              End; { Else }

                              DeletePrintFile (RepFName);
                            End;
              rdPreview   : Begin { Print to Preview window }
                              { Display preview window }
                              Preview(PrnInfo);

                              { NOTE: Temp file deleted by preview window }
                            End;
            End; { Case }
          End { If }
          Else
            { Aborted - delete temporary file }
            DeletePrintFile (RepFName);
        End; { If }
      {$ELSE} { FORMTK }
        { Close Text File }
        PrnF.Free;

        If (RepDest = rdPrintFile) And (OutMethod = 0) And (Copies > 1) Then Begin
          // Printing multiple copies direct to printer
          ReportPrinter1.Title := PrnInfo.feJobtitle;

          oOnPrint := ReportPrinter1.OnPrint;
          ReportPrinter1.OnPrint := PrintFile;
          For I := 1 To Copies Do
            ReportPrinter1.Execute;
          ReportPrinter1.OnPrint := oOnPrint;
        End { If (RepDest = rdPrintFile) ... }
        Else
          If (RepDest <> rdPrinter) Then Begin
            // Printing to Tempfile - convert to .EDF format and return FTK information
            RepFName := ConvertPCCToEFP (RepFName, JobInfo, PageList, True, PrnInfo.feJobtitle);

            If Assigned(PrnInfo.feDataPtr) Then
              With pFormToolkitData(PrnInfo.feDataPtr)^ Do Begin
                ftdTempFile := RepFName;
                ftdPages := PageList.Count;
              End; { With pFormToolkitData(PrnInfo.feDataPtr)^ }
          End; { If (RepDest <> rdPrinter) }
      {$ENDIF}

      { Aborted }
      SendProgress (0, 0);   { Clear progress }
    End; { If }
  Except
    On EStreamError Do
      MessageDlg ('Stream Error:' + CRLF + CRLF +
                  'An error has occured creating the print file for the form, ''' +
                  RepFName + ''', form aborted.', mtError, [mbOk], 0);

    On ENoUnique Do
      MessageDlg ('Filename Error:' + CRLF + CRLF +
                  'No unique filename could be found' + CRLF + CRLF +
                  'Form Aborted.', mtError, [mbOk], 0);
  End;
End;


procedure TForm_PrintPCC.PrintAbort (var Msg: TMessage);
begin
  If (MessageDlg ('Are you sure you want to abort the batch currently being printed', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
    AbortBatch := True;
end;


Procedure TForm_PrintPCC.SendProgress (Const CurrItem : SmallInt;Const Mode : Byte);
Var
  Percent : Integer;
Begin
  If Assigned (SystemInfo.MainForm) And (TotItems > 0) And (Mode In [0, 1]) Then Begin
    Try
      PerCent := Round ((CurrItem / TotItems) * 100);
      SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, Mode, PerCent);
      SystemInfo.MainForm.Refresh;
    Except
      On Exception Do ;
    End;
  End; { If }
End; { If }


procedure TForm_PrintPCC.Batch_Print(Sender: TObject);
Var
  {HedRec     : fdHeaderRecType;
  StrRec     : fdFormStringsType;
  JobPage    : Integer;
  TxtRect    : TRect;
  DoneCont   : Boolean;}
  TmpPtr     : Pointer;
  I          : SmallInt;

  { Link Customer to Def including any Remit/ Statement links }
  Procedure LinkCust;
  Const
    Fnum    =  CustF;
    KeyPath =  CustCodeK;
  Var
    Loop              :  Boolean;
    TmpKPath, TmpStat :  Integer;
    TmpRecAddr        :  LongInt;
    KeyS, CKey        :  Str255;
    FoundKey          : Str20;
  Begin
    Loop:=BOn;

    If (Not (CurrJob.PrintBatch.pbDefMode In [6..9,13,19..21])) then Begin
      { == Preserve Positioning == }
      TmpKPath:=GetPosKey;
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      Case CurrJob.PrintBatch.pbDefMode of
        1..2,14..16,fmDocSerialNo
              :  CKey:=Inv.CustCode;

        3..5,
        22    :  CKey:=Cust.CustCode;  {* Needed as CKey now (v2.20) includes CustSupp *}


      {$IFDEF PF_On}

        23    :  Begin {* Link to Employee & sub con Rec *}
                   GetJobMisc(Application.MainForm,FullEmpCode(Inv.BatchLink),FoundKey,3,-1);

                   If (Ok) then
                     CKey:=JobMisc^.EmplRec.Supplier;

                 end;

        24    :  Begin
                   GetJob(Application.MainForm,Inv.DJobCode,FoundKey,-1);
                   CKey:=Inv.CustCode;
                 end;

        25    :  CKey:=JobRec^.CustCode;

      {$ENDIF}
      End; { Case }

      Repeat
        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,CKey);

        If (StatusOk) and (CurrJob.PrintBatch.pbDefMode In [2..4,22]) and (Loop) and (Cust.RemitCode<>'') then
        Begin
          TCust^:=Cust;

          CKey:=FullCustCode(Cust.RemitCode);
        end;

        Loop:=Not Loop;
      Until (Not StatusOk) or (Loop);

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
    End; { If }
  end; { LinkCust }


  { Opens the .DEF/.LST files }
  Function Open_Def(DFnam, NFnam : Str30) : Boolean;
  Begin
    Result := False;

    {$I-}
      FormName := SetDrive+'Forms\'+DFnam;
      AssignFile(DEFFile, FormName);
      Reset(DEFFile);

      If (IOResult=0) Then Begin
        FormName := SetDrive+'Forms\'+NFnam;
        AssignFile(NAMFile,FormName);
        Reset(NAMFile);

        Result := (IOResult = 0);
      End;
    {$I+}
  End;

  { Closes the .DEF/.LST File }
  Procedure Close_Def;
  Begin
    {$I-}
      CloseFile(DEFFile);
      CloseFile(NAMFile);
    {$I+}

    If (IOResult<>0) then ;
  End;

begin
  JobIdx := 0;
  CurrJob := Nil;
  AbortForm := False;
  TotItems := PrintBatchList.Count;

  { Check we have jobs to print }
  If (PrintBatchList.Count > 0) Then Begin
    { Set printing effects for current printer }
    SetEffects;

    { Set Page Length }
    PrintData(Printer_Def.ResetP + Printer_Def.Plen66,True);

    Repeat
      { Get current print job from batch }
      CurrJob := PrintBatchList.Items[JobIdx];

      { Get form info for currjob }
      If Assigned (CurrJob) Then Begin
        { Open .DEF and .LST files }
        If Open_Def(CurrJob.PrintBatch.pbEFDName+'.DEF',CurrJob.PrintBatch.pbEFDName+'.LST') Then Begin
          { Reset records so we don't pick up dud info from previous forms }
          For I := 1 To TotFiles Do
            { Except for Form Details and System Setup }
            If Not (I In [SysF, FormDetsF]) Then Begin
              ResetRec (I);
              ExLocal.AssignFromGlobal(I);
            End; { If }
          TCust^ := Cust;
          TInv^ := Inv;

          (* MH 25/10/2011 v6.9: Should be handled in CustomFields object from v6.9
          // MH 10/07/06: Added bodge for LITE which doesn't support these flags but may have them set to TRUE in the DB
          If EnterpriseLicence.IsLITE Then
          Begin
            SyssVAT.VATRates.HideLType[1] := False;
            SyssVAT.VATRates.HideLType[2] := False;
            SyssVAT.VATRates.HideLType[3] := False;
            SyssVAT.VATRates.HideLType[4] := False;
          End; // If EnterpriseLicence.IsLITE
          *)

          { Set handle to global strings and re-initialise }
          StringsRec  := StrRec;
          FillChar(StrRec^, SizeOf(StrRec^), #0);

          { copy report info into global var - remember pointer for aged statements }
          TmpPtr := Nil;
          If (JobIdx > 0) And (CurrJob.PrintBatch.pbDefMode = fmStateAgeMnth) Then TmpPtr := RepInfo.RepPtr;
          RepInfo := CurrJob.PrintBatch.pbRepInfo;
          If Assigned (TmpPtr) Then RepInfo.RepPtr := TmpPtr;

          { Reset any running totals }
          DicNewForm;

          { Adjust Main File by Mode and then get it }
          AdjustMain;

          If (Not AbortForm) Then Begin
            If (CurrJob.PrintBatch.pbTablKPath <> -1) Then AdjustTable;
            FormPurpose := CurrJob.PrintBatch.pbDefMode;

            // HM 04/01/01: Changed DrivingFile for Labels as relational links not working
            If (CurrJob.PrintBatch.pbDefMode = fmLabel) Then
              DrivingFile := CurrJob.PrintBatch.pbMainFNum
            Else
              DrivingFile := CurrJob.PrintBatch.pbTablFNum;

            { }
            DefFVar:=F[CurrJob.PrintBatch.pbTablFNum];

            { Take local copy of global recs }
            TInv^ := Inv;
            LinkCust;
            TCust^ := Cust;

            With PrintJobInfo^ Do
            begin
              If (feEmailFName = Chr(255)) Then
              Begin
                // PS 15/09/2016 : ABSEXCH-2581 : Removed line which makes addtachment file name to 8.3 char feEmailFName := Copy(Inv.OurRef, 1, 3) + Copy(Inv.OurRef, 5, 5)
                feEmailFName := Inv.OurRef;
              End; { If (PrintJobInfo^.feEmailFName = Chr(255)) }
            end;

            With CurrJob.PrintBatch Do Begin
              DKeyLen:=Length(pbTablKRef);

              Process_File(pbDefMode,
                           pbTablFNum,
                           pbTablKPath,
                           pbTablKRef,
                           (Pred(TotItems) = JobIdx));
            End; { With }
          End; { If }

          Close_Def;
        End { If }
        Else
          { Cannot open .def file}
          PrintErrorPage (1);
      End; { If }

      Inc(JobIdx);

// HM 26/07/04: Copied in checks from EFD printing routines
//      If (CurrJob.PrintBatch.pbDefMode = fmAllDocs) Or
//         (CurrJob.PrintBatch.pbDefMode = fmPickLstCons) Or
//         (CurrJob.PrintBatch.pbDefMode = fmPickLstSngl) Or
//         (CurrJob.PrintBatch.pbDefMode = fmTimeSheet) Or
//         { HM 17/02/00: Added for Doc with Serial No }
//         (CurrJob.PrintBatch.pbDefMode = fmDocSerialNo) Then Begin

      // HM 04/11/04: Added 'Set Printed Status' flag so that Authoris-e can stop
      // FDes from setting the Printed Status on transactions, default to setting it
      If bSetPrintedStatus And
        ((CurrJob.PrintBatch.pbDefMode = fmAllDocs) Or
         (CurrJob.PrintBatch.pbDefMode = fmPickLstCons) Or
         (CurrJob.PrintBatch.pbDefMode = fmPickLstSngl) Or
         (CurrJob.PrintBatch.pbDefMode = fmTimeSheet) Or
         (CurrJob.PrintBatch.pbDefMode = fmTransSort) Or
         // HM 26/07/04@ Added Remittance Advices
         (CurrJob.PrintBatch.pbDefMode = fmRemitAdv) Or
         // HM 03/09/03: Added Picking List with Bins support
         (CurrJob.PrintBatch.pbDefMode = fmPickListBins) Or
         (CurrJob.PrintBatch.pbDefMode = fmPickListConsBins) Or
         (CurrJob.PrintBatch.pbDefMode = fmSortedPickingList) Or
         { HM 17/02/00: Added for Doc with Serial No }
         (CurrJob.PrintBatch.pbDefMode = fmDocSerialNo)) Then
      Begin
        { Mark document as Printed }
        SetPrintedStatus;
      End; { If }

      { Update Progress }
      SendProgress (JobIdx, 1);
    Until AbortBatch Or (JobIdx > (PrintBatchList.Count - 1));

    Batch_KillScratchObj;
  End; { If }
end;


{ De-Allocates the temporary scratch file if allocated }
Procedure TForm_PrintPCC.Batch_KillScratchObj;
Begin
  If (ScratchO <> Nil) Then Begin
    Dispose (ScratchO,Done);
    ScratchO := Nil;
  End; { If }

  If Assigned(ScratchFile) Then
    FreeAndNIL(ScratchFile);
End;


{ Sets printing effects control codes for current printer }
Procedure TForm_PrintPCC.SetEffects;
Var
  PrnIdx : SmallInt;
Begin
  { Get setting from .INI file }
  PrnIdx := GetControlCode(RpDev.Printers[RpDev.DeviceIndex]);

  If (PrnIdx In [Low(Printer_defFile)..High(Printer_defFile)]) Then Begin
    Printer_Def := Printer_defFile[PrnIdx];

    With Printer_defFile[PrnIdx] Do Begin
      FillChar(PEFxs,Sizeof(PEFxs),0);

      PEfxs.Codes[Ord(^A),BOn]:=CondOn;
      PEfxs.Codes[Ord(^A),BOff]:=CondOf;

      PEfxs.Codes[Ord(^B),BOn]:=Dson;
      PEfxs.Codes[Ord(^B),BOff]:=Dsof;

      PEfxs.Codes[Ord(^D),BOn]:=EmphOn;
      PEfxs.Codes[Ord(^D),BOff]:=EmphOf;

      PEfxs.Codes[Ord(^E),BOff]:=EnlrgOf;
      PEfxs.Codes[Ord(^E),BOn]:=EnlrgOn;

      PEfxs.Codes[Ord(^N),BOn]:=ItalOn;
      PEfxs.Codes[Ord(^N),BOff]:=ItalOff;

      PEfxs.Codes[Ord(^S),BOn]:=UndyOn;
      PEfxs.Codes[Ord(^S),BOff]:=UndyOf;

      PEfxs.Codes[Ord(^T),BOn]:=QOn;
      PEfxs.Codes[Ord(^T),BOff]:=QOf;

      PEfxs.Codes[Ord(^V),BOn]:=VEnlrgOn;
      PEfxs.Codes[Ord(^V),BOff]:=VEnlrgOf;
    End; { With }
  End; { If }
End;


{ Adjusts main file info depending on mode }
Procedure TForm_PrintPCC.AdjustMain;
Begin
  With CurrJob.PrintBatch Do Begin
    { Get the main file record }
    Status := Find_Rec (B_GetEq, F[pbMainFnum], pbMainFnum, RecPtr[pbMainFnum]^, pbMainKPath, pbMainKRef);

    { Display error if failed to get record }
    If (Status <> 0) Then PrintErrorPage (2);
  End; { If }
End;


Procedure TForm_PrintPCC.PrintErrorPage (Const PageErr : Integer);
Var
  PCurr, pForm, pDesc, pMode, pMFN, pMKP, pTFN, pTKP, pStat : Boolean;
Begin
  (*
  With TheReport, CurrJob.PrintBatch Do Begin
    TheReport.MarginLeft := TheReport.LeftWaste + 1;
    TheReport.SetFont ('Courier New', 10);
    TheReport.Bold:= True;
    LineNum := 5;

    pForm := True;
    pDesc := True;
    pMode := True;
    pMFN := True;
    pMKP := True;
    pTFN := True;
    pTKP := True;
    pStat := True;

    Case PageErr Of
      1 : Begin { Cannot open form def }
            PrintLn (#9'Error: Cannot load ' + FormName);
            pForm := False;
            pCurr := True;
          End;

      2 : Begin { Cannot find primary record }
            PrintLn (#9'Error: Cannot load Primary Record');
          End;
    End; { Case }

    LineNum := 7;
    TheReport.Bold:= False;
    If pCurr Then PrintLn (#9'CurrDir:        ' + GetCurrentDir);
    If pForm Then PrintLn (#9'Form:           ' + FormName);
    If pDesc Then PrintLn (#9'Description:    ' + pbDescr);
    If pMode Then PrintLn (#9'DefMode:        ' + IntToStr (pbDefMode));
    If pMFN Then  PrintLn (#9'MainFNum:       ' + IntToStr (pbMainFNum));
    If pMKP Then  PrintLn (#9'MainKPath:      ' + IntToStr (pbMainKPath));
    If pTFN Then  PrintLn (#9'TablFNum:       ' + IntToStr (pbTablFNum));
    If pTKP Then  PrintLn (#9'TablKPath:      ' + IntToStr (pbTablKPath));
    If pStat Then PrintLn (#9'Btrieve Status: ' + IntToStr (Status));

    AbortForm := True;
  End; { With }
  *)
End;


{ Adjusts Table file info depending on mode }
Procedure TForm_PrintPCC.AdjustTable;
Var
  FNum, KPath : Integer;
  TmpMode     : Byte;
Begin
  With CurrJob.PrintBatch Do Begin
    TmpMode := pbDefMode;

    { Adjust the main file pointers }
    Case TmpMode Of
      // MH 08/06/2010 v6.4 ABSEXCH-7916: Modified statements to use ledger index to define order
      fmStatemLay    : Begin
                         // Customer/Supplier record already loaded so swe can use that to build the key
                         pbTablFnum  := InvF;
                         pbTablKPath := InvCustLedgK;  // CustCode + CustSupp + NormFlg + Date + Folio (InvCustLedgK) }
                         pbTablKRef  := FullCustCode (Cust.CustCode) + Cust.CustSupp;
                       End; // fmStatemLay

      fmRemitAdv     : Begin { Shouldn't do this as it should be passed in }
                         RemitDoc    := Inv.OurRef;
                         pbTablFnum  := PWrdF;
                         pbTablKRef  := FullMatchKey(MatchTCode,MatchSCode,RemitDoc);
                         pbTablKPath := HelpNdxK;
                       end;
      fmBatchDoc     : Begin { Shouldn't do this as it should be passed in }
                         pbTablFnum  := InvF;
                         pbTablKRef  := Inv.OurRef;
                         pbTablKPath := InvBatchK;
                       end;
      // HM 16/01/04: Added workaround to Exchequer bug where the single picking list is printed
      // using different indexes from the Sales Daybook and the Picking List Run.  Means the additional
      // description lines appear backwards on the latter.
      fmPickLstSngl  : Begin
                         pbTablKPath := IdFolioK;
                       End;
      fmPickLstCons  : Begin
                         FileNames[ReportF] := Repinfo.SFName;
                         FF_OpenFile2 (ReportF);

                         Batch_KillScratchObj;

                         New(ScratchO,Init(-1));
                         ScratchO.Process := 1;

                         RepInfo.RepPtr := ScratchO;
                       End;
      (*fmDocSerialNo  : Begin
                         { Build serial number list }
                         TmpMode := pbDefMode;

                         {$IFDEF STK}
                           {$IFDEF SOP}
                             { make sure it isn't allocated }
                             Batch_KillScratchObj;

                             New(ScratchO,Init(7));

                             RepInfo.RepPtr := ScratchO;

                             {*EX32}
                             Def_BuildSNo(11{HeaderRec.fhSerialNo},TmpMode,FNum,KPath,ScratchO);

                             If (TmpMode = fmDocSerialNo) Then Begin
                               { Change table details to do serial numbers }
                               pbTablFnum  := FNum;
                               pbTablKPath := KPath;
                               pbTablKRef  := FullNomKey(7) + pbTablKRef;
                             End; { If }
                           {$ENDIF}
                         {$ENDIF}
                       End; *)

      fmStateAgeMnth : If (JobIdx = 0) And RepInfo.ShowMonthDoc Then Begin
                         FileNames[ReportF] := Repinfo.SFName;
                         FF_OpenFile2 (ReportF);

                         Batch_KillScratchObj;

                         New(ScratchO,Init(-1));
                         ScratchO.Process := 7;

                         RepInfo.RepPtr := ScratchO;
                       End
                       Else If (Not RepInfo.ShowMonthDoc) Then
                       Begin
                         // MH 08/06/2010 v6.4 ABSEXCH-7916: Modified statements to use ledger index to define order

                         // Customer/Supplier record already loaded so swe can use that to build the key
                         pbTablFnum  := InvF;
                         pbTablKPath := InvCustLedgK;  // CustCode + CustSupp + NormFlg + Date + Folio (InvCustLedgK) }
                         pbTablKRef  := FullCustCode (Cust.CustCode) + Cust.CustSupp;
                       End; // Else
    End; { Case }

    { Keep any mode changes }
    pbDefMode := TmpMode;
  End; { If }
End;


{ ================ Process File ============== }
Procedure TForm_PrintPCC.Process_File(Mode          : Byte;
                                      Fnum,KeyPAth  : Integer;
                                      KeyRef        : Str255;
                                      LastOne       : Boolean);


Var
  TextLn        : Str255;
  Lno           : SmallInt;
  ResetK, DotOn : Boolean;
  ThisScrt      : ScratchPtr;
  sSearchKey    : Str255;
  FakeHeader    : fdHeaderRecType;
Begin
  { Init Form settings }
  PL:=66; Po:=0; CurrILineNo:=1;

  NoILinesPed:=0; {* No of Actual Lines Printed *}

  MT:=0;

  FF:=BOn;

  CP:=BOff;

  RL:=BOff;

  ER:=BOff;

  RFOK:=BOn;

  FirstGo:=BOn;

  PMMode:=BOff;

  Ok2Prnt:=BOn;

  PrintLine:=BOn;

  InIFSta:=BOff;

  SNMode:=BOff;  SNBatch:=0;
  BinMode:=False;
  UseByMode:=False;
  StkPrioMode:= False;
  PickListDescLines:= False;
  PickListShowDescOnly := False;
  PickListInclNewLines := False;
  PickListShowBoM := False;

  JobInfo.jiFontName := 'Courier New';
  JobInfo.jiFontSize := 9;

  Lno:=0;
  PrntOk:= BOn;
  MPage:=1;
  ThisScrt:=NIL;
  ResetK:=BOff;

  DicPageNo := @MPage;

  sSearchKey := '';

  While (Not EOF(DEFFile)) And (PrntOk) Do Begin
    { HM 04/06/98: Free time up to keep Exchequer & Computer alive }
    Application.ProcessMessages;

    Blank(TextLn,Sizeof(TextLn));

    ReadLn(DEFFile,TextLn);

    DotOn:=(TextLn[1]=DotChr);


    If (Not DotOn) and (PrintLine) then
      PrintData(Spc(PO),False);


    {$B-}

    If ((RL) and (Not DotOn) and (Not ER) and (GetNextLine(Mode,Fnum,KeyPath,KeyRef,sSearchKey))) then;

    {$B+}


    ProcessLn(TextLn);

    {$IFDEF STK}

      {$IFDEF SOP}

        // HM 09/09/03: Added support for Picking Lists with Bins
        If (Mode = fmPickListBins) Or (Mode = fmPickListConsBins) Then
          // Do nothing - otherwise it F's it up!
        Else If BinMode and (Mode = fmPickLstSngl) {And (Not Assigned(ScratchFile))} Then
        Begin
          // Single Picking List with Bins - build scratch file of bin/stock lines
          Mode := fmPickListBins;

          // HM 04/11/03: Keep the file intact when doing a Picking List Run so that the
          // running list of bin allocations is kept across Single Picking Lists
          If CurrJob.PrintBatch.pbRepInfo.crFlags[89] Then
          Begin
            // Picking List Run
            If (Not Assigned(ScratchFile)) Then
            Begin
              // Create scratch file object
              ScratchFile := TScratchFile.Create(1010);
            End; // If (Not Assigned(ScratchFile))
          End // If CurrJob.PrintBatch.pbRepInfo.crFlags[89]
          Else
          Begin
            // Printing SOR as Picking List
            { make sure the scratch file object isn't allocated }
            Batch_KillScratchObj;

            // Create scratch file object
            ScratchFile := TScratchFile.Create(1010);
          End; // Else

          // Call the routine to build the scratch file
          BuildSinglePickListWithBins(CurrJob.PrintBatch.pbRepInfo.crFlags[90], PickListDescLines, PickListShowBoM);

          { Change table details to run from scratch file }
          FNum    := ScratchFileF;
          Keypath := IIF(StkPrioMode, Integer(1), Integer(0));
          DefFVar := F[FNum];
          KeyRef  := FullNomKey(1010);
          DKeyLen := Length(KeyRef);
        End // If BinMode and (Mode = fmPickLstSngl)
        Else If BinMode and (Mode = fmPickLstCons) Then
        Begin
          // Consolidated Picking List with Bins - build scratch file of bin/stock lines

          // Open the scratch file supplied from Exchequer - have to manually open
          // otherwise a new random name is generated and a new file created
          FileNames[ReportF] := Repinfo.SFName;
          FF_OpenFile2 (ReportF);
          New(ScratchO,Init(-1));
          ScratchO.Process := 1;

          // Build scratch file of lines
          Mode := fmPickListConsBins;

          // Create scratch file object
          ScratchFile := TScratchFile.Create(1011);

          // Call the routine to build the scratch file
          BuildConsolPickListWithBins (ScratchO, CurrJob.PrintBatch.pbRepInfo.crFlags[90]);

          { Change table details to run from scratch file }
          FNum    := ScratchFileF;
          Keypath := IIF(StkPrioMode, Integer(1), Integer(0));
          DefFVar := F[FNum];
          KeyRef  := FullNomKey(1011);
          DKeyLen := Length(KeyRef);
        End // If BinMode and (Mode = fmPickLstSngl)
        Else If (Mode = fmPickLstSngl) And (ThisScrt=NIL) And SNMode And PickListShowBoM Then
        Begin
          // Single Picking List WITH Serial/Batch and including Hidden BoM Lines
          Mode := fmSortedPickingList;

          // Setup the serial numbers - stored in global vars in SerialNo.Pas
          SNDOSMode := True;
          SNoFieldWidth := SNWidth;
          SNFieldIncInp := False;
          SNoShowBins   := BinMode;
          SNoShowUseBy  := UseByMode;

          FillChar(FakeHeader, SizeOf(FakeHeader), #0);
          FakeHeader.fhSerialNo := SNBatch;
          FakeHeader.fhExplodeBoMs := PickListShowBoM;
          FakeHeader.fhInclNewLines := PickListInclNewLines;
          FakeHeader.fhShowDescOnly := PickListShowDescOnly;
          FakeHeader.fhShowAddDesc :=  PickListDescLines;

          New(ThisScrt,Init(1009));
          RepInfo.RepPtr := ThisScrt;

          BuildTransLines (1, ThisScrt, FakeHeader, True);  // Stock Code Order

          { Change table details to run from scratch file }
          FNum    := ReportF;
          Keypath := 0;
          DefFVar := F[FNum];
          KeyRef  := FullNomKey(1009);
          DKeyLen := Length(KeyRef);

          SNDOSMode := False;
        End // If (Mode = fmPickLstSngl) And SNMode And PickListShowBoM
        Else If (SNMode Or BinMode) and (ThisScrt=NIL) and (Mode<>22) then
        Begin
          { Setup the serial numbers }
          SNDOSMode := True;
          SNoFieldWidth := SNWidth;
          SNFieldIncInp := False;

          SNoShowBins   := BinMode;
          SNoShowUseBy  := UseByMode;

          New(ThisScrt,Init(7));

          {DefSet_RepPtr(ThisScrt);}
          RepInfo.RepPtr := ThisScrt;

          Def_BuildSNo(SNBatch,Mode,Fnum,Keypath,ThisScrt);

          SNDOSMode := False;

          ResetK:=BOn;
        End // If (SNMode Or BinMode) and (ThisScrt=NIL) and (Mode<>22)
        Else If (PMMode) and (ThisScrt=NIL) and (Mode In [1,14]) then
        Begin

          New(ThisScrt,Init(7));

          {DefSet_RepPtr(ThisScrt);}
          RepInfo.RepPtr := ThisScrt;

          Def_BuildPMode(PMType,Mode,Fnum,Keypath,ThisScrt);

          ResetK:=BOn;
        End // If (PMMode) and (ThisScrt=NIL) and (Mode In [1,14])
        Else If (Mode = fmPickLstSngl) And PickListShowBoM Then
        Begin
          // MH 16/03/09: v6.01 - Set the starting search so that -ve lines are included - Hidden BoM lines
          sSearchKey := KeyRef + FullNomKey(-1);
        End; // If (Mode = fmPickLstSngl) And PickListShowBoM

        If (Mode=18) and (ResetK) then
        Begin
          DefFVar:=F[Fnum];

          KeyRef:=FullNomKey(7)+KeyRef;

          DKeyLen:=Length(KeyRef);

          ResetK:=BOff;
        End; // If (Mode=18) and (ResetK)

      {$ENDIF}  // SOP

    {$ENDIF} // STK



      {** Print Line if
                        Not a Dot Command
                        & Printing Switched On **}

    If (Not DotOn) and (PrintLine) then
    Begin
      PrintData(#13#10,False);

      Inc(Lno);

      If (RL) then
        Inc(CurrILineNo);
    end;



  {$B-}


    If (ER) and (GetNextLine(Mode,Fnum,KeyPath,KeyRef,sSearchKey)) then
    Begin
      EOP(Lno,MPage);
      Lno:=PL;
      ER:=BOff;


    end;


  {$B+}

    SetPage(Lno,MPage);

    {*EX32 Stppout(PrntOk);}
  end; {While..}

  { Print EOP if not last page, Windows auto prints one on last page }
  If (Not LastOne) Then
    EOP(Lno,MPage);

  {$IFDEF STK}
    {$IFDEF SOP}
      If (ThisScrt<>NIL) then
        Dispose(ThisScrt,Done);
    {$ENDIF}

// HM 06/11/03: Removed as breaking Picking List Runs
//    If Assigned(ScratchFile) Then
//      FreeAndNIL(ScratchFile);
  {$ENDIF}
end; {Proc..}


{ Procedure to Get the next Repeat Line }
Function TForm_PrintPCC.GetNextLine(    Mode       :  Byte;
                                        Fnum,
                                        Keypath    :  Integer;
                                        KeyRef     :  Str255;
                                    Var sSearchKey : Str255) : Boolean;
Var
  KeyS       : Str255;
  B_Func,
  TmpKPath,
  TmpStat    : Integer;
  TmpRecAddr : LongInt;

  //------------------------------

  Procedure LoadVATReceiptData;
  Var
    PrevRec : OrderPaymentsVATPayDetailsRecType;
  Begin // LoadVATReceiptData
    If FirstGo Then
    Begin
      FirstGo := False;

      // Clear down the backup record so that if no rows exist we have safe values in the record
      FillChar(PrevRec, SizeOf(PrevRec), #0);

      // Find first row for receipt
      OPVATPayFile.Index := vpIdxReceiptRef;
      Status := OPVATPayFile.GetGreaterThanOrEqual(OPVATPayFile.BuildReceiptRefKey(Inv.thOrderPaymentOrderRef, Inv.OurRef));
    End // If FirstGo
    Else
    Begin
      // Backup current record to restore in the event of an error
      PrevRec := OPVATPayFile.VATPayDetails;

      // Find next row for receipt
      Status := OPVATPayFile.GetNext;
    End; // Else

    // Check keys match
    RFOk := (Status = 0) And (Trim(OPVATPayFile.VATPayDetails.vpReceiptRef) = Trim(Inv.OurRef));
    If (Not RFOk) Then
      // Restore original record so we have safe values
      OPVATPayFile.VATPayDetails := PrevRec;
  End; // LoadVATReceiptData

  //------------------------------

  Procedure LoadLegacyData;
  Begin // LoadLegacyData
    If FirstGo Then Begin
      FirstGo:=BOff;
      B_Func:=B_GetGEq;

      If (sSearchKey <> '') Then
        // Use custom searchkey to start search - used by single picking lists when Hidden BoM turned on
        KeyS := sSearchKey
      Else
        KeyS:=KeyRef;
    End { If }
    Else
    Begin
      B_Func:=B_GetNext;
      KeyS := sSearchKey;  // MH 16/03/09: Need to re-use previous search key otherwise btrieve can get lost on duplicate keys
    End; // Else


    TmpKPath:=GetPosKey;
    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,DefFVar,TmpRecAddr,BOff,BOff);

    {* Extra call needed to re-establish pos with brequest *}

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,DefFVar,TmpRecAddr,BOn,BOff);

    {$B-}

    If (RFOK) Then Begin

      Repeat

        Status:=Find_Rec(B_Func,DefFVar,Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        B_Func:=B_GetNext;

      Until (Not StatusOk) or (Not CheckKey(KeyRef,KeyS,DKeyLen,BOn)) or (Include(Mode)) ;

      RFOK:=((StatusOk) and (CheckKey(KeyRef,KeyS,DKeyLen,BOn)) and (Include(Mode))) ;

      sSearchKey := KeyS; // MH 16/03/09: Need to re-use search key on next operation otherwise btrieve can get lost on duplicate keys

      { HM 12/11/97: Added to restore a valid record after table finished }
      If RFOk Then
        { Save current valid record }
        ExLocal.AssignFromGlobal(FNum)
      Else
        { Restore record - so the data dict doesn't load duff data }
        ExLocal.AssignToGlobal(FNum);
    end;

    {$B+}

    If (RFOk) and (Not ER) Then Begin {* Consolidate Picking Lines *}
      Case Mode of
        13  :  Begin
                 KeyS:=SetDCheckKey;

                 Consol_Pick(Mode,Fnum,KeyPath,KeyS);
               end;
      end; {Case..}
    End; { If }
  End; // LoadLegacyData

  //------------------------------

Begin
  // MH 19/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
  If (CurrJob.PrintBatch.pbDefMode = fmOrdPayVATReceipt) Then
    LoadVATReceiptData
  Else
    LoadLegacyData;

  Ok2Prnt := RFOk;

  If (Ok2Prnt) and (Not ER) then
    DicRunTots(Mode);

  {*** If Lines do not Want padding then switch printing off on surplus blank lines,
       but preserve intentional blank lines. Do not check whilst processing an If,
       otherwise it destroys IF ***}

  If (Not CP) and (Not InIFSta) then
    PrintLine:=((ER) or ((Ok2Prnt) or (RFOK)));

  // MH 19/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
  If (CurrJob.PrintBatch.pbDefMode <> fmOrdPayVATReceipt) And ((ER) or (Not Ok2Prnt) or (Not PrintLine)) then
  Begin

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,DefFVar,TmpRecAddr,BOn,BOff);

    FirstGo:=(NoILinesPed=0);  {* Keep resetting to top of List if first Lines Blank,
                                  otherwise FVar is full of garbage, and B_Getnext will not work *}
  end
  Else
    Inc(NoILinesPEd);

  GetNextLine:=RFOk;
End; { GetNextLine }



Procedure TForm_PrintPCC.EOP(LineNo,Page  :  Integer);
Var
  LineStr : ShortString;
  n       :  Integer;
Begin
  If (LineNo<PL) and ((LineNo>0) or (Page>1)) Then Begin
    If (FF) then
      { Use a standard Form Feed character to do page break }
      PrintData(#12,True)
    Else Begin
      { Use a series of CR-LF's to move to the end of the page }
      LineStr := '';
      For n:=1 to (PL-LineNo) do
        LineStr := LineStr + #13#10;

      PrintData(LineStr,True);
    End; { Else }

    LineNo:=0;
  End; { If }
end; {Proc..}


{ Set Page/Line No. }
Procedure TForm_PrintPCC.SetPage(Var LineNo, Page : SmallInt);
Begin
  If (LineNo=PL) then Begin
    SetMT;   {** Set Margin Top on from second Page onwards **}

    LineNo:=MT;

    Inc(Page);

    Reset(DEFFile);
    Reset(NamFile);
  End; { If }
end; { SetPage }


{ Filter to see if line should be included }
Function TForm_PrintPCC.Include(Mode : Byte) : Boolean;
Const
  Fnum     = InvF;
  KeyPath2 = InvOurRefK;
Var
  TBO, Loop         : Boolean;
  KeyS              : Str255;
  FoundCode         : Str20;
  OldStat           : Integer;
  RepSCRO           : ScratchPtr;
  RngS, RngE, Units : SmallInt;

  Procedure Show_SNoId(Var IdR  :  IDetail;
                           SNOD :  Str80);
  Var
    TmpId  :  Idetail;
  Begin
    With IdR do Begin
      TmpId:=IdR;

      ResetRec(IdetailF);

      StockCode:=TmpId.StockCode;

      Desc:=StringsRec.fsSVStrs[4]+SNoD;
    end;
  end;

Begin
  TBO:=BOff;
  KeyS:='';

  { Status preserved here, as otherwise direct docs do    }
  { not abort properly since a stk/other Bt function will }
  { reset Status                                          }
  OldStat:=Status;

  RepScrO:=RepInfo.RepPtr; {RepScrLink;}

  {$IFDEF STK}
    {$IFDEF SOP}
      If (Mode=fmDocSerialNo) Or (Mode = fmSortedPickingList) Then
      Begin
        { Get Id Link unless Serial only line }
        If (RepScrO<>NIL) and (RepScr^.RecAddr<>0) then
          RepScrO^.Get_Scratch(RepScr^)
        else
          Show_SNoId(Id,RepScr^.KeyStr);
      End; { If }
    {$ENDIF}

    // HM 03/09/03: Added support for Picking List with Bins
    If (Mode = fmPickListBins) Or (Mode = fmPickListConsBins) Then
    Begin
      // Extract the Bin/Stock/Id info from the scratch file
      If Assigned (ScratchFile) Then
      Begin
        // Setup a fake Transaction Line
        ResetRec(IdetailF);
        With Id Do
        Begin
          // HM 15/01/04: Extended to support Additional Description Lines
          Desc := ScratchFile.sfLongString;

          // Check to see if it is an additional description line
          If (ScratchFile.sfIntegers[2] = 0) Then
          Begin
            StockCode := ScratchFile.sfStrings[1];
            Qty       := ScratchFile.sfDoubles[2];
            QtyMul    := 1;
            QtyPick   := ScratchFile.sfDoubles[1];
            MLocStk   := ScratchFile.sfStrings[4];
          End; // If (sfIntegers[2] > 0)
        End; // With Id

        // Link to Bin
        If (ScratchFile.sfSavePositions[1].LinkToRecordPosition(True) <> 0) Then
        Begin
          // Either error or position not saved in first place (i.e. Non-Bin Stock Item)
          ResetRec (MLocF);
          With MLocCtrl^, brBinRec Do
          Begin
            RecPfix := BRRecCode;
            SubType := MSernSub;

            brBinCode1 := ScratchFile.sfStrings[2];
          End; // With MLocCtrl^, brBinRec
        End; // If (sfSavePositions[1].LinkToRecordPosition(True) <> 0)

        // Link to Stock
        If (ScratchFile.sfSavePositions[2].LinkToRecordPosition(True) <> 0) Then
        Begin
          // Error retrieving Stock Record - fake it
          ResetRec (StockF);
          Stock.StockCode := ScratchFile.sfStrings[1];
        End; // If (sfSavePositions[2].LinkToRecordPosition(True) <> 0)
      End; // If Assigned (ScratchFile)
    End; // If (Mode = fmPickListBins) Or (Mode = fmPickListConsBins)

    With RepInfo do
      If (Mode=fmStateAgeMnth) And (ShowMonthDoc) Then Begin
        If (RepScrO<>NIL) And (RepScr^.RecAddr<>0) Then
          RepScrO^.Get_Scratch(RepScr^);
      End; { If }

    { Establish link to stock record }
    If (Mode In [fmAllDocs, fmNomTxfr, fmStockAdj, fmPickLstCons,
                 fmPickLstSngl, fmDocSerialNo, fmTimeSheet, fmSortedPickingList]) Then
      With Id do Begin
        If Is_FullStkCode(StockCode) And
           (StockCode<>Stock.StockCode) And
           (Mode<>fmTimeSheet) Then
          GetStock(Application.MainForm, StockCode, FoundCode, -1);

        { Blank Last Stock Rec }
        If (Not Is_FullStkCode(StockCode)) then
          ResetRec(StockF);

        {$IFDEF PF_On}
          If (JBCostOn) then Begin
            If (Not EmptyKey(JobCode,JobKeyLen)) Then
              GetJob(Application.MainForm, JobCode,FoundCode,-1);

            If (Not EmptyKey(AnalCode,AnalKeyLen)) Then
              GetJobMisc(Application.MainForm, AnalCode,FoundCode,2,-1);

//            {$IFDEF JC}
//              If (Mode=fmTimeSheet) then {* Get Payrate *}
//                GetEmpRate(Application.MainForm, StockCode,FoundCode,-1);
//            {$ENDIF}
          End;
        {$ENDIF}
      End; { With }
  {$ENDIF}

  {$IFDEF PF_On}
    If (Mode = fmJCBackingSh) then
      With JobDetl^.JobActual Do Begin
        If (CheckRecExsists(LineORef,InvF,InvOurRefK)) Then Begin
          If (CheckRecExsists(FullIdKey(LineFolio,LineNo),IdetailF,IdLinkK)) Then Begin
            {$IFDEF STK}
              If (Is_FullStkCode(StockCode)) then
                GetStock(Application.MainForm, StockCode,FoundCode,-1);
            {$ENDIF}

            GetJobMisc(Application.MainForm, AnalCode,FoundCode,2,-1);
          End; { If }
        End; { If }
      End; { With }
  {$ENDIF}

  Case Mode of
// MH 16/04/2012 v6.10 ABSEXCH-12804: Turn on Shortcut Boolean Evaluation to stop error in following check
{$BOOLEVAL OFF} // Turn off Complete Boolean Evaluation
    fmAllDocs,
    fmTimeSheet : TBO:=(Id.LineNo<>RecieptCode) And
                  // MH 25/10/2011 v6.9: Added Custom Fields info object
                  //((Not (Id.DocLTLink In [1..4])) Or ((Id.DocLTLink In [1..4]) And (Not SyssVAT.VATRates.HideLType[Id.DocLTLink])));
                  ((Not (Id.DocLTLink In [1..4])) Or ((Id.DocLTLink In [1..4]) And CustomFields[cfLinetypes,Id.DocLTLink].cfEnabled));
{$BOOLEVAL ON}

    fmRemitAdv  : With Password.MatchPayRec Do Begin
                    TBO := (PayRef=RemitDoc);

                    {* Link up to Invoice Record *}
                    If TBO then Begin
                      KeyS:=DocCode;

                      ResetRec(Fnum);

                      If (KeyS<>'') then
                        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS);
                    End; { If }
                  End; { With }

    { Debt Chase letters split out. HM: 29/01/97 }
    fmDebtChaseL: Begin
                    { Check there is an outstanding amount for this invoice }
                    TBO:=(CurrencyOS(Inv,BOn,BOff,BOff)>0);

                    If TBO Then
                    Begin
                      { Check its the correct type, and its not an automatically generated invoice }
                      TBO := (Not (Inv.InvDocHed In QuotesSet+PSOPSet)) and Inv.NomAuto;

                      If (TBO) then
                        Case Syss.DebtLMode of
                          0,1  :  TBo:=((CalcWksODue(Inv.DueDate)>=Cust.CreditStatus) or (Syss.IncNotDue));
                          2,3  :  TBo:=((Inv.LastLetter<TrigEquiv(CalcWksODue(Inv.DueDate))) and (Succ(Inv.LastLetter)=RepInfo.DebtLetter));
                          4,5  :  TBo:=(TrigEquiv(CalcWksODue(Inv.DueDate))=RepInfo.DebtLetter);
                        end; {Case..}
                    End; { If }

                      {$IFDEF X32}
                        { Skip date checks if including anything thats due }
                        If (Not ((Syss.DebtLMode In [0, 1]) And Syss.IncNotDue)) Then Begin
                          { get range limits for letter }
                          If (RepInfo.DebtLetter = 1) Then Begin
                            RngS := Syss.WksODue;
                            RngE := Syss.DebTrig[1];
                          End { If }
                          Else Begin
                            RngS := Syss.DebTrig[Pred(RepInfo.DebtLetter)];
                            RngE := Syss.DebTrig[RepInfo.DebtLetter];
                          End; { Else }

                          { Check the invoice is within the range }
                          {Units := CalcDaysWksODue(Inv.DueDate);}
                          Units := CalcWksODue(Inv.DueDate);
                          TBO := (Units >= RngS) And (Units < RngE);

                          { Check it hasn't already been printed, if applicable }
                          If TBO And (Syss.DebtLMode In [2, 3]) Then
                            TBO := (Inv.LastLetter < RepInfo.DebtLetter);
                        End; { If }
                       sdfsdf
                    {$ENDIF}
                  End;

    fmStateAgeMnth,
    fmStatemLay : Begin
                    {$IFDEF MC_On}
                      TBO:=(CurrencyOS(Inv,BOn,BOff,BOff)<>0);
                    {$ELSE}
                      TBO:=(BaseTotalOS(Inv)<>0);
                    {$ENDIF}

                    With RepInfo do
                      If (Mode = fmStateAgeMnth) Then Begin
                        TBO:=(((TBO) or (ShowMonthDoc)) and ((Inv.Currency=ThisCr) or (Not SepCr)));

                        {$IFNDEF JC}
                          TBO:=(TBO and ((Get_StaChkDate(Inv)<=StaAgedDate) or (Syss.IncNotDue)));
                        {$ENDIF}
                      End; { If }

                    TBO:=(TBO and (Not(Inv.InvDocHed In QuotesSet+PSOPSet)) and (Inv.NomAuto));

                    {$IFNDEF JC}
                      If (Mode In [fmStatemLay,fmDebtChaseL]) and (Not Syss.IncNotDue) then
                        TBO:=(TBO and (Get_StaChkDate(Inv)<=Today));
                    {$ENDIF}

                    { On Debt chase letters, only include those relevent to the letter }
                    {If (TBo) and (Mode=fmDebtChaseL) and (Not Syss.IncNotDue) then
                      TBo:=(CalcWksODue(Inv.DueDate)>=Cust.CreditStatus);}
                  end;

    fmTradeHist : TBO:=((Inv.NomAuto) and (Not (Inv.InvDocHed In PSOPSet)));

    // MH 04/11/2011 v6.9: Modified to exclude Audit Notes from Trader Account Details form
    fmTransNotes,    // HM 19/11/02: Added support for printing TH + Notes
    fmStockNote,
    fmJCRec,
    fmAccDets   : TBO := (Password.NotesRec.NType In ['1', '2']);  // '1' = General, '2' = Dated, '3' = Audit

    fmBatchDoc,
    fmNomTxfr,
    fmLabelRun,
    fmLabelSngl,
    fmStockRec,
    fmStockAdj,
    fmPickLstCons,
    fmDocSerialNo,
    fmCISVoucher,
    fmPickListBins,      // HM 09/09/03: Added support for Picking List with Bins
    fmPickListConsBins,  // HM 09/09/03: Added support for Constolidated Picking List with Bins
    fmSortedPickingList  // HM 19/03/09: Added support for Sorted Picking Lists with Serial No's and Hidden BoM lines
                   : TBo:=BOn;

  {$IFDEF STK}
    (*** HM 14/01/04: Rewrote to optionally include additional description lines within the picking list
    fmPickLstSngl  : With Id do  {* Matching picking Run, and Product type, ignore blank or desc only lines *}
                       TBo:=((SOPLineNo=Inv.PickRunNo) And
                            (Stock.StockType In StkProdSet + [StkDescCode]) And
                            ((Is_FullStkCode(StockCode)) or
                            ((Mode=fmPickLstSngl) and (KitLink=0))));
    ***)

    fmPickLstSngl  : TBo := FilterSinglePickingListLine (PickListInclNewLines, PickListShowDescOnly, PickListDescLines, PickListShowBoM);

    (***** MH 07/11/06: Moved out to a separate function in PickListUtil.Pas
    fmPickLstSngl  : With Id Do
                     Begin
                       // MH 04/09/06: Rewrote as the code was garbage - botches on top of bodges

                       // Check the line is for the correct Picking List Run or is a new line (if that option is enabled)
                       TBo := (SOPLineNo=Inv.PickRunNo) Or (PickListInclNewLines And (Id.SOPLineNo=0));

                       If TBo Then
                       Begin
                         // Hide Free Issue Stock on Works Orders
                         TBo := (IdDocHed <> WOR) Or (Not SSDUseLine);
                       End; //  If TBo

                       If TBo Then
                       Begin
                         // Print it if there is a valid stock code
                         TBo := Is_FullStkCode(StockCode);

                         // For non-stock line check whether to include description type stock
                         If (Not TBO) And PickListShowDescOnly Then
                         Begin
                           TBo := (KitLink = 0);
                         End; // If (Not TBO) And PickListShowDescOnly

                         // Check whether Additional Description Lines should be shown
                         If (Not TBO) And PickListDescLines Then
                         Begin
                           If (Not PickListShowDescOnly) Then
                             TBo := (KitLink <> 0) And (KitLink <> Id.FolioRef)
                           Else
                             TBo := (KitLink <> 0);
                         End; // If (Not TBO) And PickListDescLines
                       End; //  If TBo
    *****)

(**** Pre 04/09/06 version
                       // Check to see whether additional description lines should be included or not
                       If PickListDescLines Then
                       Begin
                                // Check the line is for the correct Picking List Run
                                // MH 04/09/06: Modified to include new lines if flag turned on
                         TBo := ((SOPLineNo=Inv.PickRunNo) Or (PickListInclNewLines And (Id.SOPLineNo=0)))
                                And
                                (
                                  // Check the Stock Code is set
                                  (Is_FullStkCode(StockCode))
                                  Or
                                  // Check the the KitLink is non-zero indicating an additional description line
                                  (KitLink <> 0)
                                )
                                And
                                // Hide Free Issue Stock on Works Orders
                                (
                                  (IdDocHed <> WOR)
                                  Or
                                  (Not SSDUseLine)
                                );
                       End // If PickListDescLines
                       Else
                       Begin
                         // Use the old way - Matching picking Run, and Product type, ignore blank or desc only lines *}
                         // MH 04/09/06: Modified to include new lines if flag turned on
                         TBo:=(((SOPLineNo=Inv.PickRunNo) Or (PickListInclNewLines And (Id.SOPLineNo=0))) And
                              (Stock.StockType In StkProdSet + [StkDescCode]) And
                              ((Is_FullStkCode(StockCode)) or
                              ((Mode=fmPickLstSngl) and (KitLink=0)))) And
                              // HM 04/09/02: Modified to hide Free Issue Stock on Works Orders
                              ((IdDocHed <> WOR) Or (Not SSDUseLine));
                       End; // Else
                     End; // With Id
****)
  {$ENDIF}

  {$IFDEF PF_On}
    fmJCBackingSh  : With JobDetl^.JobActual do
                       TBo := Posted and (InvRef = TInv^.OurRef);
  {$ENDIF}

    // MH 19/09/2014 Order Payments: Added support for printing VAT Receipts
    fmOrdPayVATReceipt : TBO := True;  // Checks already performed when data read in Batch_NextDataRow
  end; {Case..}

  Status:=OldStat;

  Result := TBO;
End; {Func..}



{ Returns the key for the driving file defined by the mode }
function TForm_PrintPCC.SetDCheckKey : Str255;
Var
  DumStr  :  Str255;
Begin
  DumStr:='';

  If Assigned (CurrJob) Then Begin
    Case CurrJob.PrintBatch.pbDefMode of
      fmAllDocs,
      fmNomTxfr,
      fmStockAdj,
      fmTimeSheet : With Id do
                      DumStr:=FullIdKey(FolioRef,LineNo);
      fmRemitAdv  : With Password.MatchPayRec do
                      DumStr:=FullMatchKey(MatchTCode,MatchSCode,PayRef);
      fmStatemLay,
      fmDebtChaseL,
      fmTradeHist{,
      fmStateAgeMnth} : With Inv do
                         DumStr:=FullCustType(CustCode,CustSupp);

      fmStateAgeMnth : If (RepInfo.ShowMonthDoc) Then
                         With RepScr^ do
                             DumStr:=AccessK
                       Else
                         With Inv Do
                           DumStr:=FullCustType(CustCode,CustSupp);

      fmBatchDoc     : With Inv do
                         DumStr:=BatchLink;
      fmAccDets,
      fmStockNote,
      fmJCRec        : With Password do
                         With NotesRec do
                           DumStr:=RecPFix + SubType + NoteNo;

      {$IFDEF STK}
        {$IFDEF PF_On}
          fmStockRec    : With Password do
                            With BillMatRec do
                              DumStr:=Strip('R',[#32],FullMatchKey(RecPFix,SubType,StockLink));
          fmPickLstCons,
          fmDocSerialNo  : With RepScr^ do Begin
                             DumStr:=AccessK;
                           end;

          fmPickListBins,
          fmPickListConsBins : With ScratchFileRec^ Do
                                 If (CurrJob.PrintBatch.pbTablKPath = 0) Then
                                   DumStr := FullNomKey(scProcessId) + scSortKey1
                                 Else
                                   DumStr := FullNomKey(scProcessId) + scSortKey2;

          fmPickLstSngl  : With Id do
                             DumStr:=FullIdKey(FolioRef,ABSLineNo);
        {$ENDIF}
      {$ENDIF}

      {$IFDEF PF_On}
        fmJCBackingSh  : With JobDetl^,JobActual do
                           DumStr:=PartCCKey(RecPFix,SubType)+JobCode+Chr(Ord(Posted));
      {$ENDIF}

      fmCISVoucher     : With Password, MatchPayRec Do
                           DumStr := RecPFix + SubType + PayRef;
    end; {Case..}
  End; { If }

  Result := DumStr;
End;


Procedure TForm_PrintPCC.Consol_Pick(    Mode, Fnum, Keypath : Integer;
                                     Var KeyS                : Str255);
Var
  KeyRef  : Str255;
  RepSCRO : ScratchPtr;
Begin { Consol_Pick }
  RepScrO:=RepInfo.RepPtr;

  DefTotals[0]:=0;
  DefTotals[1]:=0;
  DefTotals[2]:=0;
  DefTotals[3]:=0;

  KeyRef:=KeyS;

  While (StatusOk) and (CheckKey(KeyRef,KeyS,Length(KeyRef),BOn)) do
    With Id do Begin

      If (RepScrO<>NIL) then {* Get Id Link *}
        RepScrO^.Get_Scratch(RepScr^);

      If (Include(Mode)) then Begin
        DefTotals[1]:=DefTotals[1]+Qty_OS(Id);

        DefTotals[2]:=DefTotals[2]+QtyPick;

        DefTotals[3]:=DefTotals[3]+(QtyPick*LWeight);

        { HM 27/04/99: Modified to stop range check errors if E in bin-location }
        If (Pos('E',Stock.BinLoc)=0) then
          DefTotals[0]:=DefTotals[0]+DivWChk(QtyPick,RealStr(Strip('B',[#32],Stock.BinLoc)));
      End; { If }

      Status:=Find_Rec(B_GetNext,F[FNum]{DefFVar},Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    End; { With }

  If (StatusOk) then
    Status:=Find_Rec(B_GetPrev,F[FNum]{DefFVar},Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
End;  { Consol_Pick }


{ Prints the top margin }
Procedure TForm_PrintPCC.SetMT;
Var
  n  :  Integer;
Begin
  For n:=1 to MT do
    PrintData(#13#10,False);
End; { SetMT }


{ Processes the line from the .DEF file }
Procedure TForm_PrintPCC.ProcessLn(TextLn : Str255);
Var
  CurrPos,LineLn  :  Byte;
  ProcessCh       :  Char;
Begin
  CurrPos:=1;
  LineLn:=Length(TextLn);

  While (CurrPos<=LineLn) And PrntOk Do Begin
    ProcessCh:=TextLn[CurrPos];

    {Stppout(PrntOk);}

    If (PrntOk) then
      Case ProcessCh of
        FldChr  :  ProcessField(CurrPos,TextLn,LineLn);

        DotChr,
        SpeChr  :  ProcessDot(CurrPos,TextLn,LineLn);

        ^A..^Z  :  ProcessPFx(ProcessCh,CurrPos);
        else       Begin
                     If (PrintLine) then
                       PrintData(ProcessCh,False);

                     Inc(CurrPos);
                   end;
      end; {Case..}
  end; {Loop..}
end; {Proc..}


{ Process Dot Commands as they appear }
Procedure TForm_PrintPCC.ProcessDot(Var CurrPos : Byte;
                                        TextLn  : Str255;
                                        LineLn  : Byte);
Var
  DotL,NextDc,
  UDefVar      :  Str80;
  NoDot        :  Boolean;
  WasCh        :  Char;
Begin
  NoDot:=BOff;

  DotL:='';  NextDc:=''; UDefVar:='';

  WasCh:=TextLn[CurrPos];

  Inc(CurrPos);

  DotL:=UpcaseStr(ExtractWords(1,1,Copy(TextLn,CurrPos,(LineLn-Pred(CurrPos)))));
  NextDc:=UpcaseStr(ExtractWords(2,1,Copy(TextLn,CurrPos,(LineLn-Pred(CurrPos)))));

  UDefVar:=ExtractWords(3,99,Copy(TextLn,CurrPos,(LineLn-Pred(CurrPos))));


  If (DotL=PLDc) then
  Begin
    If (Not InIfSta) or (PrintLine) then
      PL:=IntStr(NextDc);
  end
  else
    If (DotL=PODc) then
      Po:=IntStr(NextDc)
    else
      If (DotL=FFDc) then
        FF:=(NextDc='Y')
      else
        If (DotL=RLDc) then
        Begin
          RL:=(NextDc='Y');
        end
        else
          If (DotL=EsDc) then
            SetEscSec(NextDc)
          else
            If (DotL=CPDc) then
              CP:=(NextDc='Y')
            else
              If (DotL=ERDc) then
              Begin
                ER:=(NextDc='Y');
                RL:=Not ER;
              end
              else
                If (DotL=IFDc) then
                  ProcessIF(NextDc,TextLn)
                else
                  If (DotL=ELDc) then
                  Begin

                    PrintLine:=Not PrintLine;

                    InIFSta:=BOff;

                  end
                  else
                    If (DotL=EFDc) then
                    Begin
                      PrintLine:=BOn;

                      InIFSta:=BOff;
                    end
                    else
                      If (DotL=MTDc) then
                        MT:=IntStr(NextDc)
                      else
                        If (DotL=LADc) then
                          {NoLabsAX:=IntStr(NextDc)}
                        else
                          If (DotL=SVDc) then
                          Begin
                            If (PrintLine) then {* Set variable if condition ok *}
                              StrRec^.fsSVStrs[IntStr(NextDc)]:=UDefVar;
                          end
                          else
                            If (DotL=SNDc) then
                            Begin
                              SNBatch:=IntStr(NextDc);

                              // HM 09/09/03: Modified for Multi-Bin Support
                              //SNMode:=(SNBatch In [1..3,11..13]);
                              SNMode:=(SNBatch In [0..3,10..13]);

                              SNWidth:=IntStr(UDefVar);

                              BinMode := (Pos('BIN', TextLn) > 0);
                              UseByMode := (Pos('USEBY', TextLn) > 0);
                            end
                            else
                              If (DotL=PMDc) then
                              Begin
                                PMType:=IntStr(NextDc);

                                PMMode:=(PMType In [1..2]);
                              end
                              else
                                If (DotL=FaxFont) Then Begin
                                  { Name of Font for faxing PCC forms:- @FXFNT Times New Roman }
                                  JobInfo.jiFontName := ExtractWords(2,99,Copy(TextLn,CurrPos,(LineLn-Pred(CurrPos))));
                                End { If }
                                Else
                                  If (DotL=FaxFontSz) Then Begin
                                    { Size of Font for faxing PCC forms:- @FXSIZ 24 }
                                    JobInfo.jiFontSize := StrToIntDef(NextDc, 9);

                                    If Not (JobInfo.jiFontSize In [6..48]) Then
                                      JobInfo.jiFontSize := 9;
                                  End { If }
                                  Else
                                    // HM 09/09/03: Modified for Multi-Bin Support
                                    If (DotL=BinDc) Then
                                    Begin
                                      BinMode := (NextDc = 'Y');
                                      StkPrioMode := (Pos('STKORD', TextLn) > 0);
                                    End // If (DotL=BinDc)
                                    Else
                                      // HM 14/01/04: Rewrote to optionally include additional description lines within the picking list
                                      If (DotL=DescDc) Then
                                      Begin
                                        PickListDescLines := (NextDc = 'Y');
                                      End // If (DotL=DescDc)
                                      Else If (DotL=DescOnlyDC) Then
                                      Begin
                                        // 'DESCONLY' - Include non-stock/description only lines in single picking lists
                                        PickListShowDescOnly := (NextDc = 'Y');
                                      End // If (DotL=DescOnlyDC)
                                      Else If (DotL=ShowNew) Then
                                      Begin
                                        // 'INCLNEW' - Include TL's with 0 Picking Run Number
                                        PickListInclNewLines := (NextDc = 'Y');
                                      End // If (DotL=ShowNew)
                                      Else If (DotL=ShowHidBom) Then
                                      Begin
                                        // 'SHOWBOM ' - Include Hidden BoM Lines
                                        PickListShowBoM := (NextDc = 'Y');
                                      End // If (DotL=ShowHidBom)
                                      Else
                                        NoDot:=BOn;
  If (NoDot) Then Begin
    If (PrintLine) then
      PrintData(WasCh,False)
  End { If }
  Else
    CurrPos:=CurrPos+(Length(DotL)+Succ(Length(NextDc))+Succ(Length(UDefVar)));

end; {Proc..}


{ ========== Process Pure Escape Codes ========== }
Procedure TForm_PrintPCC.SetEscSec(EscSet  :  Str255);
Var
  n               : Byte;
  ViewEsc, EscStr : Str255;
Begin
  If (OutMethod = 0) Then Begin
    EscSet:=Strip('B',['[',']'],EscSet);

    EscStr:='';

    DELIMChar:=',';

    For n:=1 to WordCnt(EscSet) do
    Begin
      ViewEsc:=ExtractWords(n,1,EscSet);

      If (ViewEsc[1]=EscDel) then
        EscStr:=EscStr+Chr(IntStr(Strip('B',[EscDel],ViewEsc)))
      else
        EscStr:=EscStr+ViewEsc;
    end; {Loop..}

    DELIMChar:=#32;

    If (PrintLine) then
      PrintData(EscStr,False);
  End; { If }
end;


{ Process Print Effects }
Procedure TForm_PrintPCC.ProcessPFx(    ProcessCh : Char;
                                    Var CurrPos   : Byte);
Begin
  If (RepDest <> rdPreview) Then Begin
    If (OutMethod = 0) Then Begin
      With PEFxs do Begin
        OnOff[Ord(ProcessCh)]:=Not OnOff[Ord(ProcessCh)];

        PrintData(Codes[Ord(ProcessCh),OnOff[Ord(ProcessCh)]],False);
      End; {With..}
    End; { If }

    Inc(CurrPos);
  End { If }
  Else Begin
    { Preview Window - leave ^A, ^B, ... codes intact }
    PrintData(ProcessCh, False);
    Inc(CurrPos);
  End; { Else }
end; {Proc..}


{ Process Next Field }
Procedure TForm_PrintPCC.ProcessField(Var CurrPos : Byte;
                                          TextLn  : Str255;
                                          LineLn  : Byte);
Var
  Field  :  Str255;
  Flen   :  Byte;
Begin
  Field:=Strip('B',EfxSet,ExtractWords(1,1,Copy(TextLn,CurrPos,(LineLn-Pred(CurrPos)))));

  Flen:=Length(Field);

  If (PrintLine) then
  Begin

    Field:=GetField(Flen);

    If ((RL) and (Ok2Prnt)) or (Not RL) then
      Flen:=Flen
    else
      Field:='';

    PrintData(LJVar(Field,Flen),False);
  end
  else
    { Called so the .LST file gets processed correctly }
    Field:=GetField(Flen);

  CurrPos:=CurrPos+Flen;
end;


{ Check for any special Justification Switches within line }
Function TForm_PrintPCC.OverRideJustfy(NamLn, GField : Str255) : Str255;
Var
  Justfy  :  Str255;
  OrigLen :  Byte;
Begin
  OrigLen:=Length(GField);

  JustFy:=ExtractWords(2,1,NamLn);

  If (Justfy[1] In JJSet) then
  Begin
    If (Justfy[1]<>XJChar) then
      GField:=Strip('B',[#32],GField);

    Case Justfy[1] of
      LJChar  :  GField:=LJVar(GField,OrigLen);
      RJChar  :  GField:=RJVar(GField,OrigLen);
      CJChar  :  GField:=PadCenter(GField,OrigLen,#32);
    end; {Case..}
  end; {If Modification needed}

  OverRideJustfy:=GField;
end; {Func..}


Function TForm_PrintPCC.GetNoteField(Const NoteField : String) : Str255;
Var
  NoteSrc     : String[2];
  NSrc, NType : Byte;
Begin
  Result := 'Note!';

  { Check we have enough characters: #CUG1 is minimum }
  If (Length(NoteField) > 4) Then Begin
    { Check its a note field }
    If (NoteField[1] = '#') Then Begin
      { Get Note Source }
      NoteSrc := Copy(NoteField, 2, 2);

      NSrc := 255;
      If (NoteSrc = 'CU') Or (NoteSrc = 'SU') Then Begin
        { Customer/Supplier Notes }
        NSrc := 0;
      End { If }
      Else Begin
        If (NoteSrc = 'TH') Then Begin
          { Invoice Notes }
          NSrc := 1;
        End { If }
        Else Begin
          If (NoteSrc = 'ST') Then Begin
            { Stock Notes }
            NSrc := 2;
          End; { If }
        End; { Else }
      End; { Else }

      { Check we have a valid source }
      If (NSrc <> 255) Then Begin
        { Extract Type }
        Case NoteField[4] Of
          'D' : NType := 2;
          'G' : NType := 1;
        Else
          NType := 0;
        End; { Case }

        { Check we have a valid type }
        If (NType > 0) Then Begin
          { Get note line number }
          Result := GetNoteNo (NSrc, NType, Copy(NoteField, 5, 3));
        End; { If }
      End; { If }
    End; { If }
  End; { If }
End;


{ Function to Return next value }
Function TForm_PrintPCC.GetField(Flen  :  Byte)  :  Str255;
Var
  NamLn, Field  :  Str255;
  Justify,
  SNoDecs   :  Str80;
  FieldCtrl :  FieldCtrlType;
  Decs      : SmallInt;
Begin
  NamLn:='';

  Blank(FieldCtrl,Sizeof(FieldCtrl));

  SNoDecs:='';

  If (Not EOF(NamFile)) then
    With FieldCtrl do Begin
      UFlen:=Flen;

      ReadLn(NamFile,NamLn);

      { HM 17/07/98: Modified so that fields aren't calculated whilst they are }
      {              not being printed. Required so SYSINCCQ and SYSUPDCQ work }
      {              correctly on remittance advices.                          }
      If PrintLine Then Begin
        { HM 26/04/99: Added support for PCC Functions }
        If (NamLn[1] <> '!') Then Begin
          { Extract the data dictionary field code }
          Field:=LJVAR(Strip('B',[VARChr],ExtractWords(1,1,NamLn)),8);

          { Extract any justification }
          Justify:=ExtractWords(2,1,NamLn);
          If Not (Justify[1] In JJSet) Then Begin
            Justify := #32;
          End; { If }

          If (NamLn[1] = '#') Then Begin
            { Note Field }
            Field := GetNoteField(UpperCase(NamLn));
          End { If }
          Else Begin
            { extract any decimal places }
            SNoDecs:=ExtractWords(3,1,NamLn);
            If Not (SNoDecs[1] In ['0'..'9']) Then Begin
              { Invalid Decimal Palaces specified }
              Decs := -1
            End { If }
            Else
              { Valid Decs specified }
              Decs:=IntStr(SNoDecs[1]);

            { Convert DD name to actual data value }
            Field := GetFieldText(Field,Decs,Justify,Flen).StrResult;
          End; { Else }
        End { If (NamLn[1] <> '!') }
        Else Begin
          { PCC Functions }
          Case UpperCase(NamLn[2])[1] Of
            { Currency Aging }
            'A'  : DoCcyAgeingFunc (NamLn, Field, Justify, FLen);

            { Currency Conversion function }
            'X'  : DoCcyConvFunc (NamLn, Field, Justify, FLen);

            // HM 10/01/03: Added substring support for CIS Vouchers
            'S'  : DoSubstringFunc (NamLn, Field, Justify, FLen);

            { ... }
          Else
            { Unknown - return blank }
            Field := '';
          End; { Case }
        End; { Else }

        { Justify and pad }
        If (Justify[1] In JJSet) then Begin
          { HM 10/11/97: Was removing the padding space on the end of positive reals }
          {If (Justify[1]<>XJChar) then
            Field:=Strip('B',[#32],Field);}

          Case Justify[1] of
            LJChar : Field:=LJVar(Field,FLen);
            RJChar : Field:=RJVar(Field,FLen);
            CJChar : Field:=PadCenter(Field,FLen,#32);
          End; { Case }
        End { If }
        Else
          { Left justify - if none specified }
          Field:=LJVar(Field,FLen);
      End { If }
      Else
        { Not printing fields at the moment }
        Field := '';

      GetField := Field;
    End
    Else
       GetField:='';
end; {Func..}


{ Returns a string containing the text for the field }
Function TForm_PrintPCC.GetFieldText (Const ShortCode : String10;
                                            TheDecs   : SmallInt;
                                      Var   Justify   : ShortString;
                                      Const FieldLen  : SmallInt) : ResultValueType;
Var
  DictLink   : DictLinkType;
  DataRec    : DataDictRec;
  FieldMask  : Str255;
  SourceFile : Integer;
  TmpDriveFile : Integer;
  BlankZero  : Boolean;
Begin
  Result.StrResult := '';
  Result.DblResult := 0.00;

  { Get Dictionary Record }
  If GetDDField (UpperCase(ShortCode), DictRec^) Then Begin
    If Not TestMode Then Begin
      With DictLink Do Begin
        DCr  := 0;
        DPr  := 99;
        DYr  := 149;
      End; { With }

      If (TheDecs = -1) Then Begin
        { Get Decimals from dictionary record }
        Case DictRec^.DataVarRec.VarDecType of
          1 : TheDecs := Syss.NoCosDec;
          2 : TheDecs := Syss.NoNetDec;
          3 : TheDecs := Syss.NoQtyDec;
        Else
          TheDecs := DictRec^.DataVarRec.VarNoDec;
        End; {Case..}
      End; { If }

      If (Trim(Justify) <> '') Then Begin
        BlankZero := (Pos('B', Justify) <> 0);
      End { If }
      Else Begin
        { Invalid Justification - set default values }
        BlankZero := False;

        If (DictRec^.DataVarRec.VarType In [2, 3, 6, 7, 8]) Then
          Justify := 'R'
        Else
          Justify := 'L';
      End; { Else }

      { Need to pass in a Report Writer file number for some of }
      { the relational linking. Otherwise it will be looking at }
      { the wrong record and give us rubbish                    }
      Case FormPurpose Of
        fmDocSerialNo     : Begin
                              TmpDriveFile := IDetailF;
                              SourceFile := 4; { Report Writer Document Details }
                            End;
        fmStateAgeMnth    : Begin
                              TmpDriveFile := InvF;
                              SourceFile := 3; { Report Writer Document Header }
                            End;
      Else
        TmpDriveFile := DrivingFile;
        If (TmpDriveFile = IDetailF) Then
          SourceFile := 4
        else
          SourceFile := 0;
      End; { Else }

      { Get field value from database - in string format }
      DDosMode := True;
      Result.StrResult := Link_Dict(DictRec^.DataVarRec.VarNo,
                                    DictLink,
                                    StrRec^,
                                    FieldLen,
                                    TmpDriveFile,
                                    SourceFile,
                                    '');

      { Reformat according to type }
      Case DictRec^.DataVarRec.VarType Of
        { String }
        1       : Begin
                    If IsNumFormat(Result.StrResult) Then Begin
                      { Return numerical value, if any, as well }
                      Result.DblResult := DoubleStr(Result.StrResult);
                      Result.DblResult := Round_Up(Result.DblResult, TheDecs);
                    End { If }
                    Else
                      Result.DblResult := 0.0;
                  End;
        { Real, Double }
        2, 3    : Begin
                    { Get value of field from string }
                    Result.DblResult := DoubleStr(Result.StrResult);
                    Result.DblResult := Round_Up(Result.DblResult, TheDecs);

                    If BlankZero And (Result.DblResult = 0.0) Then
                      { Blank if value is 0 }
                      Result.StrResult := ''
                    Else Begin
                      { Generate a new mask with the correct decimals }
                      FieldMask := FormatDecStrSD (TheDecs, GenRealMask, BOff);

                      { reformat field into what it should look like }
                      Result.StrResult := FormatFloat (FieldMask, Result.DblResult);
                    End; { If }
                  End; { With }

        { Date }
        4       : If (Result.StrResult <> '') Then
                    Result.StrResult := POutDate(Result.StrResult);

        { Char }
        5       : { Its already a string} ;

        { Longint, Integer, Byte }
        6, 7, 8 : Begin
                    { String format OK - just get value }
                    Result.DblResult := IntStr(Result.StrResult);

                    If BlankZero And (Result.DblResult = 0.0) Then
                      { Blank if value is 0 }
                      Result.StrResult := '';
                  End;

        { Currency }   { MH 09/12/96 - Unnecessary. maybe! }
        {9       : Begin
                    Result.StrResult := SSymb(IntStr(Result.StrResult));
                  End;}

        { Period }
        10      : { no action required };

        { Yes/No }
        11      : { no action required };

        { Time }
        12      : { no action required };
      End; { Case }

      { Trim except for Floating Point numbers }
      If (DictRec^.DataVarRec.VarType In [2, 3]) Then
        Result.StrResult := TrimLeft(Result.StrResult)
      Else
        Result.StrResult := Trim(Result.StrResult);
    End { If }
    Else Begin
      { Test Mode - Print 9's for numbers and X's for strings }
      For SourceFile := 1 To FieldLen Do
        If (DictRec^.DataVarRec.VarType In [2, 3, 6, 7, 8]) Then
          { Real, Double, Longint, Integer, Byte }
          Result.StrResult := Result.StrResult + '9'
        Else
          { String, Char, Currency }
          Result.StrResult := Result.StrResult + 'X';
    End; { Else }
  End { If }
  Else
    Result.StrResult := 'Error!';
End;


{ Process an If Dot Command }
Procedure TForm_PrintPCC.ProcessIf(Var FieldNam : Str80;
                                       TextLn   : Str255);
Var
  FieldVal   : Str255;
  FieldCtrl  : FieldCtrlType;
  Chk,ChkTyp : Str5;
  ChkVal     :  Str80;
  CTyp       :  Char;
  R1,R2      :  Real;
  Eq,NotEq,
  GT,LT      :  Boolean;
  Just       : String[1];
  DDCode     : String[8];
Begin
  R1:=0; R2:=0;

  Chk:=''; Blank(ChkTyp,Sizeof(ChkTyp)); ChkVal:='';

  Blank(FieldCtrl,Sizeof(FieldCtrl));

  FieldCtrl.UFLen:=Length(FieldNam);

  Eq:=BOff; NotEq:=BOff; GT:=BOff; LT:=BOff;

  {FieldVal:=SetField(SetNextNam(FieldNam),FieldCtrl);}
  Just := 'L';
  DDCode := LJVAR(Trim(UpperCase(Copy(FieldNam, 2, 8))),8);
  FieldVal := GetFieldText (DDCode, 11, Just, 20).StrResult;

  InIFSta:=BOn;

  { Get operator }
  Chk:=ExtractWords(3,1,TextLn);

  { Get check type (N)umerical or (S)tring }
  ChkTyp:=ExtractWords(4,1,TextLn);

  CTyp:=ChkTyp[1];

  If (FieldVal<>'') Or (CTyp=NumPfx) then Begin
    { Get value to chak against }
    ChkVal:=ExtractWords(5,(WordCnt(TextLn)-4),TextLn);

    { Work out which operator to use }
    Eq:=(Chk=EqStr);
    NotEq:=(Chk=NotEqStr);
    GT:=(Chk=GTStr);
    LT:=(Chk=LTStr);

    FieldVal:=Strip('B',[#32,#0],FieldVal);

    ChkVal:=Strip('B',[#32,#0],ChkVal);

    If (CTyp=NumPfx) then
    Begin
      FieldVal:=Form_Real(RealStr(FieldVal),0,11);
      ChkVal:=Form_Real(RealStr(ChkVal),0,11);
    end;

    PrintLine:=((FieldVal=ChkVal) and (Eq)) or
               ((FieldVal<>ChkVal) and (NotEq)) or
               ((FieldVal>ChkVal) and (GT)) or
               ((FieldVal<ChkVal) and (LT));
  end {If Not Blank..}
  Else Begin
    { HM 20/01/99: Added to reset PrintLine if no data in referenced field }
    PrintLine := False;
  End; { Else }

  FieldNam:=FieldNam+(Spc(Length(TextLn)));
end; {Proc..}


{ Intelligently decides where to print the output to }
Procedure TForm_PrintPCC.PrintData(Value: string;PageBreak:Boolean);
Var
  BefPB : LongInt;
Begin
  If (RepDest = rdPrinter) Then
    ReportPrinter1.PrintData(Value)
  Else Begin
    { Make copy of position before page break is written }
    If PageBreak Then
      BefPB := PrnF.Position;

    If (Length(Value) > 0) Then
      PrnF.Write (Value[1], Length(Value));

    If PageBreak Then
      { Add current position (after field) into page list as page start }
      AddPageRef(BefPB, PrnF.Position);
  End; { Else }
End;


{ Adds a page reference object into the pages list }
Procedure TForm_PrintPCC.AddPageRef(BefPBrk, AftPBrk : LongInt);
Var
  PageObj : TPageRef;
Begin
  PageObj := TPageRef.Create;
  With PageObj Do Begin
    PrevPBreak := BefPBrk;
    Position := AftPBrk;
  End; { With }
  PageList.Add(PageObj);
End;


{ Intelligently decides where to print the output to }
Procedure TForm_PrintPCC.Preview(Const PrnInfo  : TSBSPrintSetupInfo);
Var
  Form_PrevPCC : TForm_PrevPCC;
  PreviewMode  : SmallInt;
Begin
  Try
    CreatingPreview := True;
    Form_PrevPCC := TForm_PrevPCC.Create(Application.MainForm);
    CreatingPreview := False;

    { Decide how the previews going to work }
    PreviewMode := 1;
    If (SystemInfo.MainForm.FormStyle = fsMDIForm) Then
      PreviewMode := 2;

    { Setup preview form with printing info }
    Form_PrevPCC.JobInfo := JobInfo;
    Form_PrevPCC.RepHeader := Printer_Def.ResetP + Printer_Def.Plen66;
    Form_PrevPCC.SetPrintInfo(PrnInfo);

    Form_PrevPCC.StartPreview(RepFName, Copies, PageList, PEFxs);

    If (PreviewMode = 1) Then Begin
      { Normal Form show Modally }
      CursorForDialog;
      Form_PrevPCC.ShowModal;
      CursorFromDialog;

      { Form de-allocated automatically by FormClose }

      Form_PrevPCC := NIL;
    End { If }
    Else Begin
      { Form is MDI child - automatically displayed }
      AddPrevWin (TForm(Form_PrevPCC));

      { Reformat for MDI }
      Form_PrevPCC.Position := Forms.poDefault;
      Form_PrevPCC.FormStyle := fsMDIChild;
      Form_PrevPCC.DoMenu;
      Form_PrevPCC.Show;
    End; { Else }
  Except
    On Ex:Exception Do Begin
      MessageDlg ('An error occurred previewing the form',
                  mtError, [mbOk], 0);

      DeletePrintFile (RepFName);
    End; { If }
  End;
End;


{ Used to print when needing multiple copies to a printer }
procedure TForm_PrintPCC.PrintFile(Sender: TObject);
Var
  TempF   : TextFile;
  LineStr : ShortString;
begin
  AssignFile (TempF, RepFName);
  Reset (TempF);

  With Sender As TBaseReport Do Begin
    While Not EOF(TempF) Do Begin
      ReadLn (TempF, LineStr);

      PrintData(LineStr+#13#10);
    End; { While }
  End; { With }

  CloseFile (TempF);
end;


{ Sets the printed status field on transactions }
Procedure TForm_PrintPCC.SetPrintedStatus;
Const
  // HM 26/07/04: Moved to PrntForm as PrintedDocSet to be shared with PrnBatch.Inc
  //PrintDocSet  :  Set of DocTypes  = [SOR,SDN,SIN,SCR,SRI,SRF];
  Fnum         =  InvF;
  Keypath      =  InvOurRefK;
Var
  OInv                    : InvRec;
  TmpStat, TmpKey1        : Integer;
  TmpRecAddr, LAddr       : LongInt;
  KeyS                    : Str255;
  AlsoPicked, LOk, Locked : Boolean;
Begin { SetPrintedStatus }
  With CurrJob.PrintBatch Do Begin
    { Check its printing to printer and we are processing a transaction }
    If (pbMainFnum = InvF) And (RepDest <> rdPreview) Then Begin
      { save position and reload correct invoice - some docs will change Inv to another transaction }
      OInv:=Inv;
      TmpKey1:=GetPosKey;
      TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpRecAddr,BOff,BOff);

      { Link to correct transaction }
      KeyS:=pbMainKRef;
      TmpStat := Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,pbMainKPath,KeyS);

      If (TmpStat = 0) Then Begin
        AlsoPicked := (pbDefMode = 13) Or (pbDefMode = 14);

        { Check its not printed already, or its not picked already, and its the correct document type }
        If ((Not Inv.PrintedDoc) Or (Not Inv.OnPickRun And AlsoPicked)) And (Inv.InvDocHed In PrintedDocSet) Then Begin
          { Get and Lock transaction }
          KeyS := Inv.OurRef;
          LOk := GetMultiRecAddr(B_GetEQ,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked,LAddr);

          If LOk And Locked Then
            With Inv Do Begin
              PrintedDoc:=BOn;

              If (InvDocHed In OrderSet) then
                OnPickRun:=AlsoPicked;

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

              Report_BError(Fnum,Status);

              Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
            End; { With }
        End; { If }
      End; { If }

      { Restore Position }
      TmpStat:=Presrv_BTPos(Fnum,TmpKey1,F[Fnum],TmpRecAddr,BOn,BOff);
      Inv:=OInv;
    End; { If }
  End; { With }
End;  { SetPrintedStatus }

//-------------------------------------------------------------------------

// Currency Amount Conversion Function:-
//
//   !X aaaaaaaa bbbbbbbb c d e
//
//  !X           Function Identifier
//  aaaaaaaa    Amount - Field or Constant
//  bbbbbbbb    From Currency - Field or Constant
//  c           To Currency - Field or Constant
//  d           justification:- L, C, R, B e.g. RB
//  e           decimal places
//
Procedure TForm_PrintPCC.DoCcyConvFunc (Var NamLn, Field : Str255; Var Justify : Str80; Const FLen : Byte);
Var
  FxParam     : Array[1..6] of Str100;
  FieldMask   : Str255;
  Dnum        : Double;
  I, CommaPos : Byte;
  Decs        : SmallInt;
  BlankZero   : Boolean;
Begin { DoCcyConvFunc }
  { Extract Parameters from FULL function string }
  For I := 1 to 5 Do Begin
    { Extract parameter }
    FxParam[I]:=Strip('B',[#32],ExtractWords(Succ(I),1,NamLn));

    { Translate justification and decimals in first pass as needed for second }
    Case I Of
      4 : Begin { Justification }
            If Not (FxParam[I][1] In JJSet) Then Begin
              { Invalid Justification - set default values }
              Justify := 'R';
              BlankZero := False;
            End
            Else Begin
              { Valid justification string }
              Justify := FxParam[I];
              BlankZero := (Pos('B', Justify) <> 0);
            End; { Else }
          End; { Justification }
      5 : Begin { Decimals }
            If Not (FxParam[I][1] In ['0'..'9']) Then Begin
              { Invalid Decimal Palaces specified }
              Decs := -1;
            End { If }
            Else
              { Valid Decs specified }
              Decs:=IntStr(FxParam[I]);
          End; { Decimals }
    End; { Case }
  end;

  For I := 1 to 3 Do Begin
    { Get actual value of referenced field - check not a constant first }
    If (IntStr(FxParam[I]) = 0) And (FxParam[I] <> '0') Then Begin
      { Lookup in data dictionary }
      FxParam[I] := Trim(GetFieldText(FxParam[I],Decs,Justify,Flen).StrResult);

      { Remove any comma's as they screww up RealStr and IntStr }
      CommaPos := Pos (',', FxParam[I]);
      While (CommaPos > 0) Do Begin
        Delete (FxParam[I], CommaPos, 1);
        CommaPos := Pos (',', FxParam[I]);
      End; { While (CommaPos > 0) }
    End; { If (IntStr(FxParam[I]) = 0) And (FxParam[I] <> '0') }
  End; { If (I < 4)  }

  { Convert Amount }
  Dnum:=Currency_ConvFT(RealStr(FxParam[1]),IntStr(FxParam[2]),IntStr(FxParam[3]),UseCoDayRate);

  { Reformat as string }
  If BlankZero And (Dnum = 0.0) Then
    { Blank if value is 0 }
    Field := ''
  Else Begin
    { Generate a new mask with the correct decimals }
    FieldMask := FormatDecStrSD (Decs, GenRealMask, BOff);

    { reformat field into what it should look like }
    Field := FormatFloat (FieldMask, DNum);
  End; { If }
End; { DoCcyConvFunc }

//-------------------------------------------------------------------------

// Currency Ageing Function:-
//
//   !A aaaaaaaa b c d
//
//  !A           Function Identifier
//  aaaaaaaa    Currency - Field or Constant
//  b           Aging Value:- 0=Not Due,1=This Month,2=1 month,3=2 months,4=3 months,5=4+months,6=total OS
//  c           justification:- L, C, R, B e.g. RB
//  d           decimal places
//
Procedure TForm_PrintPCC.DoCcyAgeingFunc (Var NamLn, Field : Str255; Var Justify : Str80; Const FLen : Byte);
Var
  FxParam           : Array[1..6] of Str100;
  FieldMask         : Str255;
  Dnum              : Double;
  I, CommaPos       : Byte;
  Ccy, Decs, AgeVal : SmallInt;
  BlankZero         : Boolean;
Begin { DoCcyAgeingFunc }
  { Extract Parameters from FULL function string }
  For I := 1 to 4 Do Begin
    { Extract parameter }
    FxParam[I]:=Strip('B',[#32],ExtractWords(Succ(I),1,NamLn));

    { Translate justification and decimals in first pass as needed for second }
    Case I Of
      2 : Begin { Ageing Value }
            If Not (FxParam[I][1] In ['0'..'6']) Then Begin
              { Invalid Aging Value specified }
              AgeVal := -1;
            End { If }
            Else
              { Valid Decs specified }
              AgeVal := IntStr(FxParam[I]);
          End; { Ageing Value }

      3 : Begin { Justification }
            If Not (FxParam[I][1] In JJSet) Then Begin
              { Invalid Justification - set default values }
              Justify := 'R';
              BlankZero := False;
            End
            Else Begin
              { Valid justification string }
              Justify := FxParam[I];
              BlankZero := (Pos('B', Justify) <> 0);
            End; { Else }
          End; { Justification }

      4 : Begin { Decimals }
            If Not (FxParam[I][1] In ['0'..'9']) Then Begin
              { Invalid Decimal Palaces specified }
              Decs := -1;
            End { If }
            Else
              { Valid Decs specified }
              Decs:=IntStr(FxParam[I]);
          End; { Decimals }
    End; { Case }
  end;

  { Get actual value of currency field - check not a constant first }
  Ccy := IntStr(FxParam[I]);
  If (Ccy = 0) And (FxParam[I] <> '0') Then Begin
    { Lookup in data dictionary }
    FxParam[I] := Trim(GetFieldText(FxParam[I],Decs,Justify,Flen).StrResult);

    { Convert currency to value }
    Ccy := IntStr(FxParam[I]);
  End; { If (IntStr(FxParam[I]) = 0) And (FxParam[I] <> '0') }

  { Get Aged Value }
  DNum := CurrAged[Ccy]^[AgeVal];

  { Reformat as string }
  If BlankZero And (Dnum = 0.0) Then
    { Blank if value is 0 }
    Field := ''
  Else Begin
    { Generate a new mask with the correct decimals }
    FieldMask := FormatDecStrSD (Decs, GenRealMask, BOff);

    { reformat field into what it should look like }
    Field := FormatFloat (FieldMask, DNum);
  End; { If }
End; { DoCcyAgeingFunc }

//-------------------------------------------------------------------------

// HM 10/01/03: Added substring support for CIS Vouchers
//
//  !S aaaaaaaa bb cc [d] [e]
//
//  !S          Substring Function Identifier
//
//  aaaaaaaa    Data Dictionary Field or Constant
//
//  bb          Starting character from which to copy, if negative then start from
//              right hand side, e.g. -1 = last character
//
//  cc          Number of characters to copy
//
//  [d]         optional justification:- L, C, K, R, B e.g. RB  (K=Kill Komma's)
//
//  [e]         optional decimal places for Real48/Double fields
//
Procedure TForm_PrintPCC.DoSubstringFunc (Var NamLn, Field : Str255; Var Justify : Str80; Const FLen : Byte);
Var
  FxParam                  : Array[1..6] of Str100;
  I                        : Byte;
  CommaPos                 : SmallInt;
  CopyStart, CopyLen, Decs : SmallInt;
  BlankZero, KillComma     : Boolean;
  ErrCode                  : Integer;
  CopyStr                  : AnsiString;
Begin { DoSubstringFunc }
  // Delete Comments from line
  I := Pos ('{', NamLn);
  If (I > 0) Then
    Delete (NamLn, I, Length(NamLn));

  // Extract Parameters from function string
  ErrCode := 0;
  For I := 1 to 5 Do Begin
    { Extract parameter }
    FxParam[I]:=Strip('B',[#32],ExtractWords(Succ(I),1,NamLn));

    Case I Of
      // Data Dictionary Field Name
      1 : ;  { No Validation }

      // Start Position for copy
      2 : Begin
            Val (fxParam[I], CopyStart, ErrCode);
            If (ErrCode <> 0) Then
              CopyStart := -1
            Else
              If (CopyStart = 0) Or (Abs(CopyStart) > 255) Then
                // Invalid Start position - set error status and exit func
                ErrCode := 1;
          End;

      // Length for copy
      3 : Begin
            Val (fxParam[I], CopyLen, ErrCode);
            If (ErrCode <> 0) Then
              CopyLen := -1
            Else
              If (CopyLen <= 0) Or (CopyLen > 255) Then
                // Invalid Length - set error status and exit func
                ErrCode := 1;
          End;

      // Justification
      4 : Begin
            If Not (FxParam[I][1] In JJSet) Then Begin
              { Invalid Justification - set default values }
              Justify := 'L';
              BlankZero := False;
              KillComma := False;
            End
            Else Begin
              { Valid justification string }
              Justify := FxParam[I];
              BlankZero := (Pos('B', Justify) <> 0);
              KillComma := (Pos('K', Justify) <> 0);
            End; { Else }
          End; { Justification }

      // Decimals
      5 : Begin
            If Not (FxParam[I][1] In ['0'..'9']) Then Begin
              { Invalid Decimal Palaces specified }
              Decs := 0;
            End { If }
            Else
              { Valid Decs specified }
              Decs:=IntStr(FxParam[I]);
          End; { Decimals }
    End; { Case I }

    If (ErrCode <> 0) Then Break;
  End; { For I := 1 to 5 }

  If (ErrCode = 0) Then Begin
    // Lookup field in data dictionary
    FxParam[6] := Trim(GetFieldText(FxParam[1],Decs,Justify,Flen).StrResult);

    // Check there is something to copy
    If (FxParam[6] <> '') Then Begin
      // HM 18/03/03: Added ability to remove comma's
      If KillComma Then Begin
        CommaPos := Pos (',', FxParam[6]);
        While (CommaPos > 0) Do Begin
          Delete (FxParam[6], CommaPos, 1);
          CommaPos := Pos (',', FxParam[6]);
        End; { While (CommaPos > 0) }
      End; { If KillComma }

      If (CopyStart > 0) Then
        // Normal forwards copy
        Field := Copy (FxParam[6], CopyStart, CopyLen)
      Else Begin
        // Backwards copy - must prefix with spaces
        CopyStr := StringOfChar (' ', 255) + FxParam[6];

        Field := Copy (CopyStr, Length(CopyStr) - Abs(CopyStart) - CopyLen + 2, CopyLen)
      End; { Else }
    End { If (FxParam[6] <> '') }
    Else
      Field := '';
  End { If (ErrCode = 0) }
  Else
    Field := 'Error!';
End; { DoSubstringFunc }

//-------------------------------------------------------------------------

end.


