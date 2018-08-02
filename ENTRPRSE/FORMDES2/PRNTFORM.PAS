unit PrntForm;

interface

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RPBase, RPCanvas, RPrinter, BtrvU2, BTSupU1, GlobVar, GlobType,
  RPFPrint, RPreview, RPFiler, VarConst, VarFPosU, VarRPosU, TEditVal,
  SBSList, Scrtch1U, ExWrap1U, PrntPrev, RPDefine, RpDevice, Recurse,
  IniFiles, FileCtrl, Registry, ExtCtrls, RPRender, RPRender_PDF, AbBase,
  AbBrowse, AbZBrows, AbZipper, AbZipKit, AbArcTyp, AbUtils, RpMemo,
  RPRender_HTML, ShellAPI, WinSpool, DateUtils,

  // MH 04/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  ContactsManager,
  oFDAccountContacts,

  ScratchF, ScratchO, StrUtils, Math;

{$ALIGN 1}

Const
  PrintedDocSet  :  Set of DocTypes  = [PQU, POR, PDN, PIN, PCR, PPI, PRF, PPY,
                                        SQU, SOR, SDN, SIN, SCR, SRI, SRF];

type
  RepDestType = (rdPrinter, rdPrintFile, rdPreview);

  PrintTextMethodType = (ptmUnknown, ptmDrawText, ptmRAVECommands);

  TGotDataRowEvent = function : Boolean of object;
  TDataColEvent = Function (ColNo : Byte) : String Of Object;
  TNextDataRowEvent = Procedure Of Object;

  ENoUnique = Class (Exception);
  EEmailErr = Class (Exception);

  LabelPosList = Array [1..1000] Of TRect;

  TRenderingUtils = Class (TObject)
  Public
    procedure CompressPDF(InStream, OutStream: TStream; var CompressMethod: String);
  End; { TRenderingUtils }

  TForm_PrintTest = class(TForm)
    ReportPrinter1: TReportPrinter;
    ReportFiler1: TReportFiler;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label_Printing: Label8;
    Label_Page: Label8;
    Label_Destination: Label8;
    Label_FontSize: TLabel;
    FilePrinter1: TFilePrinter;
    Image1: TImage;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    { Form Size Testing Print Routines }
    procedure TestSize_Print(Sender: TObject);
    procedure TestSize_BeforePrint(Sender: TObject);
    { Label Size Testing Print Routines }
    procedure TestLbl_BeforePrint(Sender: TObject);
    procedure TestLbl_Print(Sender: TObject);
    { Form Printing Routines }
    procedure PrintForm_BeforePrint(Sender: TObject);
    procedure PrintForm_PrintHeader(Sender: TObject);
    procedure PrintForm_Print(Sender: TObject);
    procedure PrintForm_PrintFooter(Sender: TObject);
    function  PrintForm_GotDataRow : Boolean;
    Function  PrintForm_DataCol (ColNo : Byte) : String;
    Procedure PrintForm_NextDataRow;
    { Label Printing Routines }
    procedure PrintLabel_BeforePrint(Sender: TObject);
    procedure PrintLabel_Print(Sender: TObject);
    Procedure PrintLabel_AfterPrint(Sender: TObject);
    { Batched Form Printing Routines }
    procedure Batch_BeforePrint(Sender: TObject);
    procedure Batch_AfterPrint(Sender: TObject);
    procedure Batch_PrintHeader(Sender: TObject);
    procedure Batch_PrintFooter(Sender: TObject);
    procedure Batch_Print(Sender: TObject);
    function  Batch_GotDataRow : Boolean;
    Function  Batch_DataCol (ColNo : Byte) : String;
    Procedure Batch_NextDataRow;
    function  Batch_GetModeKey : Str255;
    Procedure Batch_KillScratchObj;
    Procedure Batch_ConsolPick(    Mode, Fnum, Keypath : Integer;
                               Var KeyS                : Str255);
    Function  Include(Mode : Byte; Msgs : Boolean)  :  Boolean;
    Procedure Batch_StartDataRow;
    Procedure SetPrintedStatus;
    { Batched Label Printing Routines }
    procedure BatchLbl_BeforePrint(Sender: TObject);
    procedure BatchLbl_Print(Sender: TObject);
    { General Printing Routines }
    procedure PrnDef_AfterPrint(Sender: TObject);
    procedure PrnDef_BeforePrint(Sender: TObject);
    procedure PrnDef_NewPage(Sender: TObject);
    procedure PrnDef_Print(Sender: TObject);
    procedure PrnDef_PageFooter(Sender: TObject);
    procedure PrnDef_PageHeader(Sender: TObject);
    Procedure PrnDef_StartDataRow;
  private
    { Private declarations }
    HeaderList     : TSBSList;
    BodyHeadList   : TSBSList;
    BodyList       : TSBSList;
    BodyFootList   : TSBSList;
    FooterList     : TSBSList;
    Columns        : TSBSList;
    Formulas       : TSBSList;
    GroupedCtrls   : TSBSList;
    PageNo, JobIdx : Word;
    CurrJob, OrigJob : TPrintBatchObjType;
    FormDefPath    : String;
    RowCount       : Integer; { Number of rows printed in the table }
    LastControlPrinted : Integer;
    RemitDoc       : String10;
    AbortForm, AbortBatch : Boolean;
    DrivingFile    : Integer;
    FormPurpose    : Byte;     { Type of report: required for calling Link_Dict }
    RowError       : Boolean;
    TmpRecAddr     : LongInt; { Used for preserving the row address on the table }
    TotItems       : SmallInt;
    FormWidth      : LongInt;  { Width of current formula field }
    MatchKey       : Boolean;  { Current key matches pbTablKRef }
    ExLocal        : TdExLocal;
    Copies         : SmallInt;
    OutMethod      : Byte;     { 0=Printer, 1=Fax, 2=Email, 3= XML, 4=File }
    OrigMode       : SmallInt; { 17/02/00: Added for Printed Status }

    { Variables added for label processing }
    LblStart, LblRepeat : SmallInt;
    LabelPos       : ^LabelPosList;

    { Recurse Checking Object }
    Recurse        : TRecurseCheck;

    // 18/07/02: Added Bitmap Caching
    Cachelist      : TStringList;

    // HM 11/07/03: Added flag to keep track of continuations for Statement runs
    IsContinuation : Boolean;

    // HM 04/11/04: Added 'Set Printed Status' flag so that Authoris-e can stop FDes from setting the Printed Status on transactions
    bSetPrintedStatus : Boolean;

    // MH 16/03/2009: Added variable to store the last SearchKey for when printing forms
    sLastSearchKey : Str255;

    // MH 16/03/2009: Added variable to store the starting SearchKey to use - used by Single Picking Lists to include -ve line nos
    sStartSearchKey : Str255;

    // MH 04/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
    FContactsManager : TContactsManager;

    Procedure SortDefList (Const DefList : TSBSList);
    Procedure DoFont (TheFont : fdFontDefType);
    Procedure PrintTable (Const TheTable : fdTableRecType);
    Function  WantPrint (Const ControlDef : FormDefRecType) : Boolean;
    Procedure PrintTMControl (Const ControlDef : FormDefRecType; Fill : Boolean);
    Procedure PrintGroup (Const TheGroup : FormDefRecType);
    Procedure PrintFormula (Const TheFormula : fdFormulaRecType);
    Procedure PrintDbField (Const FieldDef : FormDefRecType);
    Procedure PrintPageNo (ThePageNo : fdPageRecType);
    Procedure PrintBox (TheBox : fdBoxRecType);
    Procedure PrintLine (TheLine : fdLineRecType);
    Procedure PrintBitmap (TheBitmap : fdBitmapRecType);
    Procedure PrintText (TheText : fdTextRecType);
    Procedure PrintControl (Const ControlDef : FormDefRecType);
    procedure PrintControlList (Const ControlList : TSBSList);
    procedure PrintRemainingBody;
    procedure PrintFullNonTableBody;
    {Function  IsNumFormat(Const NumStr : ShortString) : Boolean;}
    Function  GetFieldText (Const ShortCode : String10;
                            Const TheDecs   : Byte;
                            Const PixWidth  : LongInt;
                            Const BlankZero : Boolean) : ResultValueType;
    Function  GetFormulaText (Const TheFormula : String;
                              Const TheDecs    : Byte;
                              Const PixWidth   : LongInt;
                              Const BlankZero : Boolean) : ResultValueType;
    Procedure EmptyList (Var TheList : TSBSList; Const FreeObj : Boolean);
    procedure EmptyLists;
    Procedure SendProgress (Const CurrItem : SmallInt;Const Mode : Byte);
    procedure PrintAbort (var Msg: TMessage); message WM_PrintAbort;

    Function  FormatDate (Const DateCode : String10;
                          Const Units    : SmallInt;
                          Const OffUnits : Char;
                          Const Format   : SmallInt) : ResultValueType;

    Function GetCurrRate (Const DateCode : String10;
                          Const Units    : SmallInt;
                          Const OffUnits : Char;
                          Const Format   : SmallInt) : ResultValueType;

    Function GetCurrAgeing (Const CcyCode : String10;
                            Const Ccy     : SmallInt;
                            Const CcyType : Char;
                            Const AgeVal  : SmallInt) : ResultValueType;
    // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
    Function GetLoadRole (Const AcCode : ShortString;
                          Const RoleDesc : ShortString) : ResultValueType;

    { PrnLabel.Inc }
    Procedure BuildLabelPos;
    Procedure PrintLabel_GetNextRec (Const BtrMode : SmallInt);

    Procedure ExtTextRect2 (Const ftText    : ShortString;
                            Const ftJustify : TAlignment;
                            Const ftLeft,
                                  ftTop,
                                  ftWidth,
                                  ftHeight  : Double;
                            Const VCenter   : Boolean = False);
  public
    { Public declarations }
    HeaderRec       : fdHeaderRecType;
    StringRec       : fdFormStringsType;
    RepType         : RepTypeType;
    RepDest         : RepDestType;
    ErrLevel        : Byte;
    TheReport       : TBaseReport;
    GotDataRow      : TGotDataRowEvent;
    GetNextDataRow  : TNextDataRowEvent;
    GetDataColumn   : TDataColEvent;
    StartDataRow    : TNextDataRowEvent;
    ScratchO        : ScratchPtr;
    ScratchFile     : TScratchFile;
    TestMode        : Boolean;
    PrintTextMethod : PrintTextMethodType;
    Procedure InitPrintType (Const ReportType   : RepTypeType;
                             Const PrinterNo    : Integer;
                             Const WantPreview  : Boolean;
                             Const WantCopies   : SmallInt;
                             Const IsTestMode   : Boolean;
                             Const ChequeMode   : Boolean;
                             Const PrnInfo      : TSBSPrintSetupInfo);
    Procedure SetHedRec (Const HedRec : fdHeaderRecType);
    Procedure SetStrRec (Const StrRec : fdFormStringsType);
    Procedure SetLabelInfo (Const PrnLabel, NoLabels : LongInt);
    Procedure SetControlList (Const DefList : TSBSList);
    Procedure SetOrientation (Const Orient : fdOrientationType);

    Procedure PrintReport (Const WinTitle : ShortString;
                                 PrnInfo  : TSBSPrintSetupInfo);

    { Events called by Parser }
    Function  GetDBFEvent (Const FieldCode : String;
                           Const Decs      : Byte) : ResultValueType;
    Function  GetFMLEvent (Const FieldCode : String;
                           Const Decs      : Byte) : ResultValueType;
    Function  GetTBCEvent (Const FieldCode : String;
                           Const Decs      : Byte) : ResultValueType;
    Function  GetTRWEvent (Const FieldCode : String;
                           Const Decs      : Byte) : ResultValueType;
    Function  GetTBPEvent (Const FieldCode : String;
                           Const Decs      : Byte) : ResultValueType;
    Function  GetTBTEvent (Const FieldCode : String;
                           Const Decs      : Byte) : ResultValueType;
    Function  GetDocSign : SmallInt;
    Function  GetCustNote (Const NoteNo   : String;
                           Const NoteType : Char) : String;
    Function  GetSuppNote (Const NoteNo   : String;
                           Const NoteType : Char) : String;
    Function  GetInvNote  (Const NoteNo   : String;
                           Const NoteType : Char) : String;
    Function  GetStockNote(Const NoteNo   : String;
                           Const NoteType : Char) : String;
    Function  GetSNoNote  (Const NoteNo   : String;
                           Const NoteType : Char) : String;
    Function  GetJobNote  (Const NoteNo   : String;
                           Const NoteType : Char) : String;

    Function  GetPageNo : SmallInt;
    Function  GetIdQtyNo : ResultValueType;
  end;

  Procedure AddPrevWin (Var TheForm : TForm);
  Procedure FreePrevWins; Export;
  Function NumPrevWins : LongInt; Export;
  Procedure NFClosePrevWindows; Export;

  Procedure FreeFormHandle (Const FormHandle : HWnd); Export;
  Procedure PreviewPrintFile (Const PrnInfo             : TSBSPrintSetupInfo;
                              Const PrintFile, WinTitle : ShortString); Export;
  Procedure PrintFileTo (Const PrnInfo             : TSBSPrintSetupInfo;
                         Const PrintFile, WinTitle : ShortString); Export;

  // CJS 2015-01-16 - ABSEXCH-16032 - temporary file error on closing VAT Return
  Procedure PrintFileToEx  (Const PrnInfo             : TSBSPrintSetupInfo;
                            Const PrintFile, WinTitle : ShortString;
                            Const DeleteFileAfterPrint: Boolean); Export;
  Function PrintInCreate : Boolean; Export;
  Function  IsNumFormat(Const NumStr : ShortString) : Boolean;

  Procedure SendMAPIFax (Const PrnInfo : TSBSPrintSetupInfo;
                         Const FName   : ShortString);

  Procedure SendEmailFile2 (Const PrnInfo     : TSBSPrintSetupInfo;
                            Const FilePrinter : TFilePrinter;
                            Const FName       : ShortString;
                            Const DelFile     : Boolean);
  Procedure SendEmailFile (Const PrnInfo : TSBSPrintSetupInfo;
                            Const FilePrinter : TFilePrinter;
                           Const FName       : ShortString);
  Procedure SendEntFax (Const PrnInfo : TSBSPrintSetupInfo;
                        Const FilePrinter : TFilePrinter;
                        Const FName       : ShortString;
                        Const EntFaxing   : Boolean);

  // HM 12/08/03: Converts an EDF file to an XLS File - called by Preview Window
  Procedure ConvertEDFToXLS (Const EDFPath, XLSPath : ShortString; Const AutoOpen : Boolean);

  // HM 22/03/04: Converts an EDF file to an HTML File - called by Preview Window
  Procedure ConvertEDFToHTML (Const EDFPath, HTMLPath : ShortString; Const AutoOpen : Boolean);

  //PR: 13/05/2011 Added new function to enable SentForm.dll to raise an exception rather than display a message ABSEXCH-11343
  function DoMessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;

var
  Form_PrintTest : TForm_PrintTest;
  {PreviewForms   : TSBSList;}
  CreatingPreview : Boolean;
  ForceDemoVer    : Boolean = False;
{$IFDEF FORMTK}  { Exchequer form Printing Toolkit }
  // NOTE: Variables have been declared here globally to eliminate any dependancy
  //       on forms that are part of the Form Printing Toolkit.
  FTKPreviewHandle : THandle;
  FTKPreviewMode   : Byte = 0;
{$ENDIF}
  // HM 14/10/02: Moved from implementation section to allow global access
  WantPDFCompression : Boolean = True;

implementation

{$R *.DFM}

Uses DataDict, DicLinkU, DicLnk2U, FormUtil, PrintU, FirstU,
     TablFunc, ETMiscU, ETDateU, Parser, ETStrU, SerialNo,
     CurrncyU, SBSFuncs, Register, BtKeys1U, ComnU2, NoteSupU,
     InvListU, DocSupU1, SysU1, SysU2, ComnUnit, FormFile,
     VarRec2U, CommsInt, BTSupU2, APIUtil, DocSort, ZLib,
     HIBC, FileUtil, BinData, VAOUtil, EntLicence, PickListUtil,
     CustomFieldsIntf,
     // MH 16/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
     OPVATPaySingleton, oOPVATPayBtrieveFile,
     {$IFDEF FORMTK}
     LogUtil,
     {$ENDIF}
     // MH 16/02/2017 2017-R1 ABSEXCH-14925: Added MadExcept Logging
     MadExcept,
     // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
     ImageConversionFuncs
     ;

{$I VarRecRp.Pas}

Var
  PreviewForms       : TSBSList;
  {CreatingPreview    : Boolean;}
  PFListLocked       : Boolean;


{ Barcode conversion functions }
Function BC_OCode39(BarString : PChar;
                    BasicFull : integer;
                    CheckChar : integer) : PChar; stdcall; external 'bcfont32.dll';
function BC_Code128(barstring : PChar) : PChar; stdcall; external 'bcfont32.dll';
{function BC_OCode128(barstring      : PChar;
                     Fnc1,Fnc2,Fnc3 : Integer) : PChar; stdcall; external 'bcfont32.dll';}
function BC_OInter25(barstring : PChar;
                     CheckChar : Integer) : PChar; stdcall; external 'bcfont32.dll';
function BC_Codabar(barstring : PChar) : PChar; stdcall; external 'bcfont32.dll';
{function BC_OCodabar(barstring                    : PChar;
                     StartCode,StopCode,CheckChar : Integer) : PChar; stdcall; external 'bcfont32.dll';}
function BC_PostNet(barstring : PChar) : PChar; stdcall; external 'bcfont32.dll';
function BC_UPCA(barstring : PChar) : PChar; stdcall; external 'bcfont32.dll';
function BC_UPCE(barstring : PChar) : PChar; stdcall; external 'bcfont32.dll';
function BC_EAN13(barstring : PChar) : PChar; stdcall; external 'bcfont32.dll';
function BC_EAN8(barstring : PChar) : PChar; stdcall; external 'bcfont32.dll';

//PR: 02/09/2016 ABSEXCH-17604 Function to output debug from COM Toolkit printing only
procedure DebugOut(const Msg : string);
begin
  {$IFDEF FormTK}
   OutputDebug(Msg);
  {$ENDIF}
end;

{************************************************************************}
{* IsNumFormat: Returns True if the string can be converted to a number *}
{************************************************************************}
Function IsNumFormat(Const NumStr : ShortString) : Boolean;
Var
  I : SmallInt;
Begin
  Result := False;

  If (Length(NumStr) > 0) Then Begin
    Result := True;

    For I := 1 To Length(NumStr) Do
      If Not (NumStr[I] In ['.', ',', '+', '-', '0'..'9']) Then Begin
        { Invalid Character }
        Result := False;
        Break;
      End; { If }
  End; { If }
End;


procedure TForm_PrintTest.FormCreate(Sender: TObject);
begin
  New (LabelPos);

  RepType  :=  GlobType.rtNone;
  ErrLevel := 0;
  ScratchO := Nil;
  ExLocal.Create;

  {FontCanvas := TCanvas.Create;}
  DictCanvas := Label_FontSize;

  HeaderList   := TSBSList.CreateList ('Header');
  BodyHeadList := TSBSList.CreateList ('BodyHead');
  BodyList     := TSBSList.CreateList ('Body');
  BodyFootList := TSBSList.CreateList ('BodyFoot');
  FooterList   := TSBSList.CreateList ('Footer');
  Columns      := TSBSList.CreateList ('Columns');
  Formulas     := TSBSList.CreateList ('Formulas');
  GroupedCtrls := TSBSList.CreateList ('Grouped');

  { Initialise records }
  FillChar (HeaderRec, SizeOf (HeaderRec), #0);
  FillChar (StringRec, SizeOf (StringRec), #0);

  { Register window with Exchequer for abort messages }
  SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, 2, Handle);

  Recurse := TRecurseCheck.Create;

  PrintTextMethod := ptmUnknown;

  // 18/07/02: Added Bitmap Caching
  Cachelist := TStringList.Create;

  // HM 04/11/04: Added 'Set Printed Status' flag so that Authoris-e can stop
  // FDes from setting the Printed Status on transactions, default to setting it
  bSetPrintedStatus := True;
end;


Procedure TForm_PrintTest.EmptyList (Var TheList : TSBSList; Const FreeObj : Boolean);
Var
  ListObj : TFormDefListObjType;
begin
  While (TheList.Count > 0) Do Begin
    { Take copy of object }
    If FreeObj Then ListObj := TFormDefListObjType(TheList.Items[0]);

    { Remove object from list }
    TheList.Delete (0);

    { Deallocate object }
    If FreeObj Then ListObj.Free;
  End; { While }
end;

procedure TForm_PrintTest.EmptyLists;
begin
  EmptyList (HeaderList, True);
  EmptyList (BodyHeadList, True);
  EmptyList (BodyList, True);
  EmptyList (BodyFootList, True);
  EmptyList (FooterList, True);
  EmptyList (Columns, True);
  EmptyList (Formulas, False);
  EmptyList (GroupedCtrls, False);
end;

procedure TForm_PrintTest.FormDestroy(Sender: TObject);
begin
  Recurse.Free;

  SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, 2, 0);

  // MH 04/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  If Assigned(FContactsManager) Then
    FreeAndNIL(FContactsManager);

  EmptyLists;
  HeaderList.Free;
  BodyHeadList.Free;
  BodyList.Free;
  BodyFootList.Free;
  FooterList.Free;
  Columns.Free;
  Formulas.Free;   { only contains duplicate objects - now need to empty the list }

  ExLocal.Destroy;

  DictCanvas := Nil;
  {FontCanvas.Free;}

  Dispose (LabelPos);

  // 18/07/02: Added Bitmap Caching
  FreeAndNIL(Cachelist);
end;

{ starts the printing when the form is shown }
procedure TForm_PrintTest.FormActivate(Sender: TObject);
begin
  ErrLevel := 0;

  Try
    PageNo := 0;
    TheReport.Execute;
    PostMessage (Handle, WM_Close, 0, 0);    { only way to automatically close the window on completion }
  Except
    On EStreamError Do
      {ShowMessage ('Stream Exception')} ErrLevel := 1
    Else
      {ShowMessage ('Unknown Exception');} ErrLevel := 2;
  End;
end;

procedure TForm_PrintTest.PrintAbort (var Msg: TMessage);
begin
  If (MessageDlg ('Are you sure you want to abort the batch currently being printed', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
    AbortBatch := True;
end;

{************************************************************************}
{* Form Size Testing Print Routines:                                    *}
{*                                                                      *}
{*          procedure TestSize_BeforePrint(Sender: TObject);            *}
{*          procedure TestSize_Print(Sender: TObject);                  *}
{*                                                                      *}
{************************************************************************}
{$I PRNFTEST.INC}


{************************************************************************}
{* Label Size Testing Print Routines:                                   *}
{*                                                                      *}
{*          procedure TestLbl_BeforePrint(Sender: TObject);             *}
{*          procedure TestLbl_Print(Sender: TObject);                   *}
{*                                                                      *}
{************************************************************************}
{$I PRNLTEST.INC}


{************************************************************************}
{* Form Printing Routines:                                              *}
{*                                                                      *}
{*          procedure PrintForm_BeforePrint(Sender: TObject);           *)
{*          procedure PrintForm_PrintHeader(Sender: TObject);           *}
{*          procedure PrintForm_Print(Sender: TObject);                 *}
{*          procedure PrintForm_PrintFooter(Sender: TObject);           *}
{*          function PrintForm_GotDataRow : Boolean;                    *}
{*          Function PrintForm_DataCol (ColNo : Byte) : String;         *}
{*          Procedure PrintForm_NextDataRow;                            *}
{*                                                                      *}
{************************************************************************}
{$I PRNFORM.INC}


{************************************************************************}
{* Label Printing Routines:                                             *}
{*                                                                      *}
{*          procedure PrintLabel_BeforePrint(Sender: TObject);          *)
{*          procedure PrintLabel_Print(Sender: TObject);                *}
{*          Procedure PrintLabel_GetNextRec (Const BtrMode : SmallInt); *}
{*          Procedure BuildLabelPos;                                    *}
{*          Procedure PrintLabel_AfterPrint(Sender: TObject);           *}
{*                                                                      *}
{************************************************************************}
{$I PRNLABEL.INC}


{************************************************************************}
{* Batched Form Printing Routines:                                      *}
{*                                                                      *}
{*          procedure Batch_BeforePrint(Sender: TObject);               *}
{*          procedure Batch_AfterPrint(Sender: TObject);                *}
{*          procedure Batch_PrintHeader(Sender: TObject);               *}
{*          procedure Batch_PrintFooter(Sender: TObject);               *}
{*          procedure Batch_Print(Sender: TObject);                     *}
{*          function  Batch_GotDataRow : Boolean;                       *}
{*          Function  Batch_DataCol (ColNo : Byte) : String;            *}
{*          Procedure Batch_NextDataRow;                                *}
{*          function  Batch_GetModeKey : Str255;                        *}
{*                                                                      *}
{************************************************************************}
{$I PRNBATCH.INC}


{************************************************************************}
{* Batched Label Printing Routines:                                     *}
{*                                                                      *}
{*          procedure BatchLbl_BeforePrint(Sender: TObject);            *)
{*          procedure BatchLbl_Print(Sender: TObject);                  *)
{*                                                                      *}
{************************************************************************}
{$I PRNBATLB.INC}


{********************************************************************}
{* GetFieldText: Returns a string containing the text for the field *}
{********************************************************************}
Function TForm_PrintTest.GetFieldText (Const ShortCode : String10;
                                       Const TheDecs   : Byte;
                                       Const PixWidth  : LongInt;
                                       Const BlankZero : Boolean) : ResultValueType;
Var
  DictLink     : DictLinkType;
  FieldMask    : Str255;
  SourceFile   : Integer;
  TmpDriveFile : Integer;
Begin
{DBug.MsgI (0, 'GetFieldText: ' + ShortCode, 3);}
  Result.StrResult := '';
  Result.DblResult := 0.00;

  { Get Dictionary Record }
  If GetDDField (UpperCase(ShortCode), DictRec^) Then Begin
    With DictLink Do Begin
      DCr  := 0;
      DPr  := 99;
      DYr  := 149;
    End; { With }

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
      // HM 15/02/01: Added support ADJ Hidden lines and Sorting turned on
      fmADJSort         : Begin
                            TmpDriveFile := IdetailF;
                            SourceFile := 4; { Report Writer Document Details }
                          End;
      // HM 15/02/01: Added support for sorting Transaction Lines
      fmTransSort       : Begin
                            TmpDriveFile := IdetailF;
                            SourceFile := 4; { Report Writer Document Details }
                          End;
      // HM 08/01/03: Added CIS Voucher support
      fmCISVoucher      : Begin
                            TmpDriveFile := JdetlF;
                            SourceFile := TmpDriveFile;
                          End;
      // MH 09/03/2010: Added sorted picking list support
      // Sorted Single Picking List - No Bins & No Serial/Batch
      fmSortedPickingList,
      // Sorted Consolidated Picking List - No Bins & No Serial/Batch
      fmSortedConsPickingList : Begin
                                  TmpDriveFile := IdetailF;
                                  SourceFile := 4; { Report Writer Document Details }
                                End;
    Else
      TmpDriveFile := DrivingFile;
      If (TmpDriveFile = IDetailF) Then
        SourceFile := 4
      else
        SourceFile := 0;
    End; { Else }

    { Get field value from database - in string format }
    DDosMode := False;
    Result.StrResult := Link_Dict(DictRec^.DataVarRec.VarNo,
                                  DictLink,
                                  StringRec,
                                  PixWidth,
                                  TmpDriveFile{DrivingFile},
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
  End { If }
  Else
    Result.StrResult := 'Error!';
{DBug.Msg (0, 'StrResult: ' + Result.StrResult);
DBug.Msg (0, 'DblResult: ' + FloatToStr(Result.DblResult));
DBug.Indent (-3);}
End;


{************************************************************************}
{* GetFormulaText: Returns a string containing the text for the formula *}
{************************************************************************}
Function TForm_PrintTest.GetFormulaText (Const TheFormula : String;
                                         Const TheDecs    : Byte;
                                         Const PixWidth   : LongInt;
                                         Const BlankZero  : Boolean) : ResultValueType;
Var
  ParserObj : TParserObj;
  IVType    : Byte;
  TmpStr    : ShortString;
Begin
{DBug.MsgI (0, 'GetFormulaText: ' + TheFormula, 3);}
  FormWidth := PixWidth;

  { Create new instance of the parser object }
  ParserObj := TParserObj.Create;

  { Set event links }
  ParserObj.GetDBFEvent := GetDBFEvent;
  ParserObj.GetFMLEvent := GetFMLEvent;
  ParserObj.GetTBCEvent := GetTBCEvent;
  ParserObj.GetTBPEvent := GetTBPEvent;
  ParserObj.GetTBTEvent := GetTBTEvent;
  ParserObj.GetTRWEvent := GetTRWEvent;
  ParserObj.GetDocSignEvent := GetDocSign;
  ParserObj.GetCustNoteEvent := GetCustNote;
  ParserObj.GetSuppNoteEvent := GetSuppNote;
  ParserObj.GetInvNoteEvent := GetInvNote;
  ParserObj.GetStockNoteEvent := GetStockNote;
  ParserObj.GetSNoNoteEvent := GetSNoNote;
  ParserObj.GetJobNoteEvent := GetJobNote;
  ParserObj.GetPageNoEvent := GetPageNo;
  ParserObj.GetIdQtyEvent := GetIdQtyNo;
  ParserObj.GetFmtDateEvent := FormatDate;
  ParserObj.GetCcyEvent := GetCurrRate;
  ParserObj.GetCcyAgeEvent := GetCurrAgeing;
  // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
  ParserObj.GetLoadRoleEvent  := GetLoadRole;

  { Add Formula into Recursion Checking }
  Recurse.SetFormula(2, TheFormula);

  { Parse the formula }
  Result.StrResult := ParserObj.SetFormula(TheFormula, TheDecs, IVType, False);

  { Check to see if its a number }
  If IsNumFormat(Result.StrResult) Then Begin
    { Reformat StrResult if necessary for DoubleStr to work}
    If (Result.StrResult[Length(Result.StrResult)] = '-') Then
      { Need to move - sign to start }
      TmpStr := Result.StrResult[Length(Result.StrResult)] + Copy (Result.StrResult, 1, Length(Result.StrResult) - 1)
    Else
      TmpStr := Result.StrResult;
    Result.DblResult := DoubleStr(TmpStr);

    { Set To Blank If Zero }
    If BlankZero And (Result.DblResult = 0.00) And (Not (TheFormula[1] In ['"', '~'])) Then Begin
      Result.StrResult := '';
    End; { If }
  End { If }
  Else
    Result.DblResult := 0.0;

  { Free the parser }
  ParserObj.Free;
{DBug.Msg (0, 'StrResult: ' + Result.StrResult);
DBug.Msg (0, 'DblResult: ' + FloatToStr(Result.DblResult));
DBug.Indent (-3);}
End;

Function TForm_PrintTest.GetDBFEvent (Const FieldCode : String;
                                      Const Decs      : Byte) : ResultValueType;
Begin
{DBug.MsgI (0, 'GetDBFEvent: ' + FieldCode, 3);}
  Result := GetFieldText (LJVar(FieldCode, 8), Decs, FormWidth, False);
{DBug.Msg (0, 'StrResult: ' + Result.StrResult);
DBug.Msg (0, 'DblResult: ' + FloatToStr(Result.DblResult));
DBug.Indent(-3);}
End;

Function TForm_PrintTest.GetFMLEvent (Const FieldCode : String;
                                      Const Decs      : Byte) : ResultValueType;
Var
  I : Integer;
Begin
{DBug.MsgI (0, 'GetFMLEvent: ' + FieldCode, 3);}
  Result.StrResult := '';
  Result.DblResult := 0.00;

  If Recurse.StartCheck(FieldCode) Then Begin
    { Find the formula field }
    If (Formulas.Count > 0) Then
      For I := 0 To (Formulas.Count - 1) Do
        With TFormDefListObjType(Formulas.Items[I]), FormDef Do Begin
          If (UpperCase(Trim(fdControlId)) = UpperCase(Trim(FieldCode))) Then
            { Check it should be printed }
            If WantPrint (FormDef) Then
              { Calculate the formula value }
              Result := GetFormulaText (Formula.ffFormula, Formula.ffDecs{Decs}, FormWidth, False);
        End; { With }

    Recurse.EndCheck(FieldCode);
  End; { If }
{DBug.Msg (0, 'StrResult: ' + Result.StrResult);
DBug.Msg (0, 'DblResult: ' + FloatToStr(Result.DblResult));
DBug.Indent(-3);}
End;

Function TForm_PrintTest.GetTBCEvent (Const FieldCode : String;
                                      Const Decs      : Byte) : ResultValueType;
Var
  ColObj : TFormDefListObjType;
  I      : Integer;
Begin
  Result.StrResult := ErrStr;
  Result.DblResult := 0.00;

  If Recurse.StartCheck(FieldCode) Then Begin
    { Find column with corresponding field code }
    If (Columns.Count > 0) Then
      For I := 0 To (Columns.Count - 1) Do Begin
        ColObj := TFormDefListObjType(Columns.Items[I]);
        If (UpperCase(Trim(ColObj.FormDef.fdControlId)) = UpperCase(Trim(FieldCode))) Then
          { Check it should be printed }
          If WantPrint (ColObj.FormDef) Then Begin
            If (Not ColObj.ValueSet) Then
              GetDataColumn (I);

            { Return value of column }
            Result.StrResult := ColObj.CurrString;
            Result.DblResult := ColObj.CurrValue;
            Break;
          End { If }
          Else
            Result.StrResult := '';
      End; { For }

    Recurse.EndCheck(FieldCode);
  End; { If }
End;

Function TForm_PrintTest.GetTRWEvent (Const FieldCode : String;
                                      Const Decs      : Byte) : ResultValueType;
Begin
  Result.StrResult := IntToStr(RowCount);
  Result.DblResult := RowCount;
End;

Function TForm_PrintTest.GetTBPEvent (Const FieldCode : String;
                                      Const Decs      : Byte) : ResultValueType;
Var
  ColObj : TFormDefListObjType;
  I      : Integer;
Begin
  Result.StrResult := ErrStr;
  Result.DblResult := 0.00;

  { Find column with corresponding field code }
  If (Columns.Count > 0) Then
    For I := 0 To (Columns.Count - 1) Do Begin
      ColObj := TFormDefListObjType(Columns.Items[I]);
      If (UpperCase(Trim(ColObj.FormDef.fdControlId)) = UpperCase(Trim(FieldCode))) Then Begin
        { MH 27/5/97 - removed as not necessary }
        {If (Not ColObj.ValueSet) Then Begin
          GetDataColumn (I);
        End; { If }

        { Return value of column }
        Result.StrResult := ColObj.LastString;
        Result.DblResult := ColObj.LastValue;
        Break;
      End; { If }
    End; { For }
End;

Function TForm_PrintTest.GetTBTEvent (Const FieldCode : String;
                                      Const Decs      : Byte) : ResultValueType;
Var
  ColObj : TFormDefListObjType;
  I      : Integer;
Begin
  Result.StrResult := ErrStr;
  Result.DblResult := 0.00;

  If Recurse.StartCheck(FieldCode) Then Begin
    { Find column with corresponding field code }
    If (Columns.Count > 0) Then
      For I := 0 To (Columns.Count - 1) Do Begin
        ColObj := TFormDefListObjType(Columns.Items[I]);
        If (UpperCase(Trim(ColObj.FormDef.fdControlId)) = UpperCase(Trim(FieldCode))) Then Begin
          If (Not ColObj.ValueSet) Then Begin
            GetDataColumn (I);
          End; { If }

          { Return value of column }
          Result.DblResult := ColObj.TotalValue;
          Result.StrResult := FormatFloat (FormatDecStrSD (Decs, GenRealMask, BOff), Result.DblResult);
          Break;
        End; { If }
      End; { For }

    Recurse.EndCheck(FieldCode);
  End; { If }
End;

Function TForm_PrintTest.GetDocSign : SmallInt;
Begin
  Result := DocCnst[TInv.InvDocHed] * DocNotCnst;
End;

Function TForm_PrintTest.GetIdQtyNo : ResultValueType;
Begin
  Result.DblResult := Calc_IdQty(Id.Qty, Id.QtyMul,Id.UsePack);
  Result.StrResult := FloatToStr(Result.DblResult);
End;

Function TForm_PrintTest.GetPageNo : SmallInt;
Begin
  Result := PageNo;
End;

Function TForm_PrintTest.GetCustNote (Const NoteNo   : String;
                                      Const NoteType : Char) : String;

Begin
  Case NoteType Of
    'G' : Result := GetNoteNo (0, 1, NoteNo);
    'D' : Result := GetNoteNo (0, 2, NoteNo);
  End; { Case }
End;

Function TForm_PrintTest.GetSuppNote (Const NoteNo   : String;
                                      Const NoteType : Char) : String;
Begin
  Result := GetCustNote (NoteNo, NoteType);
End;

Function TForm_PrintTest.GetInvNote (Const NoteNo   : String;
                                     Const NoteType : Char) : String;
Var
  Source : Byte;
Begin
  { Intelligently decide whether to use TH or CH as basis for Notes }
  Source := 1;
  If Assigned(CurrJob) Then Begin
    If (GetNoteMode = 0) Then
    Begin
      If (CurrJob.PrintBatch.pbMainFnum <> InvF) Then Begin
        { Not printing a document }
        If (CurrJob.PrintBatch.pbTablFNum = InvF) Then Begin
          { Printing documents in table - use main document }
          Source := 3;
        End; { If }
      End; { If }
    End // If (GetNoteMode = 0)
    Else
    Begin
      Case GetNoteMode Of
        1 : Source := 3;
      End; // Case GetNoteMode
    End; // Else
  End; { If }

  Case NoteType Of
    'G' : Result := GetNoteNo (Source, 1, NoteNo);
    'D' : Result := GetNoteNo (Source, 2, NoteNo);
  End; { Case }
End;

Function TForm_PrintTest.GetStockNote (Const NoteNo   : String;
                                       Const NoteType : Char) : String;
Begin
  Case NoteType Of
    'G' : Result := GetNoteNo (2, 1, NoteNo);
    'D' : Result := GetNoteNo (2, 2, NoteNo);
  End; { Case }
End;

Function TForm_PrintTest.GetJobNote (Const NoteNo   : String;
                                     Const NoteType : Char) : String;
Begin { GetJobNote }
  { Check for Job Record }
  LinkOtherdb(IdetailF, JobF);

  Case NoteType Of
    'G' : Result := GetNoteNo (5, 1, NoteNo);
    'D' : Result := GetNoteNo (5, 2, NoteNo);
  End; { Case }
End; { GetJobNote }


{ Gets notes for the Serial Number for the current line if available }
Function TForm_PrintTest.GetSNoNote (Const NoteNo   : String;
                                     Const NoteType : Char) : String;
Begin { GetSNoNote }
  Result := GetSerialNote (NoteNo, NoteType);
End; { GetSNoNote }


{************************************************************************}
{* FormatDate: Gets the specified date, adjusts it, and formats it      *}
{************************************************************************}
Function TForm_PrintTest.FormatDate (Const DateCode : String10;
                                     Const Units    : SmallInt;
                                     Const OffUnits : Char;
                                     Const Format   : SmallInt) : ResultValueType;
type
  PDayTable = ^TDayTable;
  TDayTable = array[1..12] of Word;

Var
  DataDRec      : ^DataDict.DataDictRec;
  tDD, tMM, tYY : Word;
  DictLink      : DictLinkType;
  SourceFile    : Integer;
  TmpDriveFile  : Integer;
  DelphiDate    : TDateTime;

  function IsLeapYear(Year: Word): Boolean;
  begin
    Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
  end;

  function GetDayTable(Year: Word): PDayTable;
  const
    DayTable1: TDayTable = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
    DayTable2: TDayTable = (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
    DayTables: array[Boolean] of PDayTable = (@DayTable1, @DayTable2);
  begin
    Result := DayTables[IsLeapYear(Year)];
  end;

Begin
{DBug.MsgI (0, 'FormatDate Begin', 3);
DBug.Msg (1, '  DateCode: ' + DateCode);
DBug.Msg (1, '  Units: ' + IntToStr(Units));
DBug.Msg (1, '  OffUnits: ' + OffUnits);
DBug.Msg (1, '  Format: ' + IntToStr(Format));}

  Try
    New(DataDRec);

    Result.StrResult := 'FormatDate('+DateCode+','+IntToStr(Units)+','+OffUnits+','+IntToStr(Format)+')';
    Result.DblResult := 0.0;

    { Get Data Dictionary record }
    If GetDDField (DateCode, DataDRec^) Then Begin
      { check its a date }
      If (DataDRec^.DataVarRec.VarType = 4) Then Begin
        { Retrieve date - have to call directly to avoid formatting }
        With DictLink Do Begin
          DCr  := 0;
          DPr  := 99;
          DYr  := 149;
        End; { With }

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
          // HM 15/02/01: Added support ADJ Hidden lines and Sorting turned on
          fmADJSort         : Begin
                                TmpDriveFile := IdetailF;
                                SourceFile := 4; { Report Writer Document Header }
                              End;
          // HM 15/02/01: Added support for sorting Transaction Lines
          fmTransSort       : Begin
                                TmpDriveFile := IdetailF;
                                SourceFile := 4; { Report Writer Document Header }
                              End;
          // HM 08/01/03: Added CIS Voucher support
          fmCISVoucher      : Begin
                                TmpDriveFile := JdetlF;
                                SourceFile := TmpDriveFile;
                              End;
          // MH 09/03/2010: Added sorted picking list support
          // Sorted Single Picking List - No Bins & No Serial/Batch
          fmSortedPickingList,
          // Sorted Consolidated Picking List - No Bins & No Serial/Batch
          fmSortedConsPickingList : Begin
                                      TmpDriveFile := IdetailF;
                                      SourceFile := 4; { Report Writer Document Details }
                                    End;
        Else
          TmpDriveFile := DrivingFile;
          If (TmpDriveFile = IDetailF) Then
            SourceFile := 4
          else
            SourceFile := 0;
        End; { Else }

        { Get field value from database - in string format }
        DDosMode := False;
        Result.StrResult := Link_Dict(DataDRec^.DataVarRec.VarNo,
                                      DictLink,
                                      StringRec,
                                      1000,
                                      TmpDriveFile,
                                      SourceFile,
                                      '');

        DateStr(Result.StrResult, tDD, tMM, tYY);

{DBug.Msg (1, '  tDD: ' + IntToStr(tDD));
DBug.Msg (1, '  tMM: ' + IntToStr(tMM));
DBug.Msg (1, '  tYY: ' + IntToStr(tYY));}

        { Calulate any offset }
        If (OffUnits In ['D', 'F', 'L', 'M', 'Y']) Then Begin
          { Adjust }
          Case OffUnits Of
            'D' : If (Units <> 0) Then Begin { Day Offset }
                    { adjust }
                    JulCal(CalJul(tDD,tMM,tYY)+Units,tDD,tMM,tYY);
                  End;
            'F' : Begin { First Of Month }
                    If (Units <> 0) Then Begin
                      AdjMnth(tMM, tYY, Units);
                    End; { If }

                    tDD := 1;
                  End;
            'L' : Begin { Last Of Month }
                    If (Units <> 0) Then Begin
                      AdjMnth(tMM, tYY, Units);
                    End; { If }

                    tDD := GetDayTable(tYY)[tMM];
                  End;
            'M' : If (Units <> 0) Then Begin { Month Offset }
                    AdjMnth(tMM, tYY, Units);

                    If (tDD > GetDayTable(tYY)[tMM]) Then
                      tDD := GetDayTable(tYY)[tMM];
                  End;
            'Y' : If (Units <> 0) Then Begin { Year Offset }
                    tYY := tYY + Units;
                  End;
          End; { Case }
        End; { If }


{DBug.Msg (1, '  tDD: ' + IntToStr(tDD));
DBug.Msg (1, '  tMM: ' + IntToStr(tMM));
DBug.Msg (1, '  tYY: ' + IntToStr(tYY));}

        { Convert to specified format }
        Case Format Of
          { Standard Exchequer }
          1  : Begin
                 Result.StrResult := POutDate(StrDate(tYY,tMM,tDD));
               End;

          { 2  : Windows Short }
          { 3  : Windows Long }
          { 4  : Exchequer Internal }
          { 5  : Julian }

          { 10 : Day }
          { 11 : Day with leading zero }
          { 12 : Day - Short String }
          { 13 : Day - Long String }
          { 14 : Day -

          { 20 : Month }
          { 21 : Month with leading zero }
          { 22 : Month - Short String }
          { 23 : Month - Long String }

          { 30 : 2 digit year }
          { 31 : 4 digit year }
          2..5,
          10..14,
          20..23,
          30,31  : Begin
                     { Convert to a Delphi format Date }
                     DelphiDate := EncodeDate(tYY, tMM, tDD);

                     Case Format Of
                       2  : Result.StrResult := FormatDateTime(Orig_ShortDateFormat, DelphiDate);
                       3  : Result.StrResult := FormatDateTime(LongDateFormat, DelphiDate);
                       4  : Result.StrResult := FormatDateTime('YYYYMMDD', DelphiDate);
                       5  : Begin
                              Result.StrResult := SysUtils.Format('%0.0f', [DelphiDate]);
                              Result.DblResult := DelphiDate;
                            End;

                       10 : Result.StrResult := FormatDateTime('d', DelphiDate);
                       11 : Result.StrResult := FormatDateTime('dd', DelphiDate);
                       12 : Result.StrResult := FormatDateTime('ddd', DelphiDate);
                       13 : Result.StrResult := FormatDateTime('dddd', DelphiDate);
                       14 : Begin
                              Result.StrResult := IntToStr(tDD);

                              If (tdd In [1, 21, 31]) Then
                                { st }
                                Result.StrResult := Result.StrResult + 'st'
                              Else
                                If (tdd In [2, 22]) Then
                                  { nd }
                                  Result.StrResult := Result.StrResult + 'nd'
                                Else
                                  If (tdd In [3, 23]) Then
                                    { rd }
                                    Result.StrResult := Result.StrResult + 'rd'
                                  Else
                                    If (tdd In [4..20, 24..30]) Then
                                      { th }
                                      Result.StrResult := Result.StrResult + 'th';
                            End;

                       20 : Result.StrResult := FormatDateTime('m', DelphiDate);
                       21 : Result.StrResult := FormatDateTime('mm', DelphiDate);
                       22 : Result.StrResult := FormatDateTime('mmm', DelphiDate);
                       23 : Result.StrResult := FormatDateTime('mmmm', DelphiDate);

                       30 : Result.StrResult := FormatDateTime('yy', DelphiDate);
                       31 : Result.StrResult := FormatDateTime('yyyy', DelphiDate);
                     Else
                       { Exchequer Standard }
                       Result.StrResult := POutDate(StrDate(tYY,tMM,tDD));
                     End; { Case }
                   End;
        Else
          { Unknown - use standard Exchequer format }
          Result.StrResult := POutDate(StrDate(tYY,tMM,tDD));
        End; { Case }
      End; { If }
    End; { If }

    Dispose(DataDRec);
  Except
    On Ex:Exception Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
      DoMessageDlg ('The following error occurred in FMTDATE(' + Trim(DateCode) + ',' +
                                                               IntToStr(Units) + ',' +
                                                               OffUnits + ',' +
                                                               IntToStr(Format) + '):' + #13#13 +
                  '"' + Ex.Message + '".', mtError, [mbOk], 0);
  End;

{DBug.Indent (-3);
DBug.Msg (0, 'FormatDate End');}
End;


{************************************************************************}
{* GetCurrRate: Gets a Currency Rate (Company, Daily, Float)            *}
{************************************************************************}
Function TForm_PrintTest.GetCurrRate (Const DateCode  : String10;
                                      Const Units     : SmallInt;
                                      Const OffUnits  : Char;
                                      Const Format    : SmallInt) : ResultValueType;
Var
  DataDRec   : ^DataDict.DataDictRec;
  CurrStr    : String;
  CurrNo     : LongInt;
  ErrCode    : Integer;
Begin
  Try
    New(DataDRec);

    Result.StrResult := 'GetCurrRate('+DateCode+','+IntToStr(Units)+','+OffUnits+')';
    Result.DblResult := 0.0;

    If (OffUnits = 'D') Then Begin
      { Data Dictionary Currency field has been specified }
      CurrNo := -1;

      { Get Data Dictionary record }
      If GetDDField (DateCode, DataDRec^) Then Begin
        { Check its a Currency Field }
        If (DataDRec^.DataVarRec.VarType = 9) Then Begin
          { Get Currency Number }
          CurrStr := GetFieldText (DateCode, 0, 1000, False).StrResult;

          { Convert to number }
          Val (CurrStr, CurrNo, ErrCode);
          If (ErrCode <> 0) Then CurrNo := -1;
        End; { If }
      End; { If }
    End { If }
    Else
      { Currency Number specified }
      CurrNo := Units;

    If (CurrNo >= 0) And (CurrNo <= CurrencyType) Then Begin
      Result.DblResult := 1.00;

      Case Format Of
        1 : Begin { Company Rate }
              Result.DblResult := SyssCurr^.Currencies[CurrNo].CRates[BOff];

              If SyssGCur^.GhostRates.TriInvert[CurrNo] Then
                Result.DblResult := Round_Up(1/Result.DblResult, 6);
            End;
        2 : Begin { Daily Rate }
              Result.DblResult := SyssCurr^.Currencies[CurrNo].CRates[BOn];

              If SyssGCur^.GhostRates.TriInvert[CurrNo] Then
                Result.DblResult := Round_Up(1/Result.DblResult, 6);
            End;
        3 : Begin { Floating Rate }
              Result.DblResult := SyssGCur^.GhostRates.TriRates[CurrNo];
            End;
        4 : Begin { Currency Name }
              Result.StrResult := SyssCurr^.Currencies[CurrNo].Desc;
              Result.DblResult := 0.0;
            End;
        5 : Begin { Currency Print Symbol }
              Result.StrResult := SyssCurr^.Currencies[CurrNo].PSymb;
              Result.DblResult := 0.0;
            End;
        6 : Begin { Invert Rate Flag }
              Result.StrResult := YesNoBo(SyssGCur^.GhostRates.TriInvert[CurrNo]);
              Result.DblResult := Ord(SyssGCur^.GhostRates.TriInvert[CurrNo]);
            End;
      End; { Case }

      If (Format >= 1) And (Format <= 3) Then Begin
        { Return 1.0 instead of 0.0 }
        If (Result.DblResult = 0) Then Result.DblResult := 1.00;

        { Return a nice string }
        Result.StrResult:=Form_Real(Result.DblResult,12,6);
      End; { If }
    End; { If }

    Dispose(DataDRec);
  Except
    On Ex:Exception Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
      DoMessageDlg ('The following error occurred in GETCURRRATE(' + Trim(DateCode) + ',' +
                                                               IntToStr(Units) + ',' +
                                                               OffUnits + '):' + #13#13 +
                  '"' + Ex.Message + '".', mtError, [mbOk], 0);
  End;
End;


// GetCurrAging: Returns Currency Ageing info to the parser
//
// Params:
//   CcyCode:  Currency Field Code if CcyType = 'D'
//   Ccy:      Currency Number if CcyType = '#'
//   CcyType:  As above
//   AgeVal:   0=Not Due,1=This Month,2=1 month,3=2 months,4=3 months,5=4+months,6=total OS
//
Function TForm_PrintTest.GetCurrAgeing (Const CcyCode : String10;
                                        Const Ccy     : SmallInt;
                                        Const CcyType : Char;
                                        Const AgeVal  : SmallInt) : ResultValueType;
Var
  DataDRec   : ^DataDict.DataDictRec;
  CurrStr    : String;
  CurrNo     : LongInt;
  ErrCode    : Integer;
Begin { GetCurrAgeing }
  Try
    New(DataDRec);

    Result.StrResult := 'GetCurrAgeing('+CcyCode+','+IntToStr(Ccy)+','+CcyType+','+IntToStr(AgeVal)+')';
    Result.DblResult := 0.0;

    If (CcyType = 'D') Then Begin
      { Data Dictionary Currency field has been specified }
      CurrNo := -1;

      { Get Data Dictionary record }
      If GetDDField (CcyCode, DataDRec^) Then Begin
        { Check its a Currency Field }
        If (DataDRec^.DataVarRec.VarType = 9) Then Begin
          { Get Currency Number }
          CurrStr := GetFieldText (CcyCode, 0, 1000, False).StrResult;

          { Convert to number }
          Val (CurrStr, CurrNo, ErrCode);
          If (ErrCode <> 0) Then CurrNo := -1;
        End; { If }
      End; { If }
    End { If }
    Else
      { Currency Number specified }
      CurrNo := Ccy;

    If (CurrNo >= 0) And (CurrNo <= CurrencyType) Then Begin
      Result.DblResult := CurrAged[CurrNo]^[AgeVal];

      Result.StrResult:=Form_Real(Result.DblResult,12,6);
    End; { If }

    Dispose(DataDRec);
  Except
    On Ex:Exception Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
      DoMessageDlg ('The following error occurred in GetCurrAgeing(' + Trim(CcyCode) + ',' +
                                                               IntToStr(Ccy) + ',' +
                                                               CcyType + ',' +
                                                               IntToStr(AgeVal) + '):' + #13#13 +
                  '"' + Ex.Message + '".', mtError, [mbOk], 0);
  End;
End; { GetCurrAgeing }

//-------------------------------------------------------------------------

// MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
Function TForm_PrintTest.GetLoadRole (Const AcCode : ShortString;
                                      Const RoleDesc : ShortString) : ResultValueType;
Var
  DataDRec : ^DataDict.DataDictRec;
  sAcCode : ShortString;
Begin // GetLoadRole
  Try
    New(DataDRec);
    Try
      // Return blank - unless there is an error
      Result.StrResult := '';
      Result.DblResult := 0.0;

      // Try to load the DD field value
      If GetDDField (AcCode, DataDRec^) Then
      Begin
        // Get actual Account Code
        sAcCode := GetFieldText (AcCode, 0, 1000, False).StrResult;

        // Load the Account Contact details for the Role
        FDAccountContacts.FindAccountRoleByDescription(sAcCode, RoleDesc);
      End // If GetDDField (AcCode, DataDRec^)
      Else
        // Invalid DD Field
        Result.StrResult := 'Error: GetLoadRole('+AcCode+','+RoleDesc+')';
    Finally
      Dispose(DataDRec);
    End; // Try..Finally
  Except
    On Ex:Exception Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
      DoMessageDlg ('The following error occurred in GetLoadRole(' + Trim(AcCode) + ',' + Trim(RoleDesc) + '):' + #13#13 +
                  '"' + Ex.Message + '".', mtError, [mbOk], 0);
  End;
End; // GetLoadRole

{**************************************************************}
{* Print Form                                                 *}
{**************************************************************}
Procedure TForm_PrintTest.DoFont (TheFont : fdFontDefType);
begin
  With TheReport, TheFont Do Begin
    {SetFont (ffName, ffSize);
    TheReport.Canvas.Font.Color := ffColor;
    {TheReport.Canvas.Font.Height := ffHeight;}

    FontName := ffName;
    FontSize := ffSize;
    FontColor := ffColor;

    SetPen (ffColor, pssolid, -1, pmCopy);
    SetBrush (clWhite, bsClear, Nil);

    (*
    If (fsBold In ffStyle) Then Bold := True;
    If (fsItalic In ffStyle) Then Italic := True;
    If (fsUnderline In ffStyle) Then Underline := True;
    If (fsStrikeOut In ffStyle) Then StrikeOut := True;
    *)
    Bold := (fsBold In ffStyle);
    Italic := (fsItalic In ffStyle);
    StrikeOut := (fsStrikeOut In ffStyle);
    Underline := (fsUnderline In ffStyle);
  End; { With }

  FontRecToFont (Label_FontSize.Font, TheFont);
  SetVisFontHeight (Label_FontSize.Font, TheFont.ffSize);
end;

Procedure TForm_PrintTest.ExtTextRect2 (Const ftText    : ShortString;
                                        Const ftJustify : TAlignment;
                                        Const ftLeft,
                                              ftTop,
                                              ftWidth,
                                              ftHeight  : Double;
                                        Const VCenter   : Boolean = False);
Var
  Rect       : TRect;
  PaintFlags : Word;
Begin { ExtTextRect2 }
  // HM 28/07/03: Added filter because the PrintHeight call was failing for empty strings
  If (Trim(ftText) <> '') Then
    With TheReport Do Begin
      If (PrintTextMethod = ptmDrawText) Then Begin
        Rect := CreateRect (ftLeft, ftTop, (ftLeft + ftWidth), (ftTop + ftHeight));

        Case ftJustify Of
          taLeftJustify  : PaintFlags := DT_LEFT;
          taRightJustify : PaintFlags := DT_RIGHT;
          taCenter       : PaintFlags := DT_CENTER;
        Else
          PaintFlags := DT_LEFT;
        End; { Case }

        If VCenter Then PaintFlags := PaintFlags Or DT_VCENTER;

        ExtTextRect (Rect, PaintFlags, ftText);
      End { If (PrintTextMethod = ptmDrawText) }
      Else
        If (PrintTextMethod = ptmRAVECommands) Then Begin
          With TMemoBuf.Create Do
            Try
              BaseReport := TheReport;

              // HM 15/01/02: Only used for column headers which look OK anyway
              //If VCenter Then ShowMessage ('PrntForm.ExtTextRect2 - VCenter Not Coded');

              Text := ftText;

              Case ftJustify Of
                taLeftJustify  : Justify := pjLeft;
                taRightJustify : Justify := pjRight;
                taCenter       : Justify := pjCenter;
              Else
                Justify := pjLeft;
              End; { Case }

              //LineTop := ftTop;
              FontTop := ftTop;
              PrintStart := ftLeft;
              PrintEnd := ftLeft + ftWidth;

              PrintHeight (ftHeight, False);
            Finally
              Free;
            End;
        End { If (PrintTextMethod = ptmRAVECommands) }
        Else
          Raise Exception.Create ('PrntForm.ExtTextRect2 - Illegal PrintTextMethod Value (' + IntToStr(Ord(PrintTextMethod)) + ')');
    End; { With TheReport }
End; { ExtTextRect2 }

Procedure TForm_PrintTest.PrintText (TheText : fdTextRecType);
(*Var
  PaintFlags : Word;
  Rect       : TRect;*)
begin
  With TheReport, TheText Do Begin
    DoFont (ftFont);

    // HM 13/11/00: Added support for Symbol Fonts
    If ftSymbolFont Then
      FontCharSet := Symbol_CharSet
    Else
      FontCharSet := Default_CharSet;

    (* HM 15/01/02: Modified for direect PDF printing
    Rect := CreateRect (ftXPos, ftYPos, (ftXPos + ftWidth), (ftYPos + ftHeight));

    Case ftJustify Of
      taLeftJustify  : PaintFlags := DT_LEFT;
      taRightJustify : PaintFlags := DT_RIGHT;
      taCenter       : PaintFlags := DT_CENTER;
    Else
      PaintFlags := DT_LEFT;
    End; { Case }

    ExtTextRect (Rect, {Rect.Left, Rect.Top, }PaintFlags, ftText);
    *)
    ExtTextRect2 (ftText, ftJustify, ftXPos, ftYPos, ftWidth, ftHeight);
// RPDD HM 28/11/02: Added Drill-Down support
//DrillDownArea (ftXPos, ftYPos, (ftXPos + ftWidth), (ftYPos + ftHeight), 1, ftText, 1, 2, 3);
  End;  { With }
end;

Procedure TForm_PrintTest.PrintBitmap (TheBitmap : fdBitmapRecType);
Var
  //APicture : TPicture;
  ActPath  : String;
  Bmp      : TBitmap;
  BmpPath  : ShortString;
  Idx      : SmallInt;
begin
  // 18/07/02: Completely rewrote for Bitmap Caching
  With TheReport, TheBitmap Do Begin
    //Cachelist := TStringList.Create;

    // Search form bitmap and get full path
    If GetBitmapPath (fbBitmapPath, '', ActPath) Then Begin
      Bmp := TBitmap.Create;
      Try
        Try
          // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
          LoadImageFromFile (ActPath, Bmp);

          BmpPath := Trim(UpperCase(fbBitmapPath));

          // Check Cache for bitmap
          Idx := CacheList.IndexOf(BmpPath);
          If (Idx = -1) Then Begin
            PrintBitmapRect(fbXPos, fbYPos, (fbXPos + fbWidth), (fbYPos + fbHeight), Bmp);

            // Update Cache - assuming we haven't already reached the maximum of 10 bitmaps supported by RpPro
            If (CacheList.Count < 10) Then Begin
              CacheList.Add (BmpPath);
              RegisterGraphic(CacheList.Count);
            End; { If (CacheList.Count < 10) }
          End { If (Idx = -1) }
          Else Begin
            // Re-use cached bitmap
            ReuseGraphic(Idx + 1);
            PrintBitmapRect(fbXPos, fbYPos, (fbXPos + fbWidth), (fbYPos + fbHeight), Bmp);
          End; { Else }
        Except
          // MH 16/02/2017 2017-R1 ABSEXCH-14925: Added MadExcept Logging

          // Log the exception to file so we have a record of the fault
          AutoSaveBugReport(CreateBugReport(etNormal));

          DoMessageDlg('Error printing image - ' + ActPath, mtError, [mbOk], 0);
        End; // Try..Except
      Finally
        Bmp.Free;
      End;
    End; { If GetBitmapPath (BmpPath, '', ActPath) }

    (***
    APicture := TPicture.Create;
    Try
      If GetBitmapPath (fbBitmapPath, '', ActPath) Then Begin
        Try
          APicture.LoadFromFile (ActPath);
          PrintBitmapRect(fbXPos, fbYPos, (fbXPos + fbWidth), (fbYPos + fbHeight), APicture.BitMap);
        Except
        End;
      End; { If }
    Finally
      APicture.Free;
    End;
    ***)
  End;  { With }
end;

Procedure TForm_PrintTest.PrintLine (TheLine : fdLineRecType);
Var
  X1, X2, Y1, Y2 : Integer;
begin
  With TheReport, TheLine Do Begin
{ShowMessage ('Line: ' + #13 + #10 +
             'Top: ' + IntToStr(flYPos1) + #13 + #10 +
             'Left: ' + IntToStr(flXPos1) + #13 + #10 +
             'Right: ' + IntToStr(flXPos2) + #13 + #10 +
             'Bottom: ' + IntToStr(flYPos2)); }
    SetPen  (flColor, psSolid, -Round(flPenWidth * 1.312336), pmCopy);
    X1 := flXPos1 + 2;
    X2 := flXPos2 - 2;
    Y1 := flYPos1 + 2;
    Y2 := flYPos2 - 2;
    Case flType Of
      lnVertical   : Begin
                       MoveTo (X1, Y1);
                       LineTo (X1, Y2);
                       LineTo (X1, Y1);
                     End;
      lnHorizontal : Begin
                       MoveTo (X1, Y1);
                       LineTo (X2, Y1);
                       LineTo (X1, Y1);
                     End;
      lnTLToBR     : Begin
                       MoveTo (X1, Y1);
                       LineTo (X2, Y2);
                       LineTo (X1, Y1);
                     End;
      lnBLToTR     : Begin
                       MoveTo (X1, Y2);
                       LineTo (X2, Y1);
                       LineTo (X1, Y2);
                     End;
    End; { Case }
  End;  { With }
end;

Procedure TForm_PrintTest.PrintBox (TheBox : fdBoxRecType);
Var
  rLeft, rTop, rRight, rBottom : LongInt;
begin
  With TheReport, TheBox Do Begin
    {SetPen  (fxPenColor, psSolid, -Round(fxPenWidth * 1.312336), pmCopy);}
    SetPen  (fxPenColor, psSolid, -fxPenWidth, pmCopy);
    SetBrush (fxPenColor, bsSolid, Nil);
    rLeft   := fxXPos + 2;
    rTop    := fxYPos + 2;
    rRight  := fxXPos + fxWidth - 2;
    rBottom := fxYPos + fxHeight - 2;

    If (Not fxFill) Then Begin
      { Outline only }
      If fxTopBorder Then Begin
        MoveTo (rLeft,  rTop);
        LineTo (rRight, rTop);
        LineTo (rLeft,  rTop); { Need to draw back again because of Feature!!   }
                               { in WINAPI that means it doesn't draw the pixel }
                               { at the destination                             }
      End; { If }

      If fxRightBorder Then Begin
        MoveTo (rRight, rTop);
        LineTo (rRight, rBottom);
        LineTo (rRight, rTop);
      End; { If }

      If fxBottomBorder Then Begin
        MoveTo (rRight, rBottom);
        LineTo (rLeft,  rBottom);
        LineTo (rRight, rBottom);
      End; { If }

      If fxLeftBorder Then Begin
        MoveTo (rLeft, rBottom);
        LineTo (rLeft, rTop);
        LineTo (rLeft, rBottom);
      End; { If }
    End { If }
    Else
      { Filled Rectangle }
      FillRect (CreateRect (rLeft, rTop, rRight, rBottom));
  End; { With }
end;

Procedure TForm_PrintTest.PrintPageNo (ThePageNo : fdPageRecType);
(* HM 15/01/02: Modified for direect PDF printing
Var
  Rect       : TRect;
  Text       : Str255;
  PaintFlags : Word;
*)
begin
  With TheReport, ThePageNo Do Begin
    DoFont (fpFont);

    (* HM 15/01/02: Modified for direect PDF printing
    Rect := CreateRect (fpXPos, fpYPos, (fpXPos + fpWidth), (fpYPos + fpHeight));

    Case fpJustify Of
      taLeftJustify  : PaintFlags := DT_LEFT;
      taRightJustify : PaintFlags := DT_RIGHT;
      taCenter       : PaintFlags := DT_CENTER;
    Else
      PaintFlags := DT_LEFT;
    End; { Case }

    Text := fpLeading + IntToStr (PageNo) + fpTrailing;
    ExtTextRect (Rect, PaintFlags, Text);
    *)
    ExtTextRect2 (fpLeading + IntToStr (PageNo) + fpTrailing, fpJustify, fpXPos, fpYPos, fpWidth, fpHeight);
  End;  { With }
end;

Procedure TForm_PrintTest.PrintDbField (Const FieldDef : FormDefRecType);
Var
  fText     : Str255;
Begin
{DBug.MsgI (0, 'PrintDbField: ' + FieldDef.fdControlId, 3);}
  With TheReport, FieldDef, DbField Do Begin
    (* HM 15/01/02: Modified for direct PDF printing
    fRect := CreateRect (fdXPos, fdYPos, (fdXPos + fdWidth), (fdYPos + fdHeight));
    *)

    DoFont (DbField.fdFont);

    { Get Dictionary Record }
    fText := GetFieldText (fdShortCode, fdDecs, (fdWidth * DefaultPixPerMM), fdBlankIfZero).StrResult;

    (* HM 15/01/02: Modified for direct PDF printing
    Flags := AlignToFlag (fdAlign);
    ExtTextRect (fRect, Flags, fText);
    *)
    ExtTextRect2 (fText, fdAlign, fdXPos, fdYPos, fdWidth, fdHeight);
  End;  { With }
{DBug.Indent(-3);}
End;

Procedure TForm_PrintTest.PrintFormula (Const TheFormula : fdFormulaRecType);
Var
  FormText   : Str255;
  //PaintFlags : Byte;
  //Rect       : TRect;
  pStr       : PChar;
  BinData    : ANSIString;
begin
{DBug.MsgI (0, 'PrintFormula: ' + TheFormula.ffFormula, 3);}
  With TheReport, TheFormula Do Begin
    // HM 05/06/03: Extended to support binary data
    If (Length(ffFormula) > 0) And (ffFormula[1] = '*') Then Begin
      Try
        BinData := ConvertAsciiText (ffFormula);
        If (BinData <> '') Then
          PrintData (BinData);
      Except
        On Exception Do
          ;
      End;
    End { If (Length(ffFormula) > 0) And (ffFormula[1] = '*') }
    Else Begin
      DoFont (ffFont);

      (* HM 15/01/02: Modified for direct PDF printing
      Rect := CreateRect (ffXPos, ffYPos, (ffXPos + ffWidth), (ffYPos + ffHeight));
      *)

      { Get the formula }
      FormText := GetFormulaText (ffFormula, ffDecs, (ffWidth * DefaultPixPerMM), ffBlankIfZero).StrResult;

      { Check for BarCode conversion }
      If (ffBarCode <> bcNone) Then Begin
        pStr := StrAlloc (255);
        StrPCopy (pStr, FormText);

        Case ffBarCode Of
          bcCode39  : FormText := BC_OCode39(pStr,ffBCFlag1,ffBCFlag2);
          bcCode128 : FormText := BC_Code128(pStr);{,ffBCFlag1,ffBCFlag2,ffBCFlag3);}
          bcInter25 : FormText := BC_OInter25(pStr,ffBCFlag1);
          bcCodabar : FormText := BC_Codabar(pStr);{,ffBCFlag2,ffBCFlag3,ffBCFlag1);}
          bcPostnet : FormText := BC_PostNet(pStr);
          bcUPCA    : FormText := BC_UPCA(pStr);
          bcUPCE    : FormText := BC_UPCE(pStr);
          bcEAN8    : FormText := BC_EAN8(pStr);
          bcEAN13   : FormText := BC_EAN13(pStr);
          bcHIBC    : FormText := CalcHIBCCheckChar(FormText);
        End; { Case }

        StrDispose (pStr);
      End; { If }

      (* HM 15/01/02: Modified for direct PDF printing
      PaintFlags := AlignToFlag (ffAlign);
      ExtTextRect (Rect, {Rect.Left, Rect.Top, }PaintFlags, FormText);
      *)
      ExtTextRect2 (FormText, ffAlign, ffXPos, ffYPos, ffWidth, ffHeight);
    End; { Else }
  End;  { With }
{DBug.Msg (0, 'done');
DBug.Indent(-3);}
end;

Procedure TForm_PrintTest.PrintTable (Const TheTable : fdTableRecType);
Var
  FTable                                    : TableObject;
  TabLeft, TabTop, TabRight, TabBot, RowTop : LongInt;
  Col1, HdrFontHeight                       : Integer;
  Got1VisCol                                : Boolean;

  Function CalcRight : LongInt;
  Var
    I, TotWidth : Integer;
  begin
    If (Columns.Count > 0) Then Begin
      TotWidth := 2; { one pixel at either side }

      { Calculate width of columns }
      For I := 0 To (Columns.Count - 1) Do
        With TFormDefListObjType(Columns.Items[I]).FormDef Do Begin
          Case fdFieldClass Of
            fdcFieldCol   : If (Not FieldCol.fdHidden) Then Begin
                              TotWidth := TotWidth + FieldCol.fdWidth;
                            End;
            fdcFormulaCol : If (Not FormulaCol.ffHidden) Then Begin
                              TotWidth := TotWidth + FormulaCol.ffWidth;
                            End;
          End; { Case }
      End; { With }
    End { If }
    Else
      TotWidth := TheTable.frWidth - 2;

    If (TotWidth > TheTable.frWidth) Then TotWidth := TheTable.frWidth - 2;
    If (TotWidth < 10) Then TotWidth := 10;

    Result := TotWidth;
  End;

  Procedure PaintColHeaders;
  Var
    I, ColLeft, ColRight, cWidth : Integer;
    //TextRect                     : TRect;
    LastCol                      : Boolean;
    Flags                        : TAlignment;
    TmpStr                       : Str255;
    TmpSep, ColHidden            : Boolean;
  begin
    If (Columns.Count > 0) Then Begin
      ColLeft := TabLeft;

      For I := 0 To (Columns.Count - 1) Do
        With TFormDefListObjType(Columns.Items[I]).FormDef Do Begin
          Case fdFieldClass Of
            fdcFieldCol   : With FieldCol Do Begin
                              TmpStr := fdTitle;
                              // HM 15/01/02: Modified for direct PDF printing
                              //Flags := AlignToFlag (fdAlign) Or DT_VCENTER; { MH: Added DT_VCENTER 23/10/96 }
                              Flags := fdAlign;
                              TmpSep := fdWantSep;
                              cWidth := fdWidth;
                              ColHidden := fdHidden;
                            End;
            fdcFormulaCol : With FormulaCol Do Begin
                              TmpStr := ffTitle;
                              // HM 15/01/02: Modified for direct PDF printing
                              //Flags := AlignToFlag (ffAlign) Or DT_VCENTER; { MH: Added DT_VCENTER 23/10/96 }
                              Flags := ffAlign;
                              TmpSep := ffWantSep;
                              cWidth := ffWidth;
                              ColHidden := ffHidden;
                            End;
          End; { Case }

          If (Not ColHidden) Then Begin
            ColRight := ColLeft + cWidth;
            If (ColRight > TabRight) Then
              ColRight := TabRight;
            LastCol := (I = (Columns.Count - 1));

            DoFont (FTable.Font (Hdr));

            (*With TextRect Do Begin
              Left   := ColLeft + 1;
              Right  := ColRight - 1;
              Top    := TabTop{ + 1};
              Bottom := RowTop{ - 1};
            End; { With }*)

            (* HM 15/01/02: Modified for direct PDF printing
            TextRect := TheReport.CreateRect (ColLeft + 1, TabTop + 1, (ColRight - 1), RowTop - 0.5);

            { Calc Flags }
            TheReport.ExtTextRect (TextRect, {TextRect.Left, TextRect.Top, }Flags, TmpStr);
            *)
            ExtTextRect2 (TmpStr, Flags, ColLeft + 1, TabTop + 1, ColRight - ColLeft - 2, RowTop - 1.5 - TabTop, True);

            If TmpSep And (Not LastCol) Then
              { Draw separating line at end of column }
              FTable.RepDrawLine (TheReport, Hdr_ColSepLine, ColRight, TabTop, ColRight, RowTop);

            ColLeft := ColRight;
            If (ColLeft >= TabRight) Then Break;
          End; { With }
        End; { With }
    End; { If }
  end;

  { Paints the vertical column separators }
  Procedure PaintColSeps;
  Var
    I, ColLeft, ColRight, cWidth : Integer;
    LastCol, TmpSep, ColHidden   : Boolean;
  begin
    If (Columns.Count > 0) Then Begin
      ColLeft := TabLeft;

      For I := 0 To (Columns.Count - 1) Do
        With TFormDefListObjType(Columns.Items[I]).FormDef Do Begin
          Case fdFieldClass Of
            fdcFieldCol   : With FieldCol Do Begin
                              TmpSep := fdWantSep;
                              cWidth := fdWidth;
                              ColHidden := fdHidden;
                            End;
            fdcFormulaCol : With FormulaCol Do Begin
                              TmpSep := ffWantSep;
                              cWidth := ffWidth;
                              ColHidden := ffHidden;
                            End;
          End; { Case }

          If (Not ColHidden) Then Begin
            ColRight := ColLeft + cWidth;
            If (ColRight > TabRight) Then
              ColRight := TabRight;
            LastCol := (I = (Columns.Count - 1));

            If TmpSep And (Not LastCol) Then
              { Draw separating line at end of column }
              FTable.RepDrawLine (TheReport, Tbl_ColSepLine, ColRight, RowTop, ColRight, TabBot);

            ColLeft := ColRight;
            If (ColLeft >= TabRight) Then Break;
          End; { If }
        End; { With }
    End; { If }
  end;

  { returns height of heighest row }
  Function GetRowHeight : Integer;
  Var
    I, RowHeight, fHeight : Integer;
    TheRect   : TRect;
    TmpFont   : fdFontDefType;
  begin
    RowHeight := 0;

    If (Columns.Count > 0) Then
      For I := 0 To (Columns.Count - 1) Do
        With TFormDefListObjType(Columns.Items[I]).FormDef Do Begin
          { Take temporary copy of previous font }
          FontToRec (Self.Canvas.Font, TmpFont);
          Case fdFieldClass Of
            fdcFieldCol   : FontRecToFont (Self.Canvas.Font, FieldCol.fdColFont);
            fdcFormulaCol : FontRecToFont (Self.Canvas.Font, FormulaCol.ffColFont);
          End; { Case }

          SetVisFontHeight (Self.Canvas.Font, Self.Canvas.Font.Size);

          { Get size of font }
          TheRect := Rect (1, 1, 2, 2);
          DrawText (Self.Canvas.Handle, 'M', 1, TheRect, (DT_CALCRECT Or DT_SINGLELINE));

          { restore temporary copy of previous font }
          FontRecToFont (Self.Canvas.Font, TmpFont);

          fHeight := (TheRect.Bottom - TheRect.Top);

          { Keep highest font }
          If (fHeight > RowHeight) Then RowHeight := fHeight;
        End; { With }

    {RowHeight := RowHeight + 5;}

    While (RowHeight < 1) Or ((RowHeight Mod DefaultPixPerMM) <> 0) Do
      Inc (RowHeight);

    Result := Round(RowHeight / DefaultPixPerMM);
  end;

  { Paints the horizontal row separators on the table }
  Procedure PaintRowSeps;
  Var
    RowHeight, lRowTop : Integer;
  begin
    RowHeight := GetRowHeight;
    lRowTop   := RowTop + RowHeight;

    While ((lRowTop + RowHeight) <= TabBot) do Begin
      { draw row sep line }
      FTable.RepDrawLine (TheReport, Tbl_RowSepLine, TabLeft, lRowTop, TabRight, lRowTop);

      lRowTop := lRowTop + RowHeight;
    End; { While }
  end;

  { Loads and paints in the data to the table, prints new pages }
  { where necessary                                             }
  Procedure PaintTableData;
  Var
    DataRowTop, DataRowHeight, DataRowBottom : LongInt;
    I, ColW                                  : Integer;
    TextRect{, PrntRect }                    : TRect;
    Flags                                    : TAlignment;
    RowCaption                               : Str255;
    ColHidden, GotPrintCell                  : Boolean;
    pStr                                     : PChar;
  Begin { PaintTableData }
    { Check all the table events are linked in }
    If Assigned (GotDataRow) And
       Assigned (GetNextDataRow) And
       Assigned (GetDataColumn) And
       (Columns.Count > 0) Then Begin
      { Initalise row vars }
      DataRowTop := RowTop;
      DataRowHeight := GetRowHeight;
      DataRowBottom := DataRowTop + DataRowHeight;

      { Print Rows }
      While GotDataRow Do Begin
        { Initialise column vars }
        With TextRect Do Begin
          Left   := TabLeft + 1;
          Top    := DataRowTop + 1;
          Bottom := DataRowBottom{ - 1};
        End; { With }

        PrnDef_StartDataRow;

        { Check to see if any columns to print for this row }  {HM: 12/11/96}
        GotPrintCell := False;
        For I := Col1 To (Columns.Count - 1) Do
          With TFormDefListObjType(Columns.Items[I]), FormDef Do
            If Recurse.StartCheck(fdControlId) Then Begin
              Case fdFieldClass Of
                fdcFieldCol   : If (Not FieldCol.fdHidden) Then
                                  If WantPrint (FormDef) Then
                                    GotPrintCell := True;

                fdcFormulaCol : If (Not FormulaCol.ffHidden) Then
                                  If WantPrint (FormDef) Then
                                    GotPrintCell := True;
              End; { Case }

              Recurse.EndCheck (fdControlId);

              If GotPrintCell Then Break;
            End; { If }

        If GotPrintCell Then Begin
          { Print Columns }
          For I := Col1 To (Columns.Count - 1) Do
            With TFormDefListObjType(Columns.Items[I]), FormDef Do Begin
              If Recurse.StartCheck(fdControlId) Then Begin
                { Set Field specific info }
                Case fdFieldClass Of
                  fdcFieldCol   : Begin
                                    DoFont (FieldCol.fdColFont);
                                    ColW := FieldCol.fdWidth;
                                    // HM 15/01/02: Modified for direect PDF printing
                                    //Flags := AlignToFlag (FieldCol.fdAlign);
                                    Flags := FieldCol.fdAlign;
                                    ColHidden := FieldCol.fdHidden;
                                  End;
                  fdcFormulaCol : Begin
                                    DoFont (FormulaCol.ffColFont);
                                    ColW := FormulaCol.ffWidth;
                                    // HM 15/01/02: Modified for direect PDF printing
                                    //Flags := AlignToFlag (FormulaCol.ffAlign);
                                    Flags := FormulaCol.ffAlign;
                                    ColHidden := FormulaCol.ffHidden;
                                  End;
                End; { Case }

                If (ColW > 0) And (Not ColHidden) Then Begin
                  { Calc Column position in row }
                  TextRect.Right  := TextRect.Left + ColW - 2;
                  If (TextRect.Right > TabRight) Then
                    TextRect.Right := TabRight;

                  { Draw Text }
                  RowCaption := GetDataColumn (I);
                  (* HM 15/01/02: Modified for direect PDF printing
                  PrntRect := TheReport.CreateRect (TextRect.Left, TextRect.Top, TextRect.Right, TextRect.Bottom);
                  TheReport.ExtTextRect (PrntRect, {PrntRect.Left, PrntRect.Top, }Flags, RowCaption);
                  *)

                  // MH 12/04/06: Added BarCode support as someone finally noticed it was missing after 8 years!
                  If (fdFieldClass = fdcFormulaCol) And (FormulaCol.ffBarCode <> bcNone) Then
                  Begin
                    pStr := StrAlloc (255);
                    StrPCopy (pStr, RowCaption);

                    Case FormulaCol.ffBarCode Of
                      bcCode39  : RowCaption := BC_OCode39(pStr,FormulaCol.ffBCFlag1,FormulaCol.ffBCFlag2);
                      bcCode128 : RowCaption := BC_Code128(pStr);{,ffBCFlag1,ffBCFlag2,ffBCFlag3);}
                      bcInter25 : RowCaption := BC_OInter25(pStr,FormulaCol.ffBCFlag1);
                      bcCodabar : RowCaption := BC_Codabar(pStr);{,ffBCFlag2,ffBCFlag3,ffBCFlag1);}
                      bcPostnet : RowCaption := BC_PostNet(pStr);
                      bcUPCA    : RowCaption := BC_UPCA(pStr);
                      bcUPCE    : RowCaption := BC_UPCE(pStr);
                      bcEAN8    : RowCaption := BC_EAN8(pStr);
                      bcEAN13   : RowCaption := BC_EAN13(pStr);
                      bcHIBC    : RowCaption := CalcHIBCCheckChar(RowCaption);
                    End; { Case }

                    StrDispose (pStr);
                  End; // If (fdFieldClass = fdcFormulaCol) And (FormulaCol.ffBarCode <> bcNone)

                  ExtTextRect2 (RowCaption, Flags, TextRect.Left, TextRect.Top, TextRect.Right - TextRect.Left, TextRect.Bottom - TextRect.Top);

                  { Update position for next column }
                  TextRect.Left := TextRect.Right + 2;

                  { Check we still got room to print columns }
                  If (TextRect.Left >= TabRight) Then Begin
                    Recurse.EndCheck (fdControlId);
                    Break;
                  End; { If }
                End; { If }

                Recurse.EndCheck (fdControlId);
              End; { If }
            End; { With }

          { Move to next row's position }
          DataRowTop := DataRowBottom;
          DataRowBottom := DataRowTop + DataRowHeight;
        End; { If }

        { Get next data row }
        GetNextDataRow;

        { Check there is room for another row, If Not break out and print a new page }
        If (DataRowBottom > TabBot) Then Begin
          If GotDataRow Then Begin
            { Starting a new page - print remaining controls on current }
            { pages body first.                                         }
            PBThrown := True;
            PrintRemainingBody;

            TheReport.NewPage;

            { Prints all the body controls except for the table }
            PrintFullNonTableBody;
          End; { If }
          Break;
        End; { If }
      End; { While }
    End; { While }
  End; { PaintTableData }

begin
  { Check to see if any columns are visible }
  Got1VisCol := False;
  If (Columns.Count > -1) Then
    For Col1 := 0 To (Columns.Count - 1) Do
      With TFormDefListObjType(Columns.Items[Col1]).FormDef Do Begin
        Case fdFieldClass Of
          fdcFieldCol   : Got1VisCol := Not FieldCol.fdHidden;
          fdcFormulaCol : Got1VisCol := Not FormulaCol.ffHidden;
        End; { Case }

        { Finish loop if found a visible column }
        If Got1VisCol Then Break;
      End; { With }

  If Got1VisCol Then Begin
    { Have at least 1 visible column }
    FTable := TableObject.Create;
    FTable.InitTable;
    FTable.SetTableRec (TheTable);

    Repeat
      With TheReport, TheTable, FTable Do Begin
        { Calculate the table size }
        TabLeft  := frXPos + 1;
        TabTop   := frYPos + 1;
        TabRight := TabLeft + CalcRight - 1;
        TabBot   := TabTop + frHeight - 2;

        { Calculate the font height of the header font }
        HdrFontHeight := FontHeight (Self.Canvas, Hdr, True);
        HdrFontHeight := Round(HdrFontHeight / DefaultPixPerMM);
        { Calculate the top of the rows section }
        If Enabled[Hdr] Then
          RowTop := TabTop + HdrFontHeight + 1    { MH: Added + 1 - 23/10/96 }
        Else
          RowTop := TabTop;

        { Paint column Separators }
        PaintColSeps;

        { Paint row separators }
        PaintRowSeps;

        { Paint Table borders }
        RepDrawLine (TheReport, Tbl_LeftLine,   TabLeft,  RowTop, TabLeft,  TabBot);
        RepDrawLine (TheReport, Tbl_RightLine,  TabRight, RowTop, TabRight, TabBot);
        RepDrawLine (TheReport, Tbl_BottomLine, TabLeft,  TabBot, TabRight, TabBot);

        { Paint header }
        If Enabled[Hdr] Then Begin
          { Paint column headers }
          PaintColHeaders;

          { Paint table header borders }
          RepDrawLine (TheReport, Hdr_LeftLine,  TabLeft,  TabTop, TabLeft,  RowTop);
          RepDrawLine (TheReport, Hdr_RightLine, TabRight, TabTop, TabRight, RowTop);
          RepDrawLine (TheReport, Hdr_TopLine,   TabLeft,  TabTop, TabRight, TabTop);
        End; { If }

        { Paint table top line - this must overwrite the column headers if nec. }
        RepDrawLine (TheReport, Tbl_TopLine,    TabLeft,  RowTop, TabRight, RowTop);

        { Paint data into the rows }
        PaintTableData;
      End; { With }
    Until Not GotDataRow;

    FTable.Free;
  End; { if }
End; { PrintTable }

Procedure TForm_PrintTest.PrintGroup (Const TheGroup : FormDefRecType);
Var
  ThisGrpCtrls, RowList              : TSBSList;
  I, RowTop, RowBot, CurrRow, PrnTop : SmallInt;
  OneMore                            : Boolean;

  { builds a list of controls in ThisGrpCtls which are positioned }
  { in the current row, and will be printed                       }
  Procedure BuildRowList;
  Var
    TheControl : FormDefRecType;
    I, YPos    : SmallInt;
  Begin
    { make sure its empty }
    While (RowList.Count > 0) Do RowList.Delete(0);

    If (ThisGrpCtrls.Count > 0) Then Begin
      I := 0;

      Repeat
        TheControl := TFormDefListObjType(ThisGrpCtrls.Items[I]).FormDef;
        { Check its in this row }
        With TheControl Do
          Case fdFieldClass Of
            fdcText    : YPos := Text.ftYPos;
            fdcLine    : YPos := Line.flYPos1;
            fdcBitmap  : YPos := Bitmap.fbYPos;
            fdcTable   : YPos := Table.frYPos;
            fdcPage    : YPos := PageNo.fpYPos;
            fdcFormula : YPos := Formula.ffYPos;
            fdcBox     : YPos := Box.fxYPos;
            fdcDbfield : YPos := DbField.fdYPos;
            fdcGroup   : YPos := Group.fgYPos;
          End; { Case }

        If (YPos >= RowTop) And (YPos <= RowBot) Then Begin
          { Add into current row's control list }
          If WantPrint (TheControl) Then
            RowList.Add (ThisGrpCtrls.Items[I]);

          { delete from groups control list }
          ThisGrpCtrls.Delete(I);
          Dec (I);
        End; { If }

        Inc (I);
      Until (I > (ThisGrpCtrls.Count -1));
    End; { If }
  End;

  { adjusts the control def to the current row position }
  Procedure PrintGroupControl (ControlDef : FormDefRecType);
  Begin
    With ControlDef Do Begin
      Case fdFieldClass Of
        fdcText    : Text.ftYPos    := PrnTop + (Text.ftYPos - RowTop);
        fdcLine    : Begin
                       Line.flYPos1 := PrnTop + (Line.flYPos1 - RowTop);
                       Line.flYPos2 := PrnTop + (Line.flYPos2 - RowTop);
                     End;
        fdcBitmap  : Bitmap.fbYPos  := PrnTop + (Bitmap.fbYPos - RowTop);
        fdcTable   : Table.frYPos   := PrnTop + (Table.frYPos - RowTop);
        fdcPage    : PageNo.fpYPos  := PrnTop + (PageNo.fpYPos - RowTop);
        fdcFormula : Formula.ffYPos := PrnTop + (Formula.ffYPos - RowTop);
        fdcBox     : Box.fxYPos     := PrnTop + (Box.fxYPos - RowTop);
        fdcDbfield : DbField.fdYPos := PrnTop + (DbField.fdYPos - RowTop);
        fdcGroup   : Group.fgYPos   := PrnTop + (Group.fgYPos - RowTop);
      End; { Case }
    End; { With }

    PrintControl (ControlDef);
  End;

begin
  With TheReport, TheGroup, Group Do Begin
    ThisGrpCtrls := TSBSList.CreateList ('PGroup');
    Try
      RowList := TSBSList.CreateList ('GrpRow');
      Try
        { Get a list of controls in this group }
        If (GroupedCtrls.Count > 0) Then
          For I := 0 To (GroupedCtrls.Count - 1) Do
            If (TFormDefListObjType(GroupedCtrls.Items[I]).FormDef.fdGroup = TheGroup.fdControlId) Then
              ThisGrpCtrls.Add (GroupedCtrls.Items[I]);

        { check there are controls to print }
        If (ThisGrpCtrls.Count > 0) Then Begin
          RowTop  := fgYPos;      { actual row top as designed }
          PrnTop  := fgYPos;      { actual row top as printing }
          CurrRow := 1;
          OneMore := (fgRows[CurrRow] = 0);{False;}

          While (GroupedCtrls.Count > 0) And
                (CurrRow <= High(fgRows)) And
                (RowTop < (fgYPos + fgHeight)) And
                ((fgRows[CurrRow] > 0) Or OneMore) Do Begin
            { update row dimensions }
            If (Not OneMore) Then
              RowBot := fgYPos + fgRows[CurrRow] - 1
            Else
              RowBot := fgYPos + fgHeight;

            { build a sub list of controls in this row to be printed }
            BuildRowList;
            If (RowList.Count > 0) Then Begin
              While (RowList.Count > 0) Do Begin
                PrintGroupControl (TFormDefListObjType(RowList.Items[0]).FormDef);
                RowList.Delete(0);
              End; { While }

              { update print position for this row height }
              PrnTop := PrnTop + (RowBot - RowTop) + 1;
            End; { If }

            { update rowtop for next row }
            RowTop := RowBot + 1;
            Inc(CurrRow);
            OneMore := (Not OneMore) And (fgRows[CurrRow] = 0);
          End; { While }
        End; { If }
      Finally
        While (RowList.Count > 0) Do RowList.Delete(0);  { just in case }
        RowList.Free;
      End;
    Finally
      While (ThisGrpCtrls.Count > 0) Do ThisGrpCtrls.Delete (0);
      ThisGrpCtrls.Free;
    End;
  End; { With }
End;

Function TForm_PrintTest.WantPrint (Const ControlDef : FormDefRecType) : Boolean;
Var
  IfRec       : fdIfInfoType;
  Res         : Boolean;
  TheFormula  : String;
  ParserObj   : TParserObj;
Begin { WantPrint }
{DBug.MsgI(0,'WantPrint: ' + ControlDef.fdControlId, 3);}
  Result := True;

  With ControlDef Do
    Case fdFieldClass Of
      fdcText       : IfRec := Text.ftIf;
      fdcLine       : IfRec := Line.flIf;
      fdcBitmap     : IfRec := Bitmap.fbIf;
      fdcTable      : IfRec := Table.frIf;
      fdcPage       : IfRec := PageNo.fpIf;
      fdcFormula    : IfRec := Formula.ffIf;
      fdcBox        : IfRec := Box.fxIf;
      fdcDbfield    : IfRec := DbField.fdIf;
      fdcGroup      : IfRec := Group.fgIf;
      fdcFieldCol   : IfRec := FieldCol.fdIf;
      fdcFormulaCol : IfRec := FormulaCol.ffIf;
    End; { Case }

  If (Trim(IfRec.fiIf) <> '') Then Begin
    Recurse.SetFormula(1, IfRec.fiIf);

    { Create new instance of the parser object }
    ParserObj := TParserObj.Create;
    Try
      { Copy formula into string }
      TheFormula := Trim(IfRec.fiIf);

      { Set event links }
      ParserObj.GetDBFEvent := Form_PrintTest.GetDBFEvent;
      ParserObj.GetFMLEvent := Form_PrintTest.GetFMLEvent;
      ParserObj.GetTBCEvent := Form_PrintTest.GetTBCEvent;
      ParserObj.GetTBPEvent := Form_PrintTest.GetTBPEvent;
      ParserObj.GetTBTEvent := Form_PrintTest.GetTBTEvent;
      ParserObj.GetTRWEvent := Form_PrintTest.GetTRWEvent;
      ParserObj.GetDocSignEvent   := Form_PrintTest.GetDocSign;
      ParserObj.GetCustNoteEvent  := Form_PrintTest.GetCustNote;
      ParserObj.GetSuppNoteEvent  := Form_PrintTest.GetSuppNote;
      ParserObj.GetInvNoteEvent   := Form_PrintTest.GetInvNote;
      ParserObj.GetStockNoteEvent := Form_PrintTest.GetStockNote;
      ParserObj.GetSNoNoteEvent   := Form_PrintTest.GetSNoNote;
      ParserObj.GetJobNoteEvent   := Form_PrintTest.GetJobNote;
      ParserObj.GetPageNoEvent    := Form_PrintTest.GetPageNo;
      ParserObj.GetIdQtyEvent     := GetIdQtyNo;
      ParserObj.GetFmtDateEvent   := FormatDate;
      ParserObj.GetCcyEvent       := GetCurrRate;
      // MH 01/11/2013 v7.x MRD2.4.24: Added Load Role function to load a specific contacts details on demand
      ParserObj.GetLoadRoleEvent  := GetLoadRole;

      Res := ParserObj.Evaluate_Expression (TheFormula, False);

      {If Debug Then
        ShowMessage ('Page: ' + IntToStr(PageNo) + CRLF +
                     'Control: ' + ControlDef.fdControlId + CRLF +
                     'Form: ' + TheFormula + CRLF +
                     'Res: ' + IIF (Res, 'True', 'False') + CRLF +
                     'Status: ' + IIF (ParserObj.FormulaErr, 'Error', 'Ok') + CRLF +
                     'ErrPos: ' + IntToStr(ParserObj.FormulaErrPos) + CRLF +
                     'ErrType: ' + IntToStr(Ord(ParserObj.FormulaErrType)));}

      Result := Res And (Not ParserObj.FormulaErr);
    Finally
      { Free the parser }
      ParserObj.Free;
    End;
  End; { If }
{DBug.Msg (0, 'Result: ' + IntToStr(Ord(Result)));
DBug.Indent(-3);}
End;  { WantPrint }

Procedure TForm_PrintTest.PrintTMControl (Const ControlDef : FormDefRecType; Fill : Boolean);
Var
  TheRect : TRect;
Begin
  With ControlDef, TheReport Do Begin
    Case fdFieldClass Of
      fdcTable      : With Table Do TheRect := Rect(frXPos, frYPos, frXPos + frWidth, frYPos + frHeight);
      fdcFormula    : With Formula Do TheRect := CreateRect(ffXPos, ffYPos, ffXPos + ffWidth, ffYPos + ffHeight);
      fdcDbfield    : With DbField Do TheRect := CreateRect(fdXPos, fdYPos, fdXPos + fdWidth, fdYPos + fdHeight);
    Else
      Exit;           { Bomb Out - as it ain't handled here }
    End; { Case }

    SetPen  (clBlack, psSolid, -1, pmCopy);
    If Fill Then Begin
      SetBrush (clBlack, bsSolid, Nil);
      FillRect (TheRect);
    End { If }
    Else Begin
      SetBrush (clBlack, bsClear, Nil);
      Rectangle (TheRect.Left, TheRect.Top, TheRect.Right, TheRect.Bottom);
    End; { Else }
  End; { With }
End;

Procedure TForm_PrintTest.PrintControl (Const ControlDef : FormDefRecType);
begin
  If Recurse.StartCheck(ControlDef.fdControlId) Then Begin
{DBug.Clear;
DBug.Msg (0, 'PrintControl: ' + ControlDef.fdControlId);
DBug.Indent(3);}
    If WantPrint (ControlDef) Then
      With ControlDef Do
        Case fdFieldClass Of
          fdcText    : PrintText (Text);
          fdcLine    : PrintLine (Line);
          fdcBitmap  : PrintBitmap (Bitmap);
          fdcTable   : If (Not TestMode) Then
                         PrintTable (Table)
                       Else
                         PrintTMControl (ControlDef, False);
          fdcPage    : PrintPageNo (PageNo);
          fdcFormula : If (Not TestMode) Then Begin
                         If (Not Formula.ffHidden) Then
                           PrintFormula(Formula);
                       End { If }
                       Else
                         PrintTMControl (ControlDef, True);
          fdcBox     : PrintBox (Box);
          fdcDbfield : If (Not TestMode) Then
                         PrintDbField (ControlDef)
                       Else
                         PrintTMControl (ControlDef, True);
          fdcGroup   : PrintGroup (ControlDef);
        End; { Case }

    {Application.ProcessMessages;}

{DBug.Msg (0, 'Printed');
DBug.Indent(-3);}
    Recurse.EndCheck (ControlDef.fdControlId);
  End; { If }

  Recurse.ClearHistory;
end;

{ Prints controls in passed list }
procedure TForm_PrintTest.PrintControlList (Const ControlList : TSBSList);
Var
  I, PrevLastControl : Integer;
begin
  PrevLastControl    := LastControlPrinted;
  LastControlPrinted := 0;

  If (ControlList.Count > 0) And (Not AbortBatch) Then
    For I := 0 To (ControlList.Count - 1) Do Begin
      { Print It }
      LastControlPrinted := I;
      PrintControl (TFormDefListObjType(ControlList.Items[I]).FormDef);

      If AbortBatch Then Break;
    End; { For }

  LastControlPrinted := PrevLastControl;
end;

procedure TForm_PrintTest.PrintRemainingBody;
Var
  I : Integer;
begin
  { Check we've got something to print - and we haven't printed it already }
  If (BodyList.Count > 0) And (LastControlPrinted < (BodyList.Count - 1)) Then
    For I := (LastControlPrinted + 1) To (BodyList.Count - 1) Do
      { Print It }
      PrintControl (TFormDefListObjType(BodyList.Items[I]).FormDef);
end;

{ This is a quick and dirty fix so that the 2nd page, etc, print properly }
procedure TForm_PrintTest.PrintFullNonTableBody;
Var
  I : Integer;
begin
  { Check we've got something to print - and we haven't printed it already }
  If (BodyList.Count > 0) Then
    For I := 0 To LastControlPrinted{(BodyList.Count - 1)} Do
      { Print It }
      If (TFormDefListObjType(BodyList.Items[I]).FormDef.fdFieldClass <> fdcTable) Then
        PrintControl (TFormDefListObjType(BodyList.Items[I]).FormDef);
end;

{**************************************************************}
{* General Printing Events                                    *}
{**************************************************************}
procedure TForm_PrintTest.PrnDef_BeforePrint(Sender: TObject);
Var
  I : Integer;
begin
  DrivingFile := InvF;    { Better than nothing }
  FormPurpose := 0;       { Ditto }
  PageNo := 0;
  TotItems := 0;
  AbortBatch := False;
{TheReport.NoBufferLine := True;}


  { redirect to correct event }
  Case RepType Of
    rtTestForm   : TestSize_BeforePrint(Sender);
    rtTestLabel  : TestLbl_BeforePrint(Sender);
    rtTestReport : ;
    rtDevForm    : PrintForm_BeforePrint(Sender);
    rtDevLabel   : PrintLabel_BeforePrint(Sender);
    rtDevReport  : ;
    rtBatch      : Batch_BeforePrint(Sender);
    rtBatchLabel : BatchLbl_BeforePrint(Sender);
  End; { Case }

  SendProgress (0, 1);

  { Initialise column totals }
  If (Columns.Count > 0) Then
    For I := 0 To (Columns.Count - 1) Do
      With TFormDefListObjType(Columns.Items[I]), FormDef Do Begin
        ValueSet   := False;
        LastString := '';
        LastValue  := 0.0;
        CurrString := '';
        CurrValue  := 0.0;
      End; { With }

  { Initialise the table printing stuff }
  RowCount := 0;
  If Assigned (GetNextDataRow) Then GetNextDataRow;
end;

procedure TForm_PrintTest.PrnDef_NewPage(Sender: TObject);
begin
  PBThrown := False;
  Inc(PageNo);
  Label_Page.Caption := IntToStr (PageNo);

  { redirect to correct event }
  Case RepType Of
    rtTestForm   : { No Event Required };
    rtTestLabel  : ;
    rtTestReport : ;
    rtDevForm    : ;
    rtDevLabel   : ;
    rtDevReport  : ;
    rtBatch      : ;
    rtBatchLabel : ;
  End; { Case }
end;

procedure TForm_PrintTest.PrnDef_PageHeader(Sender: TObject);
begin
  { redirect to correct event }
  Case RepType Of
    rtTestForm   : { No Event Required };
    rtTestLabel  : ;
    rtTestReport : ;
    rtDevForm    : PrintForm_PrintHeader(Sender);
    rtDevLabel   : ;
    rtDevReport  : ;
    rtBatch      : Batch_PrintHeader(Sender);
    rtBatchLabel : ;
  End; { Case }
end;

procedure TForm_PrintTest.PrnDef_Print(Sender: TObject);
Var
  ErrRect : TRect;
begin
//ShowMessage ('PrnTitle: ' + TheReport.Title);

  { redirect to correct event }
  Case RepType Of
    rtTestForm    : TestSize_Print(Sender);
    rtTestLabel   : TestLbl_Print(Sender);
    rtTestReport  : ;
    rtDevForm     : PrintForm_Print(Sender);
    rtDevLabel    : PrintLabel_Print(Sender);
    rtDevReport   : ;
    rtBatch       : Batch_Print(Sender);
    rtBatchLabel  : BatchLbl_Print(Sender);
  End; { Case }

  If AbortBatch Then
    With TheReport Do Begin
      { Print White Rectangle }
      SetPen  (clWhite, psSolid, -1, pmCopy);
      SetBrush (clWhite, bsSolid, Nil);
      ErrRect := CreateRect (0, PageHeight - BottomWaste - 30, PageWidth, PageHeight);
      FillRect (ErrRect);

      { Print message on white rectangle }
      SetFont ('Arial', 22);
      TheReport.Canvas.Font.Color := clBlack;
      SetPen (clBlack, pssolid, -1, pmCopy);
      SetBrush (clWhite, bsClear, Nil);
      Bold := True;
      Underline := True;

      (* HM 15/01/02: Modified for direect PDF printing
      ErrRect := CreateRect (0, PageHeight - BottomWaste - 20, PageWidth, PageHeight);
      ExtTextRect (ErrRect, DT_CENTER, 'ABORTED BY USER');
      *)
      ExtTextRect2 ('ABORTED BY USER', taCenter, 0, PageHeight - BottomWaste - 20, PageWidth, PageHeight);
    End; { With }
end;

procedure TForm_PrintTest.PrnDef_PageFooter(Sender: TObject);
Var
  PWidth, X1, X2, Y1, Y2 : Double;
begin
  { redirect to correct event }
  Case RepType Of
    rtTestForm    : { No Event Required };
    rtTestLabel   : ;
    rtTestReport  : ;
    rtDevForm     : PrintForm_PrintFooter(Sender);
    rtDevLabel    : ;
    rtDevReport   : ;
    rtBatch       : Batch_PrintFooter(Sender);
    rtBatchLabel : ;
  End; { Case }

  If Syss.ExDemoVer Or ForceDemoVer Then Begin
    { Print 'Demo' bitmap }
    With TheReport Do Begin
      TransparentBitmaps := True;

      X1 := PageWidth * 0.25;
      X2 := PageWidth - X1;

      PWidth := (X2 - X1) * 0.09;
      Y1 := (PageHeight * 0.7) - (PWidth / 2);
      Y2 := Y1 + PWidth;

      If EnterpriseLicence.ISLite Then
        PrintBitmapRect2(X1, Y1, X2, Y2, Image2.Picture.BitMap)
      Else
        PrintBitmapRect2(X1, Y1, X2, Y2, Image1.Picture.BitMap);
    End; { With TheReport }
  End; { If Syss.ExDemoVer }
end;

procedure TForm_PrintTest.PrnDef_AfterPrint(Sender: TObject);
begin
  { redirect to correct event }
  Case RepType Of
    rtTestForm    : { No Event Required };
    rtTestLabel   : ;
    rtTestReport  : ;
    rtDevForm     : ;
    rtDevLabel    : PrintLabel_AfterPrint(Sender);
    rtDevReport   : ;
    rtBatch       : Batch_AfterPrint(Sender);
    rtBatchLabel : ;
  End; { Case }

  SendProgress (TotItems, 1);
end;


{ Called before each new row is printed }
Procedure TForm_PrintTest.PrnDef_StartDataRow;
Var
  I : Integer;
begin
  { Initialise column totals }
  If (Columns.Count > 0) Then
    For I := 0 To (Columns.Count - 1) Do
      With TFormDefListObjType(Columns.Items[I]), FormDef Do Begin
        If (RowCount = 1) Then Begin
          ValueSet   := False;
          LastString := '';
          LastValue  := 0.0;
          CurrString := '';
          CurrValue  := 0.0;
          TotalValue := 0.0;
        End { If }
        Else Begin
          ValueSet   := False;
          LastString := CurrString;
          LastValue  := CurrValue;
          CurrString := '';
          CurrValue  := 0.0;
        End; { Else }
      End; { With }

  If Assigned (StartDataRow) Then
    StartDataRow;
end;

{**************************************************************}
{* General Print Setup Routines                               *}
{**************************************************************}
Procedure TForm_PrintTest.SortDefList (Const DefList : TSBSList);
Var
  ListObj, NewObj : TFormDefListObjType;
  I               : Integer;
begin
  If (DefList.Count > 0) Then
    For I := 0 To (DefList.Count - 1) Do Begin
      { Take copy of object }
      ListObj := TFormDefListObjType(DefList.Items[I]);

      { Check we want it }
      If (ListObj.FormDef.fdRepClass In [fdrPageHead,
                                         fdrPageBodyHead,
                                         fdrPageBody,
                                         fdrPageBodyFoot,
                                         fdrPageFoot,
                                         fdrColumn]) Then Begin
        { Create a new object for printing use }
        NewObj := TFormDefListObjType.Create;
        NewObj.FormDef := ListObj.FormDef;

        If (Trim(NewObj.FormDef.fdGroup) = '') Then
          Case NewObj.FormDef.fdRepClass Of
            fdrPageHead     : HeaderList.Add (NewObj);
            fdrPageBodyHead : BodyHeadList.Add (NewObj);
            fdrPageBody     : BodyList.Add (NewObj);
            fdrPageBodyFoot : BodyFootList.Add (NewObj);
            fdrPageFoot     : FooterList.Add (NewObj);
            fdrColumn       : Columns.Add (NewObj);
          End { Case }
        Else
          GroupedCtrls.Add (NewObj);

        If (NewObj.FormDef.fdFieldClass = fdcFormula) Then Begin
          { Also add into the formulas list }
          Formulas.Add (NewObj);
        End; { If }
      End; { If }
    End; { For }
end;

Procedure TForm_PrintTest.SetHedRec (Const HedRec : fdHeaderRecType);
begin
  HeaderRec := HedRec;
end;

Procedure TForm_PrintTest.SetOrientation (Const Orient : fdOrientationType);
begin
  Try
    Case Orient Of
      fdoPortrait  : TheReport.Orientation := {RpBase}RpDefine.poPortrait;
      fdoLandscape : TheReport.Orientation := {RpBase}RpDefine.poLandscape;
    Else
      TheReport.Orientation := {RpBase}RpDefine.poDefault;
    End; { Case }
  Except //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
    On Exception Do DoMessageDlg ('An error occurred setting the printer orientation', mtError, [mbOk], 0);
  End;
end;

Procedure TForm_PrintTest.SetStrRec (Const StrRec : fdFormStringsType);
begin
  StringRec := StrRec;
end;

Procedure TForm_PrintTest.SetLabelInfo (Const PrnLabel, NoLabels : LongInt);
Begin
  LblStart  := PrnLabel;    { 1st label available for printing }
  LblRepeat := NoLabels;    { Number of labels to print in label preview mode }
End;

Procedure TForm_PrintTest.SetControlList (Const DefList : TSBSList);
begin
  SortDefList (DefList);
end;

Procedure TForm_PrintTest.InitPrintType (Const ReportType   : RepTypeType;
                                         Const PrinterNo    : Integer;
                                         Const WantPreview  : Boolean;
                                         Const WantCopies   : SmallInt;
                                         Const IsTestMode   : Boolean;
                                         Const ChequeMode   : Boolean;
                                         Const PrnInfo      : TSBSPrintSetupInfo);
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

      Case RepDest Of
        rdPrinter   : TheReport := ReportPrinter1; { Printer }
        rdPrintFile : TheReport := ReportFiler1;   { File for Multiple Copies }
        rdPreview   : TheReport := ReportFiler1;   { File for Preview Window }
      End; { Case }
    End; { If }
  End { If }
  Else Begin
    { Fax / Email / File }
    Copies := 1;

    { Email/Faxing - always print to file first, so the number of pages can be printed }
    If WantPreview Then
      RepDest := rdPreview
    Else
      RepDest := rdPrintFile;
    TheReport := ReportFiler1;
  End; { Else }

  { This may work if we're really lucky and its Tuesday } { HM 03/03/99: Note sure what this means! }
  TheReport.PrinterIndex := PrinterNo;
  TheReport.Title := PrnInfo.feJobtitle;
//ShowMessage ('ReqTitle: ' + PrnInfo.feJobtitle + #13 + 'ActTitle: ' + TheReport.Title);

  // HM 18/07/02: Added Bitmap caching
  CacheList.Clear;
end;

Procedure TForm_PrintTest.SendProgress (Const CurrItem : SmallInt;Const Mode : Byte);
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

Procedure TForm_PrintTest.PrintReport (Const WinTitle : ShortString;
                                             PrnInfo  : TSBSPrintSetupInfo);
Var
  RepFName          : String;
  DefExt            : String[4];
  PrevCur           : TCursor;
  FVar              : Integer;
  I                 : SmallInt;
  Locked            : Boolean;
  BaseDir           : ShortString;
  PreviewMode       : Integer;
begin
  CursorToHourglass (PrevCur);

  Try
    If (RepType <> GlobType.rtNone) Then Begin
      If (RepDest In [rdPrintFile, rdPreview]) Then Begin
        (****
        If (OutMethod = 1) Or ((OutMethod In [2, 4]) And (PrnInfo.feEmailAtType = 0)) Then
          DefExt := '.EDF'
        Else
          DefExt := '.SWP';

        { Generate Unique Filename for report file }
        FVar := 0;
        GetTempFilePath (BaseDir);
        Repeat
          RepFName := BaseDir + '!REP' + IntToStr(FVar) + DefExt;
          Inc (FVar);
        Until (Not FileExists (RepFName)) Or (FVar > 9999);
        If (FVar > 9999) Then
          Raise ENoUnique.Create('Cannot Find Unique Filename');
        ****)

        // MH 12/03/2012 v6.10 ABSEXCH-11937: Stash reports locally in Windows\Temp folder rather
        // than uploading them to the network Exchequer\Swap folder, this should improve performance
        // and lower network traffic slightly.
        If (OutMethod = 1) Or ((OutMethod In [2, 4]) And (PrnInfo.feEmailAtType = 0)) Then
          RepFName := GetWinTempPrintingFilename ('.EDF')
        Else
          RepFName := GetWinTempPrintingFilename ('.SWP');

        ReportFiler1.FileName := RepFName;
      End; { If }

      { Update System records, Switches & VAT }
      Locked := False; GetMultiSys(BOff, Locked, VATR);
      Locked := False; GetMultiSys(BOff, Locked, SysR);
      { HM 28/09/99: Modified for increased currency table }
      //Locked := False; GetMultiSys(True, Locked, CurR);
      //Locked := False; GetMultiSys(True, Locked, GCUR);
      Locked := False; GetMultiSysCur(True, Locked);
      Locked := False; GetMultiSysGCur(True, Locked);
      // HM 03/03/04: Extended for JC/CIS/AppsVals
      Locked := False; GetMultiSys(BOff, Locked, JobSR);
      Locked := False; GetMultiSys(BOff, Locked, CISR);

      { Set Print Job Information for data dictionary }
      PrintJobInfo^ := PrnInfo;

      // HM 16/01/02: Determine method used to print text
      If (PrnInfo.fePrintMethod In [2, 4]) And (PrnInfo.feEmailAtType In [2, 3]) Then Begin
        // Sending Email with either RAVE PDF or RAVE HTML format attachments - use
        // standard RAVE commands to allow Renderer components to convert output
        PrintTextMethod := ptmRAVECommands;
      End { If }
      Else
        // Use bespoke commands - as used since the original release of Exchequer
        PrintTextMethod := ptmDrawText;


      { Print Report to File }
      PageNo := 0;
      TheReport.Execute;

      If (PrnInfo.fePrintMethod In [2, 4]) Then
        PrnInfo.feEmailFName := PrintJobInfo^.feEmailFName;

      // HM 13/09/02: Form Printing Toolkit requirements very different - added IfDef
      //              to allow it to be completely separate so that I don't accidentally
      //              break the normal system
      {$IFNDEF FORMTK}
        If (RepDest In [rdPrintFile, rdPreview]) Then Begin
          { Printing to file - check that they want to see it if they aborted }
          If (Not AbortBatch) Or
             (AbortBatch And (MessageDlg ('Do you want to print the processed part of batch',
                              mtConfirmation, [mbYes, mbNo], 0) = mrYes) ) Then Begin
            If (RepDest = rdPreview) Then Begin
              { Deallocate the form if its assigned }
              { Decide how the previews going to work }
              PreviewMode := 1;
              If (SystemInfo.MainForm.FormStyle = fsMDIForm) Then
                PreviewMode := 2;

              { Preview }
              CreatingPreview := True;
              Form_PrintPreview := TForm_PrintPreview.Create(SystemInfo.MainForm);
              CreatingPreview := False;

              Form_PrintPreview.SetPrintInfo(PrnInfo);

              Form_PrintPreview.FilePreview1.FileName := RepFName;
              Form_PrintPreview.FilePreview1.PrinterIndex := TheReport.PrinterIndex;
              Form_PrintPreview.FilePrinter1.FileName := RepFName;
              Form_PrintPreview.FilePrinter1.PrinterIndex := TheReport.PrinterIndex;
              Form_PrintPreview.SetMode (PreviewMode);
              Form_PrintPreview.NoCopies := Copies;

              Form_PrintPreview.SetCaption (WinTitle);
              {If (Trim(WinTitle) <> '') Then
                Form_PrintPreview.Caption := Form_PrintPreview.Caption + ' - ' + Trim(WinTitle);}

              If (PreviewMode = 1) Then Begin
                SendProgress (0, 0); { Clear progress }

                { Preview window is a modal normal window }
                CursorForDialog;
                Form_PrintPreview.ShowModal;
                CursorFromDialog;

                { Memory automatically deallocated by close }

                { Reset the preview pointer }
                Form_PrintPreview := Nil;
              End { If }
              Else Begin
                { Preview window must be a non-modal child }
                {PreviewForms.Add (Form_PrintPreview);}
                AddPrevWin (TForm(Form_PrintPreview));
                Form_PrintPreview.Position  := Forms.poDefault;
                Form_PrintPreview.FormStyle := fsMDIChild;
                Form_PrintPreview.DoMenu;
                Form_PrintPreview.Show;
                Form_PrintPreview.StartPreview;
              End; { Else }
            End { If }
            Else Begin
              If (OutMethod = 0) Then Begin
                { Printing To Printer - print intermediate file to printer }
                FilePrinter1.FileName := RepFName;
                FilePrinter1.PrinterIndex := TheReport.PrinterIndex;

                For I := 1 To Copies Do Begin
                  FilePrinter1.Execute;
                End; { For }

                DeletePrintFile (FilePrinter1.FileName);
              End { If }
              Else Begin
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

                DeletePrintFile (RepFName);
              End; { Else }
            End; { Else }
          End { If }
          Else Begin
            { Aborted - Delete print file }
            DeletePrintFile (ReportFiler1.FileName);
          End; { Else }
        End; { If }
      {$ELSE} { FORMTK }
        If (RepDest = rdPrintFile) And (OutMethod = 0) And (Copies > 1) Then Begin
          // Printing multiple copies direct to printer
          FilePrinter1.FileName := RepFName;
          FilePrinter1.PrinterIndex := TheReport.PrinterIndex;

          For I := 1 To Copies Do Begin
            FilePrinter1.Execute;
          End; { For }

          // Remove .swp file 
          DeletePrintFile (FilePrinter1.FileName);
        End { If (RepDest = rdPrintFile) ... }
        Else
          // Printing to Tempfile - return FTK information
          If Assigned(PrnInfo.feDataPtr) Then
            With pFormToolkitData(PrnInfo.feDataPtr)^ Do Begin
              ftdTempFile := ReportFiler1.FileName;
              ftdPages := PageNo;
            End; { With pFormToolkitData(PrnInfo.feDataPtr)^ }
      {$ENDIF}

      { Aborted }
      SendProgress (0, 0);   { Clear progress }
    End; { If }
  Except
    On EStreamError Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
      DoMessageDlg ('Stream Error:' + CRLF + CRLF +
                  'An error has occured creating the print file for the form, ''' +
                  RepFName + ''', form aborted.', mtError, [mbOk], 0);

    On ENoUnique Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
      DoMessageDlg ('Filename Error:' + CRLF + CRLF +
                  'No unique filename could be found' + CRLF + CRLF +
                  'Form Aborted.', mtError, [mbOk], 0);
  End;

  RestoreCursor (PrevCur);
End;

//-----------------------------------------------------------------------------

Procedure AddPrevWin (Var TheForm : TForm);
Begin
  If Assigned (PreviewForms) Then Begin
    { Wait until list is available }
    While PFListLocked Do Application.ProcessMessages;

    { Add new form into list }
    PFListLocked := True;
    PreviewForms.Add (TheForm);
    PFListLocked := False;
  End; { If }
End;

Function NumPrevWins : LongInt;
Begin
  Result := 0;

  If Assigned (PreviewForms) Then Begin
    { Wait until list is available }
    While PFListLocked Do Application.ProcessMessages;

    PFListLocked := True;
    Result := PreviewForms.Count;
    PFListLocked := False;
  End; { If }
End;

Procedure FreePrevWins;
Var
  PrevForm : TForm;
Begin
  { Wait until list is available }
  While PFListLocked Do Application.ProcessMessages;

  If Assigned(PreviewForms) Then Begin
    { Free all the preview windows }
    PFListLocked := True;
    While (PreviewForms.Count > 0) Do Begin
      Try
        PrevForm := PreviewForms.Items[0];

        PreviewForms.Delete(0);

        PrevForm.Close;
        PrevForm.Free;
      Except
        { hide all errors }
      End;
    End; { While }
    PFListLocked := False;
  End; { If }
End;


Procedure NFClosePrevWindows;
Var
  I        : SmallInt;
Begin { NFClosePrevWindows }
  If Assigned(PreviewForms) Then
    If (PreviewForms.Count > 0) Then
      With TSBSList.CreateList('CopyList') Do
        Try
          // Copy all form handles out of PreviewForms list
          PFListLocked := True;
          For I := 0 To Pred(PreviewForms.Count) Do
            Add (Pointer(TForm(PreviewForms.Items[I]).Handle));
          PFListLocked := False;

          // Send close message to all forms
          For I := 0 To Pred(Count) Do
            SendMessage (LongInt(Items[I]), WM_Close, 0, 0);

          // remove entries from list
          While (Count > 0) Do
            Delete (0);
        finally
          Destroy;
        End;
End; { NFClosePrevWindows }


{ Frees a preview form handle when used with the mdi parent window }
Procedure FreeFormHandle (Const FormHandle : HWnd);
Var
  TmpForm : TForm_PrintPreview;
  I       : Integer;
Begin
  If (SystemInfo.MainForm.FormStyle = fsMDIForm) And Assigned (PreviewForms) Then Begin
    { Wait until list is available }
    While PFListLocked Do Application.ProcessMessages;

    If (PreviewForms.Count > 0) Then
      For I := 0 To (PreviewForms.Count -1) Do Begin
        TmpForm := PreviewForms.Items[I];

        If (TmpForm.Handle = FormHandle) Then Begin
          { Found specified form - Delete instance from list }
          PreviewForms.Delete(I);
          Break;
        End; { If }
      End; { For }
  End; { If }
End;


Procedure PreviewPrintFile (Const PrnInfo             : TSBSPrintSetupInfo;
                            Const PrintFile, WinTitle : ShortString);
Var
  PrevCur     : TCursor;
  PreviewMode : Integer;
begin
{$IFDEF MHPRT}
  With PrnInfo Do
    ShowMessage ('PreviewPrintFile: ' + PrintFile + #10#13 +
                 'Printer: ' + IntToStr(DevIdx) + #10#13 +
                 'Preview: ' + IntToStr(Ord(Preview)) + #10#13 +
                 'Form: ' + IntToStr(FormNo) + '/' + FormName + #10#13 +
                 'Bin: ' + IntToStr(BinNo) + '/' + BinName);
{$ENDIF}

  CursorToHourglass (PrevCur);

  RpDev.SetPrnSetup(PrnInfo);

  { Preview }
  CreatingPreview := True;
  Form_PrintPreview := TForm_PrintPreview.Create(SystemInfo.MainForm);
  CreatingPreview := False;
  Try
    PreviewMode := 1;
    If (SystemInfo.MainForm.FormStyle = fsMDIForm) Then
      PreviewMode := 2;

    Form_PrintPreview.SetPrintInfo(PrnInfo);

    Form_PrintPreview.FilePreview1.FileName := PrintFile;
    Form_PrintPreview.FilePreview1.PrinterIndex := PrnInfo.DevIdx;
    Form_PrintPreview.FilePrinter1.FileName := PrintFile;
    Form_PrintPreview.FilePrinter1.PrinterIndex := PrnInfo.DevIdx;
    Form_PrintPreview.SetMode (PreviewMode);

    If (Trim(WinTitle) <> '') Then
      Form_PrintPreview.Caption := Form_PrintPreview.Caption + ' - ' + Trim(WinTitle);

    If (PreviewMode = 1) Then Begin
      { Preview window is a modal normal window }
      CursorForDialog;
      Form_PrintPreview.ShowModal;
      CursorFromDialog;

      { Memory automatically deallocated by close }

      { Reset the preview pointer }
      Form_PrintPreview := Nil;
    End { If }
    Else Begin
      { Preview window must be a non-modal child }
      {PreviewForms.Add (Form_PrintPreview);}
      AddPrevWin (TForm(Form_PrintPreview));
      Form_PrintPreview.Position  := Forms.poDefault;
      Form_PrintPreview.FormStyle := fsMDIChild;
      Form_PrintPreview.DoMenu;
      Form_PrintPreview.StartPreview;
    End; { Else }
  Except
    On EStreamError Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
      DoMessageDlg ('Stream Error:' + CRLF + CRLF +
                  'An error has occured creating the print file for the form, ''' +
                  PrintFile + ''', form aborted.', mtError, [mbOk], 0);
  End;

  RestoreCursor (PrevCur);

{$IFDEF MHPRT}
  ShowMessage ('PreviewPrintFile - finished');
{$ENDIF}
End;

//-------------------------------------------------------------------------

Procedure ConvertEDFToXLS (Const EDFPath, XLSPath : ShortString; Const AutoOpen : Boolean);
Var
  _enRender             : THandle;
  _enrConvertEDFToExcel : Function (Const EDFPath : ShortString; Const XLSPath : ShortString) : Longint; StdCall;
  FuncRes               : LongInt;
  XLSFile               : ANSIString;
Begin // ConvertEDFToXLS
  // Check for enRender.Dll utility library
  If FileExists (ExtractFilePath(Application.ExeName) + 'ENRENDER.DLL') Then
  Begin
    // dynamically load DLL and use enrConvertEDFToExcel function to convert the EDF format file
    _enRender := LoadLibrary('ENRENDER.DLL');

    // Check return value for success
    If (_enRender > HInstance_Error) Then
    Begin
      // Try to get a handle to the enrConvertEDFToExcel function
      _enrConvertEDFToExcel := GetProcAddress(_enRender, 'enrConvertEDFToExcel');

      // Check return value for success
      If Assigned(_enrConvertEDFToExcel) Then
      Begin
        // Call enrConvertEDFToExcel to convert the EDF File to an XLS worksheet
        FuncRes := _enrConvertEDFToExcel(EdfPath, XLSPath);

        If (FuncRes = 0) And FileExists(XLSPath) Then
        Begin
          // Check to see if user wants to automatically open the XLS file
          If AutoOpen Then
          Begin
            XLSFile := XLSPath;
            ShellExecute(Application.MainForm.Handle,       // Parent Window
                         'open',                            // Operation
                         PChar(XLSFile),                    // FileName
                         '',                                // Params
                         PChar(ExtractFilePath(XLSPath)),   // Default Dir
                         SW_SHOWNORMAL);                    // Show
          End; // If AutoOpen
        End // If (FuncRes = 0)
        Else
          MessageDlg ('Error ' + IntToStr(FuncRes) + ' printing to XLS - Please notify your Technical Support', mtError, [mbOk], 0);
      End // If Assigned(_enrConvertEDFToExcel)
      Else
        // Error getting function handle
        MessageDlg ('Error ' + IntToStr(GetLastError) + ' accessing function handles in enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);

      // Unload enRender.DLL
      FreeLibrary(_enRender);
    End // If (_enRender > HInstance_Error)
    Else
      // Error loading enRender.DLL
      MessageDlg ('Error ' + IntToStr(GetLastError) + ' loading enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);
  End // If FileExists (...
  Else
    // enRender.Dll missing
    MessageDlg ('Error loading enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);
End; // ConvertEDFToXLS


//-------------------------------------------------------------------------

Procedure ConvertEDFToHTML (Const EDFPath, HTMLPath : ShortString; Const AutoOpen : Boolean);
Var
  _enRender             : THandle;
  _enrConvertEDFToHTML  : Function (Const EDFPath : ShortString; Const HTMLPath : ShortString) : Longint; StdCall;
  FuncRes               : LongInt;
  HTMLFile              : ANSIString;
Begin // ConvertEDFToHTML
  // Check for enRender.Dll utility library
  If FileExists (ExtractFilePath(Application.ExeName) + 'ENRENDER.DLL') Then
  Begin
    // dynamically load DLL and use enrConvertEDFToExcel function to convert the EDF format file
    _enRender := LoadLibrary('ENRENDER.DLL');

    // Check return value for success
    If (_enRender > HInstance_Error) Then
    Begin
      // Try to get a handle to the enrConvertEDFToHTML function
      _enrConvertEDFToHTML := GetProcAddress(_enRender, 'enrConvertEDFToHTML');

      // Check return value for success
      If Assigned(_enrConvertEDFToHTML) Then
      Begin
        // Call enrConvertEDFToHTML to convert the EDF File to HTML/CSS files
        FuncRes := _enrConvertEDFToHTML(EdfPath, HTMLPath);

        If (FuncRes = 0) And FileExists(HTMLPath) Then
        Begin
          // Check to see if user wants to automatically open the XLS file
          If AutoOpen Then
          Begin
            HTMLFile := HTMLPath;
            ShellExecute(Application.MainForm.Handle,       // Parent Window
                         'open',                            // Operation
                         PChar(HTMLFile),                   // FileName
                         '',                                // Params
                         PChar(ExtractFilePath(HTMLFile)),  // Default Dir
                         SW_SHOWNORMAL);                    // Show
          End; // If AutoOpen
        End // If (FuncRes = 0)
        Else
          MessageDlg ('Error ' + IntToStr(FuncRes) + ' printing to HTML - Please notify your Technical Support', mtError, [mbOk], 0);
      End // If Assigned(_enrConvertEDFToExcel)
      Else
        // Error getting function handle
        MessageDlg ('Error ' + IntToStr(GetLastError) + ' accessing function handles in enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);

      // Unload enRender.DLL
      FreeLibrary(_enRender);
    End // If (_enRender > HInstance_Error)
    Else
      // Error loading enRender.DLL
      MessageDlg ('Error ' + IntToStr(GetLastError) + ' loading enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);
  End // If FileExists (...
  Else
    // enRender.Dll missing
    MessageDlg ('Error loading enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);
End; // ConvertEDFToHTML

//-------------------------------------------------------------------------

// CJS 2015-01-16 - ABSEXCH-16032 - temporary file error on closing VAT Return
Procedure PrintFileTo (Const PrnInfo             : TSBSPrintSetupInfo;
                       Const PrintFile, WinTitle : ShortString);
Var
  DeleteFileAfterPrint: Boolean;
begin
  DeleteFileAfterPrint := True;
  PrintFileToEx(PrnInfo, PrintFile, WinTitle, DeleteFileAfterPrint);
End;

// CJS 2015-01-16 - ABSEXCH-16032 - temporary file error on closing VAT Return
Procedure PrintFileToEx  (Const PrnInfo             : TSBSPrintSetupInfo;
                          Const PrintFile, WinTitle : ShortString;
                          Const DeleteFileAfterPrint: Boolean); Export;
Var
  FPrintPrev : TForm_PrintPreview;
  PrevCur    : TCursor;
  I          : Integer;
  PrnFName   : ShortString;
begin
{$IFDEF MHPRT}
  With PrnInfo Do
    ShowMessage ('PrintFileTo: ' + PrintFile + #10#13 +
                 'Printer: ' + IntToStr(DevIdx) + #10#13 +
                 'Preview: ' + IntToStr(Ord(Preview)) + #10#13 +
                 'Form: ' + IntToStr(FormNo) + '/' + FormName + #10#13 +
                 'Bin: ' + IntToStr(BinNo) + '/' + BinName + #10#13 +
                 'Copies: ' + IntToStr(NoCopies));
{$ENDIF}

  CursorToHourglass (PrevCur);

  PrnFName := PrintFile;

  If PrnInfo.Preview Then
    PreviewPrintFile (PrnInfo, PrnFName, WinTitle)
  Else Begin
    Try
      RpDev.SetPrnSetup(PrnInfo);

      CreatingPreview := True;
      FPrintPrev := TForm_PrintPreview.Create(SystemInfo.MainForm);
      CreatingPreview := False;
      Try
        Case PrnInfo.fePrintMethod Of
          0 : Begin // Print file to Printer
                FPrintPrev.FilePrinter1.FileName := PrnFName;
                FPrintPrev.FilePrinter1.PrinterIndex := PrnInfo.DevIdx;
                For I := 1 To PrnInfo.NoCopies Do
                  FPrintPrev.FilePrinter1.Execute;
              End; // Print file to Printer

          1 : Begin // Fax via MAPI or Exchequer
                Case PrnInfo.feFaxMethod Of
                  { via Exchequer }
                  0 : SendEntFax (PrnInfo, FPrintPrev.FilePrinter1, PrnFName, True);
                  { via MAPI }
                  1 : SendMAPIFax (PrnInfo, PrnFName);
                  { Third-Party Fax Software }
                  2 : SendEntFax (PrnInfo, FPrintPrev.FilePrinter1, PrnFName, False);
                Else
                  MessageDlg ('Unknown Fax Method (' + IntToStr(PrnInfo.feFaxMethod) + ') - Fax not sent',
                              mtError, [mbOk], 0);
                End; { Case }
              End; // Fax via MAPI or Exchequer

          2 : Begin // Email via MAPI/Exchequer
                SendEmailFile (PrnInfo, FPrintPrev.FilePrinter1, PrnFName);
              End; // Email via MAPI/Exchequer

          // 3 : XML Not Supported

          //PR 02/02/07: Added ability to print directly to file
           4 : SendEmailFile (PrnInfo, FPrintPrev.FilePrinter1, PrnFName);

          // HM 01/08/03: Added Print To Excel support for v5.52
          5 : Begin // Excel
                ConvertEDFToXLS (PrintFile, PrnInfo.feXMLFileDir, PrnInfo.feMiscOptions[1]);
              End; // Excel

          // 6 : Text?

          // HM 22/03/04: Added Print To HTML support for v5.60
          7 : Begin // Excel
                ConvertEDFToHTML (PrintFile, PrnInfo.feXMLFileDir, PrnInfo.feMiscOptions[1]);
              End; // Excel
        Else
          Raise Exception.Create ('SbsForm.PrintFileTo - fePrintmethod ' + IntToStr(PrnInfo.fePrintMethod) +
                                  ' not supported - please notify your Technical Support');
        End; // Case PrnInfo.fePrintMethod
      Finally
        FPrintPrev.Free;
      End;
    Except
      On Ex:Exception Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
        DoMessageDlg ('The following error occured attempting to print:' +
                    #10#13#10#13 +
                    '''' + Ex.Message + '''.', mtError, [mbOk], 0);
    End;

    // CJS 2015-01-16 - ABSEXCH-16032 - temporary file error on closing VAT Return
    if DeleteFileAfterPrint then
      DeletePrintFile (PrnFName);
  End; { Else }

  RestoreCursor (PrevCur);

{$IFDEF MHPRT}
  ShowMessage ('PrintFileTo - finished');
{$ENDIF}
End;

Function PrintInCreate : Boolean;
Begin
  Result := CreatingPreview;
End;

(*Procedure PrintPos;
Begin
  ShowMessage('Spare: ' + IntToStr(LongInt(@JobDetl^.JobReten.Spare) - LongInt(@JobDetl^) + 1));
  ShowMessage('JAnalName: ' + IntToStr(LongInt(@JobDetl^.JobReten.JAnalName) - LongInt(@JobDetl^) + 1));
  ShowMessage('Spare2: ' + IntToStr(LongInt(@JobDetl^.JobReten.Spare2) - LongInt(@JobDetl^) + 1));
End;*)

Procedure SendMAPIFax (Const PrnInfo : TSBSPrintSetupInfo;
                       Const FName   : ShortString);
Var
  EmailO : TEntEmail;
  Res    : SmallInt;
Begin { SendMAPIFax }
  EmailO := TEntEmail.Create;
  Try
    Try
      With EmailO Do Begin
        UseMAPI := True;

        { Set From details }
        Sender := PrnInfo.feFaxFrom;
        SenderName := PrnInfo.feFaxFromNo;

        { Set To Details }
        Recipients.Add ('[FAX:' + Trim(PrnInfo.feFaxToNo) + ']');

        { Attach fax job }
        Attachments.Add (Fname);

        { Send Fax }
        // HM 25/01/05: Don't unload EntComms.Dll if running VAO
        Res := EmailO.Send(VAOInfo.vaoMode <> smVAO);

        If (Res > 0) Then Begin
          { Raise exception to report error }
          Raise EEmailErr.Create(EmailErr(Res));
        End; { If }
      End; { With EmailO }
    Except
      On Ex:Exception Do
        MessageDlg ('The following error occurred sending a fax to ''' + Trim(PrnInfo.feFaxTo) +
                    ''' on ''' + Trim(PrnInfo.feFaxToNo) + ''':' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
    End;
  Finally
    EmailO.Destroy;
  End;
End; { SendMAPIFax }


Procedure SendEmailFile2 (Const PrnInfo     : TSBSPrintSetupInfo;
                          Const FilePrinter : TFilePrinter;
                          Const FName       : ShortString;
                          Const DelFile     : Boolean);
Var
  IniF             : TIniFile;
  PDFName, IniName : ShortString;
  EmailO  : TEntEmail;
  Res     : SmallInt;
  SysDir  : PChar;
  OrigPDFFile, OrigFile, ZipFile, PDFFile : ShortString;
  RenderPDF : TRPRenderPDF;
  NDRStream : TMemoryStream;
  SentData : pSentimailData;
  RenderHTML : TRPRenderHTML;
  RenderUtil : TRenderingUtils;
  ExitTime   : TDateTime;
  TimeOut    : Boolean;
  OldFName,
  NewFName   : AnsiString;

  FriendlyFileName : ShortString;

  Procedure SplitRecipients (RecipStr  : AnsiString;
                             RecipAddr : TStringList;
                             DebugDesc : ShortString);
  Var
    ColPos           : Integer;
    RecName, RecAddr : ShortString;
  Begin { SplitRecipients }
    { Clear out any existing crap }
    RecipAddr.Clear;

    RecipStr := Trim(RecipStr);
    If (RecipStr <> '') Then Begin
      While (RecipStr <> '') Do Begin
        { look for end of name }
        ColPos := Pos (';', RecipStr);
        If (ColPos > 0) Then Begin
          { Extract name from recipients string }
          RecName := Copy (RecipStr, 1, Pred(ColPos));
          Delete (RecipStr, 1, ColPos);

          { look for end of address }
          ColPos := Pos (';', RecipStr);
          If (ColPos > 0) Then Begin
            { Extract Address from recipients string }
            RecAddr := Copy (RecipStr, 1, Pred(ColPos));
            Delete (RecipStr, 1, ColPos);

            RecipAddr.Add (RecAddr);
          End { If }
          Else
            { Address not found - end loop }
            Break;
        End { If }
        Else
          { Name not found - end loop }
          Break;
      End; { While }
    End; { If }

//    If (RecipAddr.Count > 0) Then
//    Begin
//      For ColPos := 0 To RecipAddr.Count - 1 Do
//      Begin
//        ShowMessage (DebugDesc + ' ' + IntToStr(ColPos+1) + ': ' + RecipAddr.Strings[ColPos]);
//      End; // For ColPos
//    End // If (RecipAddr.Count > 0)
//    Else
//      ShowMessage ('No ' + DebugDesc + ' recipients');
  End; { SplitRecipients }

  Procedure SplitAttachments (AttachStr  : AnsiString;
                              AttachList : TStringList);
  Var
    ColPos   : Integer;
    AttPath  : ShortString;
  Begin { SplitAttachments }
    { Clear out any existing crap }
    AttachList.Clear;

    AttachStr := Trim(AttachStr);
    While (AttachStr <> '') Do Begin
      { look for end of attachment }
      ColPos := Pos (';', AttachStr);
      If (ColPos > 0) Then Begin
        { Extract name from recipients string }
        AttPath := Copy (AttachStr, 1, Pred(ColPos));
        If FileExists (AttPath) Then
          AttachList.Add (AttPath);

        { Remove Crud }
        Delete (AttachStr, 1, ColPos);
        AttachStr := Trim(AttachStr);
      End { If (ColPos > 0) }
      Else Begin
        If FileExists (AttachStr) Then
          AttachList.Add (AttachStr);
        Break;
      End; { Else }
    End; { While }
  End; { SplitAttachments }

  { Adds all files in the specified directory as attachment }
  Procedure AddAttachments(      AttachList : TStringList;
                           Const DirPath : ShortString);
  Var
    NetFInfo : TSearchRec;
    SrchRes  : Integer;
  Begin { AddAttachments }
    { Check Directory exists }
    If DirectoryExists (DirPath) Then Begin
      { check 1+ files exist on network with matching name (including wildcards) }
      SrchRes := FindFirst(DirPath + '\*.*', faAnyFile, NetFInfo);
      While (SrchRes = 0) Do Begin
        If ((NetFInfo.Attr And faDirectory) <> faDirectory) Then Begin
          { Not a subdirectory - Check to see if a local file exists }
          AttachList.Add (DirPath + NetFInfo.Name);
        End { If }
        Else Begin
          { Subdirectory }
          If (NetFInfo.Name <> '.') And (NetFInfo.Name <> '..') Then Begin
            { Valid Directory - need to call function recursivly to copy subdirectories }
            AddAttachments(AttachList, DirPath + NetFInfo.Name + '\');
          End; { If }
        End; { Else }

        SrchRes := FindNext(NetFInfo);
      End; { While }

      // HM 08/12/03: Found this was missing when copying the code for another app
      FindClose (NetFInfo);
    End; { If }
  End; { AddAttachments }

  { Zips the specified file to a self-extracting ZIP file and deletes the original }
  Function ZipMeBaby(Const PDFname : ShortString; Const ZipType : Byte) : ShortString;
  Var
    ZipO : TEntZip;
  Begin { ZipMeBaby }
    Result := PDFName;

    ZipO := TEntZip.Create;
    Try
      With ZipO Do Begin
        DOSPaths := True;
        StripPath := True;
        Files.Add (PDFName);
        If (ZipType = 2) And (PrnInfo.feEmailAtType = 0) Then
          // Zip EDF files to registered EDZ extension
          ZipName := ChangeFileExt(PDFName, '.EDZ')
        Else
          ZipName := ChangeFileExt(PDFName, '.ZIP');

        Res := Save;

        If (Res = 0) Then Begin
          Result := ZipName;
          ZIPFile := Result;
        End { If }
        Else
          { Error } //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
          DoMessageDlg ('The following error occurred during compression:' + #13#13 +
                      '''' + ZipErr(Res) + '''.', mtError, [mbOk], 0);
      End; { With ZipO }
    Finally
      ZipO.Destroy;
    End;
    (****
    With TAbZipKit.Create(Application.MainForm) Do
      Try
        // Set misc options
        DOSMode := True;
        StoreOptions := [soStripDrive, soStripPath, soRemoveDots];

        // Set Destination .ZIP file }
        If (ZipType = 2) Then Begin
          // EDZ - Exchequer Document (Zipped)
          ForceType := True;
          ArchiveType := atZip;

          FileName := ChangeFileExt(PDFName, '.EDZ')
        End { If (ZipType = 2) }
        Else
          // Normal PK-ZIP format .ZIP file
          FileName := ChangeFileExt(PDFName, '.ZIP');

        // Add files to ZIP
        AddFiles (PDFName, 0);

        Save;

        Result := FileName;
        ZIPFile := Result;
      Finally
        Free;
      End;
    ****)
  End; { ZipMeBaby }

  { Copies the !REP0.EDF style file locally and changes the name to something friendlier }
  Procedure RenameOutFile (Var PDFName : ShortString; Const NewName : ShortString);
  Var
    TmpPath, FileFr,
    DestExt, DestPath : AnsiString;
    Res1              : LongInt;
    I                 : SmallInt;
  Begin { RenameOutFile }
    If FileExists (PDFName) Then Begin
      // Get path of windows temporary directory
      TmpPath := StringOfChar (' ', 255);
      Res1 := GetTempPath(Length(TmpPath), PChar(TmpPath));
      SetLength (TmpPath, Res1);
      TmpPath := IncludeTrailingBackslash(TmpPath);

      // Check to see if 'friendly name' available in temp directroy
      DestExt := ExtractFileExt (PDFName);
      DestPath := TmpPath + NewName + DestExt;
      If FileExists(DestPath) Then Begin
        // Generate unique 'friendly name' in destination directory
        For I := 1 To 999 Do Begin
          DestPath := TmpPath + NewName + '(' + IntToStr(I) + ')' + DestExt;

          If (Not FileExists(DestPath)) Then
            // AOK - file doesn't exist
            Break;
        End; { For I }
      End; { If FileExists(DestPath) }

      // Check a unique name was found
      If Not FileExists(DestPath) Then Begin
        // Copy file across
        FileFr := PDFName;
        If CopyFile (PCHAR(FileFr), PCHAR(DestPath), True) Then
          // Copy succeeded - switch attachment to new file
          PDFName := DestPath;
      End; { If Not FileExists(DestPath) }
    End; { If FileExists (PDFName) }
  End; { RenameOutFile }

  // Checks for and sets the Adove PDF Writer registry entries
  Procedure Check4RegEntries;
  Begin { Check4RegEntries }
    With TRegistry.Create Do
      Try
        Access := KEY_READ or KEY_WRITE;

        RootKey := HKEY_CURRENT_USER;

        If OpenKey('Software\Adobe\Acrobat PDFWriter', False) Then Begin
          WriteString('szAuthor', 'Exchequer');
          WriteString('szTitle', 'Exchequer Email');
          WriteString('PDFFileName', PDFName);
          WriteString('FileNameSet', '1');
          WriteString('bDocInfo', '0');
        End; { If }

        CloseKey;
      Finally
        Free;
      End;
  End; { Check4RegEntries }

  //------------------------------

  // Returns True if for Adobe Acrobat 6.0 is detected
  Function GotAdobeCrapobat6 : Boolean;
  Begin // GotAdobeCrapobat6
    With TRegistry.Create Do
      Try
        Access  := KEY_READ;
        RootKey := HKEY_CURRENT_USER;

        // MH 02/12/2010 v6.4 ABSEXCH-10578: Added support for Adobe Acrobat 9
        // MH 06/12/2010 v6.4 ABSEXCH-10578: Added support for Adobe Acrobat 10
        Result := KeyExists ('Software\Adobe\Adobe Acrobat\6.0') Or
                  KeyExists ('Software\Adobe\Adobe Acrobat\9.0') Or
                  KeyExists ('Software\Adobe\Adobe Acrobat\10.0');
      Finally
        Free;
      End;

//ShowMessage ('GotAdobeCrapobat6: ' + IntToStr(Ord(Result)));
  End; // GotAdobeCrapobat6

  //------------------------------

  // Enumerate the printers to get the Port which contains the output filename
  Function GetAdobeCrapobat6PDFDir (PrnName : ShortString) : ShortString;
  Var
    PrinterInfoArray  : Pointer;
    PrinterInfo5      : PPrinterInfo5;
    Needed            : DWORD;
    Returned          : DWORD;
    I                 : SmallInt;
  Begin // GetAdobeCrapobat6PDFDir
    Result := '';
    PrnName := UpperCase(Trim(PrnName));

    // Find out how much memory required for the array of printer structures
    EnumPrinters(PRINTER_ENUM_LOCAL, NIL, 5, NIL, 0, Needed, Returned);

    // Allocate the memory for the array of printer structures
    GetMem(PrinterInfoArray,Needed);
    Try
      // Get the array of printer structures
      If EnumPrinters(PRINTER_ENUM_LOCAL, NIL, 5, PrinterInfoArray, Needed, Needed, Returned) Then
      Begin
        // Returned indicates the number of records returns by EnumPrinters
        If (Returned > 0) Then
          For I := 0 To (Returned - 1) Do
          Begin
            // Calculate the position of the current printer info element within the memory block
            PrinterInfo5 := Pointer(LongInt(PrinterInfoArray) + (I * SizeOf(TPrinterInfo5)));

//ShowMessage ('SearchName: ' + PrnName + #13 +
//             'PrinterName: ' + PrinterInfo5^.pPrinterName + #13 +
//             'PortName: ' + PrinterInfo5^.pPortName);

            If (Pos(UpperCase(Trim(PrinterInfo5^.pPrinterName)), PrnName) = 1) Then
            Begin
              // Got matching name - extract path from Port and finish loop
              Result := ExtractFilePath(PrinterInfo5^.pPortName);
              Break;
            End; // If (PrnName = UpperCase(Trim(PrinterInfo5^.pPrinterName))
          End; // For I
      End; // If EnumPrinters(...
    Finally
      FreeMem(PrinterInfoArray,Needed);
    End;
  End; // GetAdobeCrapobat6PDFDir

  //------------------------------

  // Returns a unique path+filename within the specified dir
  Function UniqueFilePath (Const FileDir : ShortString) : ShortString;
  Var
    FVar : SmallInt;
  Begin // UniqueFilePath
    FVar := 0;

    Repeat
      Result := FileDir + '!PDF' + IntToStr(FVar) + '.PDF';
      Inc (FVar);
    Until (Not FileExists (Result)) Or (FVar > 9999);

    If (FVar > 9999) Then
      Raise ENoUnique.Create('Cannot Find Unique Filename');
  End; // UniqueFilePath

  //------------------------------

Begin { SendEmailFile2 }
  OrigFile := FName;
  ZipFile  := '';
  PDFFile  := '';
  OrigPDFFile := '';
  DebugOut('SendEmailFile2 Start');

  { Get path of Win\SYS directory }
  SysDir := StrAlloc(255);
  GetSystemDirectory(SysDir, 255);
  IniName := SysDir;
  If (Length(IniName) > 0) Then
    If (IniName[Length(IniName)] <> '\') Then
      IniName := IniName + '\';

  Case PrnInfo.feEmailAtType Of
    // ADOBE Acrobat
    // HM 14/08/03: Modified to work with Adobe Acrobat 6.0
    1 : If (Not GotAdobeCrapobat6) Then
        Begin
           DebugOut('SendEmailFile2 Acrobat <> v6');
          { Adobe Acrobat - print intermediate file to PDF Writer }
          If ISWINNT Or ISWINNT4 Or ISWINNT5 Then Begin
            { Windows NT - Any Version }
            If FileExists(IniName + 'SPOOL\DRIVERS\W32X86\2\__PDF.INI') Then
              IniName := IniName + 'SPOOL\DRIVERS\W32X86\2\__PDF.INI'
            Else
              If FileExists(IniName + 'SPOOL\DRIVERS\W32X86\__PDF.INI') Then
                IniName := IniName + 'SPOOL\DRIVERS\W32X86\__PDF.INI'
              Else
                IniName := IniName + '__PDF.INI';
          End { If }
          Else Begin
            { Windows 9x }
            IniName := IniName + 'PDFWRITR.INI';
          End; { Else }

          DebugOut('SendEmailFile2 IniName=' + IniName);


          // HM 02/05/01: Moved from within the Try..Finally below
          // HM 26/06/00: Modified as not creating file in SWAP directory
          //PDFName := ExtractFilePath(Application.ExeName) + ChangeFileExt(ExtractFileName(FName), '.PDF');
          PDFName := ChangeFileExt(FName, '.PDF');
          DebugOut('SendEmailFile2 PDFName=' + PDFName);

          If (IniName <> '') And FileExists(IniName) Then Begin
            { Setup the PDF Writer .INI file }
            IniF := TIniFile.Create(IniName);
            Try
              IniF.WriteString ('Acrobat PDFWriter', 'PDFFileName', PDFName);
              IniF.WriteInteger ('Acrobat PDFWriter', 'bDocInfo', 0);
              IniF.WriteInteger ('Acrobat PDFWriter', 'FileNameSet', 1);
              IniF.WriteString ('Acrobat PDFWriter', 'szTitle', 'Exchequer Email');
              IniF.WriteString ('Acrobat PDFWriter', 'szAuthor', 'Exchequer');
            Finally
              IniF.Destroy;
            End;
          End; { If (IniName <> '') And FileExists(IniName) }

          Check4RegEntries;

          { Print the intermediate file to the PDF Writer printer driver }
          FilePrinter.FileName := FName;
          FilePrinter.PrinterIndex := PrnInfo.DevIdx;
          FilePrinter.Execute;

          PDFFile := PDFName;
        End // If (Not GotAdobeCrapobat6)
        Else Begin
            DebugOut('SendEmailFile2 Acrobat v6');

          // Adobe ACrobat 6.0
//ShowMessage ('Acrobat 6.0' + #13 +
//             'Current Printer: ' + RpDev.Printers[RpDev.DeviceIndex] + #13 +
//             'Print Job Title: ' + PrnInfo.feJobtitle + #13 +
//             'Internal Filename: ' + FName);

          // Determine the output directory for the Job
          PDFName := GetAdobeCrapobat6PDFDir(RpDev.Printers[RpDev.DeviceIndex]);

          // Determine a unique filename within that dir for the job
          PDFName := UniqueFilePath (PDFName);
          DebugOut('SendEmailFile2 PDFName=' + PDFName);

//ShowMessage ('Temp PDF Filename: ' + PDFName + #13 + ChangeFileExt(ExtractFileName(PDFName), ''));

          // Print the intermediate file to the Adobe PDF printer driver - should
          // create the file in the Port directory (see GetAdobeCrapobat6PDFDir)
          // with the unique name put into the PrintTitle property
          FilePrinter.FileName := FName;
          FilePrinter.PrinterIndex := PrnInfo.DevIdx;
          FilePrinter.PrintTitle := ChangeFileExt(ExtractFileName(PDFName), '');
          FilePrinter.Execute;

          // Now wait for Adobe Distiller to get its arse in gear and create the file -
          // this could take a while for big reports so retry automatically for 30
          // seconds + 1/2 sec per page
          ExitTime := IncSecond(Now, 30 + (FilePrinter.Pages Div 2));
          TimeOut := False;
          Repeat
            // Wait for 1/2 second to allow Distiller time to do its thang
            Delay(500, True);

            // Exit the loop if we have passed the timeout
            Timeout := (Now > ExitTime);
            If TimeOut Then
            Begin
            {$If not Defined(SENTMAIL) and not Defined(FORMTK)}
              If (MessageDlg('The Adobe PDF File has not yet been created, this could be caused by the print job ' +
                             'being very big, or because the system is incorrectly configured.' + #13#13 +
                             'Do you want to wait for another 30 seconds?', mtConfirmation, [mbYes,mbNo], 0) = mrYes) Then
            {$IfEnd}
              Begin
                DebugOut('SendEmailFile2 Retry create PDF file');

                TimeOut := False;
                ExitTime := IncSecond(Now, 30); // Retry automatically for another 30 seconds
              End; // If (MessageDlg(...) = mrYes)
            End; // If TimeOut
          Until FileExists(PDFName) Or TimeOut;

          If FileExists(PDFName) Then
          Begin
            DebugOut('SendEmailFile2 PDF file exists');

            // NOTE: Occaisonally get errors from ecSendEmail saying it can't open the file, the theory
            // is that Distiller is still writing the file at that point, so loop around until we
            // can get exclusive access to the file or we timeout (5 secs + 1/5th sec per page
            ExitTime := IncSecond(Now, 5 + (FilePrinter.Pages Div 5));
            TimeOut := False;
            Repeat
              Try
                With TFileStream.Create(PDFName, fmOpenRead Or fmShareExclusive) Do
                Begin
                  Try
                    // Opened successfully - exit loop and send email
                    TimeOut := True;  // Naughty! using Timeout to store success status!
                  Finally
                    Free;
                  End;
                End; // With TFileStream.Create(..
              Except
                On E:Exception Do
                  // Wait for 1/2 second to allow Distiller time to do its thang
                  Delay(500, True);
              End;
            Until TimeOut Or (Now > ExitTime);
          End; // If FileExists(PDFName)

          PDFFile := PDFName;
        End; // Else

    // RAVE PDF
    2 : Begin
          PDFName := ChangeFileExt(FName, '.PDF');
          DebugOut('SendEmailFile2 Rave PDF: PDFName=' + PDFName);

          RenderPDF := TRPRenderPDF.Create(Application.MainForm);
          NDRStream := TMemoryStream.Create;
          If WantPDFCompression Then RenderUtil := TRenderingUtils.Create;
          Try
            If WantPDFCompression Then Begin
              RenderPDF.UseCompression := True;
              RenderPDF.OnCompress := RenderUtil.CompressPDF;
            End; { If WantPDFCompression }
            RenderPDF.InitFileStream (PDFName);

            NDRStream.LoadFromFile (FName);
            With TRPConverter.Create (NDRStream, RenderPDF) Do
              Try
                Generate;
              Finally
                Free;
              End;
          Finally
            RenderPDF.Free;
            NDRStream.Free;
            If WantPDFCompression Then FreeAndNIL(RenderUtil);
          End;

          PDFFile := PDFName;
        End; // RAVE PDF

    // RAVE HTML
    3 : Begin
          PDFName := ChangeFileExt(FName, '.HTM');
          DebugOut('SendEmailFile2 Rave HTML: PDFName=' + PDFName);

          RenderHTML := TRPRenderHTML.Create(Application.MainForm);
          NDRStream := TMemoryStream.Create;
          Try
            RenderHTML.InitFileStream (PDFName);

            NDRStream.LoadFromFile (FName);
            With TRPConverter.Create (NDRStream, RenderHTML) Do
              Try
                Generate;
              Finally
                Free;
              End;
          Finally
            RenderHTML.Free;
            NDRStream.Free;
          End;

          PDFFile := PDFName;
        End; // RAVE HTML
  Else
    begin
      // 0 = Internal EDF Format
      DebugOut('SendEmailFile2 Internal EDF: PDFName=' + PDFName);
      PDFname := FName;
    end;
  End; { Case PrnInfo.feEmailAtType }

  // HM 26/06/00: Added checks for file existance
  If FileExists (PDFName) Then Begin
    { Optionally ZIP the .PDF file }
    If (PrnInfo.feEmailZIP <> 0) Then Begin
      { Do it later! }
      PDFname := ZipMeBaby(PDFname, PrnInfo.feEmailZIP);
    End; { If }

    //PR: 03/06/2011 If no user-friendly filename has been set for the
    //edf/pdf file, set one here using the OurRef of the document (ABSEXCH-11390)
    FriendlyFileName := PrnInfo.feEmailFName;
    //PR: 06/06/2011 - Now comes in with name set, unless it's a transaction in which case it will be #255
    //so populate it with Doc Ref.
    if Trim(FriendlyFileName) = #255 then
      FriendlyFileName := Inv.OurRef;

    If (FriendlyFileName <> '') Then Begin
      { Ensure original file gets deleted at end }
      OrigPDFFile := PDFName;

      { Rename outgoing file to friendlier filename }
      RenameOutFile (PDFName, FriendlyFileName);
    End; { If (PrnInfo.feEmailFName <> '') }
  End; { If FileExists (PDFName) }

  // HM 09/11/01: Added support for printing to file
  If (PrnInfo.fePrintMethod <> 4) Then Begin
    If FileExists (PDFName) Then Begin
      { Send .PDF as an email attachment }
      EmailO := TEntEmail.Create;
      Try
        Try
          With EmailO Do Begin
            { Setup email connection info }
            UseMAPI := PrnInfo.feEmailMAPI;
            SMTPServer := SyssEDI2^.EDI2Value.EmSMTP;

            // HM 02/06/00: Fixed as Name and Address around the wrong way
            { Set From details }
            SenderName := PrnInfo.feEmailFrom;
            Sender := PrnInfo.feEmailFromAd;

            { Set To Details }
            SplitRecipients (PrnInfo.feEmailTo, Recipients, 'To');
            SplitRecipients (PrnInfo.feEmailCC, CC, 'CC');
            SplitRecipients (PrnInfo.feEmailBCC, BCC, 'BCC');

            Priority := PrnInfo.feEmailPriority;

            Subject := PrnInfo.feEmailSubj;
            Message := PCHAR(PrnInfo.feEmailMsg);

            { Attach fax job }
            SplitAttachments (PrnInfo.feEmailAttach, Attachments);
            Attachments.Add (PDFname);

            { Attach Adobe Acrobat Reader }
            If PrnInfo.feEmailReader Then Begin
              { Check directory exists }
              If DirectoryExists (ExtractFilePath(Application.ExeName) + 'READER\') Then Begin
                AddAttachments(Attachments, ExtractFilePath(Application.ExeName) + 'READER\');
              End; { If }
            End; { If }

            { Send Fax }
            // HM 25/01/05: Don't unload EntComms.Dll if running VAO
            Res := EmailO.Send(VAOInfo.vaoMode <> smVAO);
            DebugOut('SendEmailFile2 EmailO.Send returned ' + IntToStr(Res));

            If (Res > 0) Then Begin
              { Raise exception to report error }
              Raise EEmailErr.Create(EmailErr(Res));
            End; { If }
          End; { With EmailO }
        Except
          On Ex:Exception Do //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
            DoMessageDlg ('The following error occurred sending an email:' + #13#13 +
                        Ex.Message, mtError, [mbOk], 0);
        End;
      Finally
        EmailO.Destroy;
      End;
    End { If }
    Else Begin //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
      { Attachment missing }
      DoMessageDlg ('The email attachment is missing, please check that the Paperless Module is correctly ' +
                  'configured in System Setup. This problem is usually caused by the wrong printer being ' +
                  'assigned as the Attachment Printer.', mtError, [mbOk], 0);
    End; { Else }
  End { If (PrnInfo.fePrintMethod <> 4) }
  Else Begin
    //Change to check if feDataPtr is assigned - if not then we're printing to file and
    //we want to copy the file to a specific destination - PrnInfo.feOutputFilename contains the destination
    if Assigned(PrnInfo.feDataPtr) then
    begin
      // Sentimail - Print to File mode
      SentData := PrnInfo.feDataPtr;
      SentData^.sdFileName := PDFName;
    end
    else
    begin
      OldFName := PDFName;
      NewFName := PrnInfo.feOutputFileName;
      if not CopyFile(PChar(OldFName), PChar(NewFName), False) then //PR: 13/05/2011 ABSEXCH-11343 Changed MessageDlg to DoMessageDlg
        DoMessageDlg('It was not possible to create the output file ' + QuotedStr(Trim(PrnInfo.feOutputFileName)),
                      mtError, [mbOK], 0);
      if DelFile then
        DeletePrintFile (PDFName);
    end;
  End; { Else }

  DebugOut('SendEmailFile2 Deleting files');
  { Delete files where necessary - need to keep PDFName for mode 4 }
  PDFName := UpperCase(PDFName);
  OrigFile := UpperCase(OrigFile);
  If DelFile Then DeletePrintFile (OrigFile);
  If (ZIPFile <> '') And (UpperCase(ZIPFile) <> OrigFile) And (UpperCase(ZIPFile) <> PDFName) Then
    DeletePrintFile (ZIPFile);
  If (PDFFile <> '') And (UpperCase(PDFFile) <> OrigFile) And (UpperCase(PDFFile) <> PDFName) Then
    DeletePrintFile (PDFFile);
  If (OrigPDFFile <> '') And (UpperCase(OrigPDFFile) <> OrigFile) And (UpperCase(OrigPDFFile) <> PDFName) Then
    DeletePrintFile (OrigPDFFile);
  If (PDFName <> '') And (PrnInfo.fePrintMethod <> 4) And (UpperCase(PDFName) <> OrigFile) Then
    DeletePrintFile (PDFName);

  StrDispose(SysDir);
  DebugOut('SendEmailFile2 End');

End; { SendEmailFile2 }


Procedure SendEmailFile (Const PrnInfo     : TSBSPrintSetupInfo;
                         Const FilePrinter : TFilePrinter;
                         Const FName       : ShortString);
Begin { SendEmailFile }
  SendEmailFile2 (PrnInfo, FilePrinter, FName, True);
End; { SendEmailFile }

Procedure SendEntFax (Const PrnInfo     : TSBSPrintSetupInfo;
                      Const FilePrinter : TFilePrinter;
                      Const FName       : ShortString;
                      Const EntFaxing   : Boolean);

  { Calculates the current time in seconds }
  Function xoCurrentTime : Double;
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

      { Calculate number of seconds since midbnight }
      Result := (lSec + (60 * (lMin + (lHour * 60)))) + (lMSec * 0.001);
    Except
      On Ex: Exception Do
        MessageDlg ('The following exception occurred in xoCurrentTime: ' +
                    #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
    End;
  End;

  Function JobComplete : Boolean;
  Begin { JobComplete }
    // HM 28/02/02: Modified for Relative Path support
    //With TInifile.Create (IncludeTrailingBackslash(SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') Do
    With TInifile.Create (CalcEnterpriseFaxingDirectory (SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') Do
      Try
        Result := NOT SectionExists (Uppercase(WinGetUserName + ':' + WinGetComputerName));
      Finally
        Free;
      End;
  End; { JobComplete }

  Procedure WaitForCompletion;
  Var
    stTime, fiTime, fiTime2, cuTime : Double;
  Begin { WaitForCompletion }
    Try
      { Get start time - this is used to detect the time wrapping around at midnight }
      stTime := xoCurrentTime;

      { Calculate timeout }
      fiTime := stTime + 30;

      Repeat
        fiTime2 := xoCurrentTime + 1;
        Repeat
          { Let other apps do something between .INI file checks }
          Application.ProcessMessages;

          { Get time again }
          cuTime := xoCurrentTime;
        Until (cuTime < stTime) Or (cuTime > fiTime2);

        { Exit loop if time has wrapped around or wait period has expired }
      Until (cuTime < stTime) Or (cuTime > fiTime) Or JobComplete;
    Except
      On Ex: Exception Do
        MessageDlg ('The following exception occurred in WaitForCompletion: ' +
                    #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
    End;
  End; { WaitForCompletion }


Begin { SendEntFax }
  Try
    // HM 22/03/01: Updated for changes by Neil in GetWindowsVersion
    // MH 03/07/07: Removed Windows Version check on PR advice
    If EntFaxing {And (GetWindowsVersion In [wv2000, wv2000TerminalServer])} Then Begin
      // HM 09/01/01: Write Document Name details to INI file if faxing via Exchequer
      //              under Windows 2000.
      // HM 28/02/02: Modified for Relative Path support
      //With TInifile.Create (IncludeTrailingBackslash(SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') Do
      With TInifile.Create (CalcEnterpriseFaxingDirectory (SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') Do
        Try
          WriteString (Uppercase(WinGetUserName + ':' + WinGetComputerName),
                       'UniqueKey',
                       PrnInfo.feJobtitle);

          {WriteString ('Debug',
                       FormatDateTime('HHNNSSZZZ', Now),
                       Uppercase(WinGetUserName + ':' + WinGetComputerName) + ':' + PrnInfo.feJobtitle);}

          UpdateFile;
        Finally
          Free;
        End;
    End; { If EntFaxing And (GetWindowsVersion = wv2000) }

    { Print the intermediate file to the Async Pro Fax driver }
    FilePrinter.FileName := FName;
    FilePrinter.PrinterIndex := PrnInfo.DevIdx;

    // HM 01/03/02: Added setting of PrintTitle as Faxed Exchequer Reports weren't having the title
    // set correctly so that the Fax Client couldn't find the details and always asked for them.
    FilePrinter.PrintTitle := PrnInfo.feJobtitle;

//ShowMessage ('Printing EntFax File: ' + PrnInfo.feJobtitle + #13 + 'InClass: ' + FilePrinter.PrintTitle);
    FilePrinter.Execute;
//ShowMessage ('After Printing EntFax File: ' + FilePrinter.PrintTitle);

    // HM 22/03/01: Updated for changes by Neil in GetWindowsVersion
    //PR 11/12/2007 Removed the check for wv2000 as we need to do this regardless of the o/s.
    If EntFaxing {And (GetWindowsVersion In [wv2000, wv2000TerminalServer])} Then
      WaitForCompletion;
  Except
    On Ex:Exception Do
        MessageDlg ('The following error occurred sending a fax to ''' + Trim(PrnInfo.feFaxTo) +
                    ''' on ''' + Trim(PrnInfo.feFaxToNo) + ''':' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
  End;
End; { SendEntFax }

//----------------------------------------------------------------------------

procedure TRenderingUtils.CompressPDF(InStream, OutStream: TStream; var CompressMethod: String);
begin
  With TCompressionStream.Create (clMax, OutStream) Do
    Try
      CopyFrom (InStream, InStream.Size);
    Finally
      Free;
    End;
end;

//----------------------------------------------------------------------------

//PR: 13/05/2011 Added new function to enable SentForm.dll to raise an exception rather than display a message ABSEXCH-11343
function DoMessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
begin
  {$If Defined(SENTMAIL) or Defined(FORMTK) }
     DebugOut(Msg);
     raise Exception.Create(Msg);
  {$Else}
     Result := MessageDlg(Msg, DlgType, Buttons, HelpCtx);
  {$IfEnd}
end;


Initialization
//ShowMessage (IntToStr(SizeOf(TSBSPrintSetupInfo)));

  {If Debug then PrintPos;}
  CreatingPreview := False;
  PFListLocked    := True;
  PreviewForms := TSBSList.CreateList('PrevWin');
  PFListLocked    := False;

  // HM 08/02/02: Added backdoor to disable Internal PDF Compression if required
  WantPDFCompression := Not FileExists (ExtractFilePath(Application.ExeName) + 'SMALLPDF.NO');
Finalization
  PreviewForms.Free;
  PreviewForms := Nil;
end.

