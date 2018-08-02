unit PostTran;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  GlobVar,IOUtil,UseTKit,UseDLLU, Enterprise01_TLB, ComObj, Classes, EBusVar, MLineLst;

type
{PR 8/03 Added functionality to match imported PINs back to original PORs. Works as follows:

  (TEbusMatching.Add:)
  If the transaction is a PIN then for each line we try to find the original order using the
  BuyersOrderNumber tag in the xml. If the order has been delivered then we can use the PDN's SOPFolio & SOPAbsLineNo to
  get back to the original order. If a match is found then we add the transaction line to either the PORlist or the
  PDNList, if not we add it to the UDList (unidentified). These steps follow (TEbusMatching.Convert):

  1. If there are any lines on the UDList we show them to the user along with possible matches, allowing other lines to
  be searched for. If a match is found then the line is added to the PORList or PDNList as appropriate.

  2. If there are any lines on the PORList then we ask the user to confirm that we should receive them. On confirmation
  we convert them to PDNs and add them to the PDNList.

  3. Finally, if there are any lines on the PDNList we convert the PDNs to PINs.

  Eek! What if the invoice values are different from the order values - eg we order 10 items @ 50p each, but the price
  goes up and they invoice us for them at 55p? How do we deal with that? Presumably after converting the order/delivery
  note to an invoice we edit the invoice and change the values. Ok let's go with that}

  TEbusMatching = Class
  private
    fUdList,
    fPORList,
    fPDNList,
    fDescList,
    fPINList : TStringList;
    fToolkit : IToolkit2;
    fCurrentRec : TPreserveLineObject;
    fSupplier : string;
    function FindOriginalOrder : Boolean;
    function FindPDNLine : Boolean;
    function FindPORLine : Boolean;
    function IsInvoicedPIN : Boolean;
    procedure AddToList(WhichList : TStringList);
    function UpdateTransValues(const OurRef : string; AList : TStringList; var HeadRec : TBatchTHRec) : integer;
    function ConvertList(AList : TStringList; var HeadRec : TBatchTHRec) : integer;
    function ReceiveOrders(var WhichPOR : integer) : integer;
    function ConvertOrders(var ListNo : integer) : integer;
    function ProcessOrders : integer;
    procedure FreeList(List : TStringList);
    function Get_HasInvoices : Boolean;
    function UpdateExistingPins(var HeadRec : TBatchTHRec) : integer;
    procedure PINsToUDs;
  public
    PostHoldFlag : Byte;
    constructor Create;
    destructor Destroy; override;

    procedure Add(Value : Pointer);
    function Convert(var HeadRec : TBatchTHRec; const DocRef : string) : integer;
    function AlreadyUsed(const OurRef : string; LineNo : longint) : Boolean;
    procedure LoadLineList(ItemNo : integer; AList : TStrings; Opts : TMatchOptions);
    procedure LoadUDList(AList : TStrings);
    procedure MatchLine(InvLine, OrderAbsLineNo : integer; const OrderRef : string);
    property Toolkit : IToolkit2 read fToolkit write fToolkit;
    property HasInvoices : Boolean read Get_HasInvoices;
  end;


  TPostTransactions = class
    private
      fRunNo : longint;
      fLogDir : string;
      fUseExtTransNo : boolean;
      fPostHoldFlag,
      fSetPeriodMethod,
      fManualPerPeriod,
      fManualPerYear : byte;
      fLogFile : TLogFile;
      fToolkit : IToolkit2;
      fMatching : TEbusMatching;
      fUseMatching : Boolean;
      fUdf1 : Boolean;
      //PR: 28/09/2012 ABSEXCH-13432|20/05/2013 ABSEXCH-11905
      fDescLinesFromXML : Boolean;
      procedure SetRunNo;
      procedure PostOriginalOrder;
      procedure ReadCompanySettings;
      procedure CreatePostingLog;
      function  TransNoOK(TransNo : string) : boolean;

      function Send_Email_Acknowldegemnt(Const CompCode  :  Str20;
                                         Const ImpInv    :  TBatchTHRec)  :  Boolean;
      procedure RenamePreserveRec(const OldRef : string;
                                  const NewRef : string;
                                  FolioNum : longint);
      function MatchTransaction(const OurRef : string; var HeadRec : TBatchTHRec) : integer;
      procedure UpdateInvoiceLines(const OurRef    : string;
                                         LineCount : longint;
                                         Lines     : Pointer);
    protected
      procedure WarnUser;

    public
      AbortRun  :  Boolean;

      destructor  Destroy; override;
      constructor Create;

      function  InsertTransaction : integer;
      procedure IterateThroughOrders(JustTagged : boolean);
      function ErrorMsg(ErrNo : integer) : string;
  end;

  procedure DeletePreserveLine(const OurRef : string;
                                     LineNo :longint);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  BtrvU2, EBusUtil, VarConst,  StrUtil,BtKeys1U,
  EBusBtrv, ETDateU, BTSupU1,  FileCtrl, Forms,  AdmnUtil, eBusCnst,
  Dialogs, SysUtils, XMLUtil, LogView, Controls, MatchLst, PINList, EtStrU, Sentimail_TLB, SecCodes;

type

  EPostTransactionsException = class(Exception);

  PTrLineArray = ^TTrLineArray;
  TTrLineArray = Array of TBatchTLRec;



//-----------------------------------------------------------------------

procedure TPostTransactions.SetRunNo;
const
  FNum = InvF;
var
  KeyS : str255;
  Status,
  KeyPath : integer;
  CurRecAddr : longint;
begin
  KeyPath := GetPosKey;
  Status := Presrv_BTPos(FNum, Keypath, F[FNum], CurRecAddr, false, false);
  try
    KeyS := FullDayBkKey(MAXLONGINT, 0, 'E');
    Status := Find_Rec(B_GetLess, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
    if Status = 0 then
      fRunNo := Inv.RunNo +1
    else
      raise EPostTransactionsException.Create('Unable to allocate new Run No.');
  finally
    Presrv_BTPos(FNum, Keypath, F[Fnum], CurRecAddr, true, true);
  end;
end; // TPostTransactions.SetRunNo

//-----------------------------------------------------------------------

procedure TPostTransactions.ReadCompanySettings;
begin
 //   fLogDir := '';
   fLogDir := GetLogFileDirectory(ebsPost);
(*    if not DirectoryExists(fLogDir) then
      fLogDir := ''; *)

(*      fUseExtTransNo := false;
      fSetPeriodMethod := 0;
//    fManualPerPeriod := EntCompPeriod;
//    fManualPerYear := EntCompYear;
      fPostHoldFlag := 0;*)

end;

//-----------------------------------------------------------------------

procedure TPostTransactions.WarnUser;
begin
  if Assigned(fLogFile) then
    MessageDlg(Format('One or more transactions could not be posted.' + CRLF +
      'Refer to error log %s for details.', [fLogFile.FileName]), mtWarning, [mbOK], 0);
end;

//-----------------------------------------------------------------------

procedure TPostTransactions.CreatePostingLog;
begin
  try
    fLogFile := TLogFile.Create(IncludeTrailingBackSlash(fLogDir) + Format('%.8d.LOG', [fRunNo]));
    with fLogFile do
    begin
      WriteLogLine('Exchequer E-Business Module XML Posting Log File');
      WriteLogLine(GetCopyrightMessage);
      WriteLogLine(DateTimeToStr(Now));
      WriteLogLine('');
  //    WriteLogLine('Posting from company ***COMP***');
      WriteLogLineFmt('Posting from company %s: %s', [CurCompSettings.CompanyCode,
                                                       CurCompSettings.CompanyName]);
      WriteLogLine('');
    end;
  except
    on EInOutError do ;
      // IO Error
  end;
end; // TPostTransactions.CreatePostingLog

//-----------------------------------------------------------------------

procedure TPostTransactions.PostOriginalOrder;
// Notes : Need to set the Run No on the order in the E-Business day book.
//         Any Run No > 0 indicates that the transaction has been posted -
//         in this case posted to the Sales Daybook within Enterprise.
const
  FNum = InvF;
var
  Status : integer;
begin
  // Apparently, it's not necessary to set the Run No on the details lines as well
  Inv.RunNo := fRunNo;

  //PR: 02/03/2012 ABSEXCH-11999. Change to use OurRef key.
  Status := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, InvOurRefK);
  if Status <> 0 then
    ShowMessage(Format('TPostTransactions.PostOriginalOrder, Status = %d',[Status]));
end;

//-----------------------------------------------------------------------

function TPostTransactions.TransNoOK(TransNo : string) : boolean;
// Post : Returns true if a transaction number is in the correct Enterprise format
//        e.g. SOR000123
var
  TransType,
  TransDigits : string;
begin
  Result := length(TransNo) = 9;
  TransType := copy(TransNo, 1, 3);
  Result := Result and (TransType = 'POR') or (TransType = 'SOR') or (TransType = 'PIN') or
    (TransType = 'SIN') or (TransType = 'SCR');;
  TransDigits := copy(TransNo, 4, 6);
  try
    StrtoInt(TransDigits)
  except
    on EConvertError do
      Result := false;
  end;
end;


function TPostTransactions.Send_Email_Acknowldegemnt(Const CompCode  :  Str20;
                                                     Const ImpInv    :  TBatchTHRec)  :  Boolean;

Var
  FormInfo      : ^TDefaultFormRecType;
  EmailInfo     : TEmailPrintInfoType;
  ToRecip       : PChar;         // Written To By DLL - must be allocated Pchar
  CCRecip       : PChar;         // Written To By DLL - must be allocated Pchar
  BCCRecip      : PChar;         // Written To By DLL - must be allocated Pchar
  MsgText       : PChar;         // Written To By DLL - must be allocated Pchar
  Attachments   : PChar;         // Written To By DLL - must be allocated Pchar
  DataPath      : PChar;
  UserCode      : ANSIString;    // Only Read By DLL - Can be typecast AnsiString
  AcCode        : ANSIString;    // Only Read By DLL - Can be typecast AnsiString
  Res           : SmallInt;
  RefNo         : ANSIString;    // Only Read By DLL - Can be typecast AnsiString
  FormName      : ANSIString;    // Only Read By DLL - Can be typecast AnsiString
  EmailSubject  : ANSIString;
begin
  Res:=0;  EmailSubject:='';

  With TEBusBtrieveEmail.Create(True) do
  try
    Companycode:=CompCode;

    OpenFile;

    With EmailSettings do
      If (FindRecord=0) and (EmailEnabled) and (EmailConfirmProcessing=1) then
      Begin
        ToRecip     := StrAlloc (255);
        CCRecip     := StrAlloc (255);
        BCCRecip    := StrAlloc (255);
        MsgText     := StrAlloc (10000);
        Attachments := StrAlloc (255);
        DataPath := StrAlloc(255);
        StrPCopy (DataPath, IncludeTrailingBackSlash(CurCompSettings.CompanyPath));

        If (Not CurCompSettings.PaperlessLoaded) then
        Begin
          Res:= EX_INITPRINTFORM(DataPath);

          If (Res<> 0) Then
            ShowMessage('EX_INITPRINTFORM: ' + IntToStr(Res));

          CurCompSettings.PaperlessLoaded:=True;
        end;


        With TGetSenderDetails.Create  do
        try
          ReadEmailSettings(IncludeTrailingBackSlash(CurCompSettings.CompanyPath)+
                            IncludeTrailingBackSlash(EBUS_DIR)+
                            IncludeTrailingBackSlash(EBUS_XML_DIR)+
                            IncludeTrailingBackslash(EBUS_XML_ARCHIVED_DIR)+
                            Inv.DocUser1); //Set to inv here as we want the orignal references.

          FillChar(EmailInfo,Sizeof(EmailInfo),#0);

          UserCode := ''; {EL: Needs to be set to currently logged on user}
          AcCode   := ImpInv.CustCode;

          If (Res=0) then
          Begin
            Res := EX_DEFAULTEMAILDETS (@EmailInfo, SizeOf(EmailInfo), ToRecip, CCRecip,
                                        BCCRecip, MsgText, PChar(UserCode), PChar(AcCode));

            if (Res <> 0) then
              ShowMessage('EX_DefaultEmailDets = ' + IntToStr(Res));
          end;


          If (OrigAddr<>'') then //Overwrite default email address with on received
          Begin
            StrPCopy (ToRecip, Originator+';'+OrigAddr+';');

          end;

          EmailSubject:=TheSubject;


          If (EmailSubject='') then
          With Inv do //Set to inv here as we want the orignal references.
          Begin
            EmailSubject:='Re : YourRef : '+YourRef+'/'+TransDesc+'. Dated : '+PoutDate(TransDate)+'. OurRef : '+DocNames[InvDocHed]+' : '+OurRef;

          end;

          If (Res = 0) Then
          Begin
            // Setup details to request form name
            New (FormInfo);
            FillChar (FormInfo^, SizeOf(FormInfo^), #0);
            With FormInfo^ Do
            Begin
              dfAccount := ImpInv.CustCode;      // Customer Code
              dfFormNo  := 11;            // Sales Order (SOR)
              dfCheckGlobal := True;      // Return Global if customer specific set is blank
            End; { With FormInfo }

            // Get correct SOR form name for customer
            Res := EX_DEFAULTFORM (FormInfo, SizeOf(FormInfo^));

            If (Res = 0) Then
            Begin
              // Add Item into Batch
              RefNo := ImpInv.OurRef;
              FormName := FormInfo^.dfFormName;
              Res := EX_ADDTRANSFORM(PChar(RefNo), PChar(FormName));

              if (Res <> 0) then
                ShowMessage('EX_ADDTRANSFORM = ' + IntToStr(Res))
              else
                With EmailInfo Do
                Begin
                  emPreview := False;

                  emSubject := EmailSubject;

                  emPriority   := 2;

                  Res := EX_PRINTTOEMAIL (@EmailInfo, SizeOf(EmailInfo), ToRecip, CCRecip,
                                          BCCRecip, MsgText, Attachments);

                  If (Res <> 0) Then
                    ShowMessage ('EX_PRINTTOEMAIL: ' + IntToStr(Res));
                End; { With }


            end;


          end;



          

        finally
          StrDispose(ToRecip);
          StrDispose(CCRecip);
          StrDispose(BCCRecip);
          StrDispose(MsgText);
          StrDispose(Attachments);

          Free;

        end; {Try..}

      end;



  finally
    CloseFile;
    Free;

  end; {try..}

  Result:=(Res=0);

end; {Proc..}

//-----------------------------------------------------------------------

function TPostTransactions.InsertTransaction : integer;
const
  FNum = IDetailF;
  PERIOD_KEY = 'AUTO_SET_PERIOD';
  ENT_CURRENCY_KEY = 'USE_EX_CURRENCY';
  OVERWRITE_TRANS_NO = 'OVERWRITE_TRANS_NO';
var
  HeaderRec : ^TBatchTHRec;
  DetailsRec : {^TBatchLinesRec}^TBatchTLRec;
  DetailsArray : Pointer;
  i, v, j, k,
  Status,
  LineNum : integer;
  KeyS : str255;
  OriginalUseExtCurr,
  OriginalSetPeriod,
  OriginalOverWriteTransNo : pchar;
  LC : integer;
  RecPos : longint;
  YrRefToAltRef : Boolean;
  SentEvent : Boolean;
  SkRec : TBatchSkRec;


  function DescriptionLineCount : Integer;
  //Returns the number of description lines on the stock record including
  //any blank lines between populated lines
  begin
    Result := 6;
    while (Result < 1) and (Trim(SkRec.Desc[Result]) = '') do
      dec(Result);
  end;

  function GetStock(const StCode : string) : Boolean;
  var
    iRes  : SmallInt;
    pCode : PChar;
  begin
    FillChar(SkRec, SizeOf(SkRec), 0);
    pCode := StrAlloc(255);
    StrPCopy(pCode, StCode);
    iRes := Ex_GetStock(@SkRec, SizeOf(SkRec),pCode,0,B_GetEq, False);
    Result := iRes = 0;
    StrDispose(pCode);
  end;


  function GetErrorMessage(ErrorNum : integer) : string;
  var
    Msg : string;
  begin
    // 21 = Ex_StoreTrans
    Result := Ex_ErrorDescription(21, ErrorNum);
    Msg := '';
    with HeaderRec^ do
      case ErrorNum of
        30200 : Msg := 'Your Ref = ' + YourRef;
        30201 : Msg := 'Trans type = ' + TransDocHed;
        30202 : Msg := 'Account code = ' + CustCode;
        30203 : Msg := 'Trans date = ' + TransDate;
        30204 : Msg := 'Trans period = ' + IntToStr(AcPr);
        30205 : Msg := 'Year = ' + IntToStr(AcYr);
        30207 : Msg := 'Currency = ' + IntToStr(Currency);
      end;
    if Msg <> '' then
      Result := Result + ' ' + Msg;
  end; // GetErrorMessage

  procedure SetToolkitINI;
  begin
    OriginalUseExtCurr := StrAlloc(4);
    if Ex_ReadINIValue(ENT_CURRENCY_KEY, OriginalUseExtCurr) = 0 then
      Ex_OverrideINI(ENT_CURRENCY_KEY, 'OFF');
    OriginalSetPeriod := StrAlloc(4);
    if Ex_ReadINIValue(PERIOD_KEY, OriginalSetPeriod) = 0 then
      Ex_OverrideINI(PERIOD_KEY, 'OFF');
    OriginalOverwriteTransNo := StrAlloc(4);
    if Ex_ReadINIValue(OVERWRITE_TRANS_NO, OriginalOverwriteTransNo) = 0 then
      Ex_OverrideINI(OVERWRITE_TRANS_NO, 'OFF');
  end;

  (*
  procedure SetPeriod;
  var
    Status : integer;
  begin
    OriginalSetPeriod := StrAlloc(4);
    Status := Ex_ReadINIValue(PERIOD_KEY, OriginalSetPeriod);

    case fSetPeriodMethod of
      0: // Set period based on date
         Status := Ex_OverrideINI(PERIOD_KEY, 'ON');
      1: begin // Use period in Enterprise
           HeaderRec^.AcYr := -1;
           HeaderRec^.AcPr := -1;
           Status := Ex_OverrideINI(PERIOD_KEY, 'OFF');
         end;
      2: begin // Set period to fixed date
           HeaderRec^.AcYr := fManualPerYear;
           HeaderRec^.AcPr := fManualPerPeriod;
           Status := Ex_OverrideINI(PERIOD_KEY, 'OFF');
         end;
    end;
  end; // SetPeriod *)

 (*
  procedure ResetPeriod;
  var
    Status : integer;
  begin
    Status := Ex_OverrideINI(PERIOD_KEY, OriginalSetPeriod);
    StrDispose(OriginalSetPeriod);
  end; // ResetPeriod *)

  procedure ResetToolkitINI;
  begin
    Ex_OverrideINI(ENT_CURRENCY_KEY, OriginalUseExtCurr);
    StrDispose(OriginalUseExtCurr);
    Ex_OverrideINI(PERIOD_KEY, OriginalSetPeriod);
    StrDispose(OriginalSetPeriod);
    Ex_OverrideINI(OVERWRITE_TRANS_NO, OriginalOverwriteTransNo);
    StrDispose(OriginalOverwriteTransNo);
  end;

  procedure SetOurRef;
  var
    SearchHeader : ^TBatchTHRec;
    SearchTrans,
    NextNo       : array[0..255] of char;
    CreateOurRef : boolean;
    Status : integer;
  begin
    CreateOurRef := true;

    // If user wants to maintain transaction numbers, and the transaction was replicated
    // and the your ref holds a transaction number in the correct format
    if fUseExtTransNo and (Inv.PrePostFlg > 0) and TransNoOK(Inv.YourRef) then
    begin
      new(SearchHeader);
      StrPCopy(SearchTrans, Inv.YourRef);
      Status := Ex_GetTransHed(SearchHeader, SizeOf(SearchHeader^), SearchTrans, 0, B_GetEq, false);
      if Status = 4 then
      begin
        CreateOurRef := false;
        HeaderRec^.OurRef := Inv.YourRef;
      end;
      dispose(SearchHeader);
    end;

    if CreateOurRef then
    begin
      // Transaction No. already exists so allocate a new one OR
      // new transaction no. required anyway
      HeaderRec^.YourRef := Inv.YourRef;
      if copy(Inv.OurRef, 1, 3) = EBUS_SOR then
        Ex_GetNextTransNo('SOR', NextNo, true);
      if copy(Inv.OurRef, 1, 3) = EBUS_POR then
        Ex_GetNextTransNo('POR', NextNo, true);
      if (copy(Inv.OurRef, 1, 3) = EBUS_PIN) and not fUseMatching then
        Ex_GetNextTransNo('PIN', NextNo, true);
      if copy(Inv.OurRef, 1, 3) = EBUS_SIN then
        Ex_GetNextTransNo('SIN', NextNo, true);

      //PR 29/08/07 Added PCR/SCR functionality
      if copy(Inv.OurRef, 1, 3) = EBUS_SCR then
        Ex_GetNextTransNo('SCR', NextNo, true);
      if copy(Inv.OurRef, 1, 3) = EBUS_PCR then
        Ex_GetNextTransNo('PCR', NextNo, true);

      HeaderRec^.OurRef := string(NextNo);

      // Replication but couldn't keep transaction number when requested
      if fUseExtTransNo and (Inv.PrePostFlg > 0) then
        fLogFile.WriteLogLineFmt('EBusiness trans : %s Transaction no. %s already in use. ',
          [Inv.OurRef, Inv.YourRef]);
    end; // CreateOurRef = true
  end; // SetOurRef

  function PostNotes : SmallInt;
  Const
    CondYN : Array[False..True] of Char = ('Y','N');

  var
    LRes : SmallInt;
    CheckS : Str255;
    NoteRec : TBatchNotesRec;
    NLineNo : longint;

  begin
    NLineNo := 1;
    KeyS := 'ND' + FullNomKey(Inv.FolioNum);
    CheckS := KeyS;
    LRes := Find_Rec(B_GetGEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, KeyS);
    while (LRes = 0) and ((copy(CheckS,1,6) = copy(KeyS,1,6))) do
    begin
      FillChar(NoteRec, SizeOf(NoteRec), 0);

      NoteRec.NoteSort := 'DOC';
      NoteRec.NoteType := Password.NotesRec.NType;
      NoteRec.NoteCode := HeaderRec^.OurRef;
      NoteRec.NoteDate := Password.NotesRec.NoteDate;
      NoteRec.AlarmDate := Password.NotesRec.NoteAlarm;
      NoteRec.User := Password.NotesRec.NoteUser;
      NoteRec.NoteLine := Password.NotesRec.NoteLine;
      NoteRec.NoteFor := Password.NotesRec.NoteFor;
      NoteRec.RepeatDays := Password.NotesRec.RepeatNo;
      NoteRec.AlarmSet:=CondYN[Password.NotesRec.ShowDate];
//      NoteRec.LineNo := Password.NotesRec.LineNo;
      NoteRec.LineNo := NLineNo;
      inc(NLineNo, 2);

      LRes := Ex_StoreNotes(@NoteRec, SizeOf(NoteRec), 0, B_Insert);

      if LRes = 0 then
        LRes := Find_Rec(B_GetNext, F[PwrdF], PWrdF, RecPtr[PwrdF]^, 0, KeyS);
    end;
  end;

  function DescriptionLinesInMessage : Boolean;
  //if we already have the stock description lines in the record then we don't want to add
  //them again. Get the next line and check its description against line 2 of the stock description
  var
    LRes : Integer;
  begin
    //PR: 28/09/2012 ABSEXCH-13432|20/05/2013 ABSEXCH-11905 If switch set, always take lines from xml.
    if fDescLinesFromXML then
    begin
      Result := True;
      EXIT;
    end;
    LRes := Find_Rec(B_GetNext, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
    Result := (LRes = 0) and (Trim(Id.StockCode) = '') and (Trim(Id.Desc) = Trim(SkRec.Desc[2]));
    if LRes = 0 then
      LRes := Find_Rec(B_GetPrev, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
  end;


begin
  LC := 0;
  new(HeaderRec);
  new(DetailsRec);
  FillChar(HeaderRec^, Sizeof(HeaderRec^), 0);
  FillChar(DetailsRec^, Sizeof(DetailsRec^), 0);
  with HeaderRec^ do
  begin

    with TEBusBtrieveCompany.Create(true) do
    try
      CompanyCode := CurCompSettings.CompanyCode;
      OpenFile;
      if FindRecord = 0 then
        YrRefToAltRef := CompanySettings.CompYourRefToAltRef
      else
        YrRefToAltRef := False;

      fUseMatching := CompanySettings.CompUseMatching;
      SentEvent := CompanySettings.CompSentimailEvent;
      fUdf1 := CompanySettings.CompImportUDF1;

      fUseExtTransNo := CompanySettings.CompKeepTransNo > 0;
      fSetPeriodMethod := CompanySettings.CompSetPeriodMethod;
      fPostHoldFlag := CompanySettings.CompPostHoldFlag;

      //PR: 28/09/2012 ABSEXCH-13432|20/05/2013 ABSEXCH-11905
      fDescLinesFromXML := CompanySettings.CompDescLinesFromXML;

      CloseFile;
    finally
      Free;
    end;

    if YrRefToAltRef then
      LongYrRef := Inv.OpName
    else
      LongYrRef := Inv.OurRef;

    CustCode := Inv.CustCode;

    //SSD stuff
    TransNat := Inv.TransNat;
    DelTerms := Inv.DelTerms;
    TransMode := Inv.TransMode;

    TransDate := Inv.TransDate;
    SetOurRef;
    AcYr := Inv.AcYr;
    AcPr := Inv.AcPr;
    TransDocHed := DocCodes[Inv.InvDocHed];
    for i := 1 to 5 do
      DAddr[i] := Inv.DAddr[i];
    InvNetVal := Ex_RoundUp(Inv.InvNetVal,2);
    TotOrdOS := Inv.InvNetVal;
    InvVAT := Inv.InvVAT;
    for v := Low(VAT_CODES) to High(VAT_CODES) do
      InvVATAnal[v] := Inv.InvVATAnal[VATType(v)];
    Currency := Inv.Currency; // Set currency to avoid DLL error 30207
    CoRate := Inv.CXRate[true];
    VATRate := Inv.CXRate[false];
    ManVAT := Inv.ManVAT;
    TotalCost := Inv.TotalCost;
    DiscSetl := Inv.DiscSetl;
    DiscSetAm := Inv.DiscSetAm;
    DiscAmount := Inv.DiscAmount;
    DiscDays := Inv.DiscDays;
    ManVAT := Inv.ManVAT;
    DueDate := Inv.DueDate;
    DJobCode := Inv.DJobCode;
    DJobAnal := Inv.DJobAnal;
    //UDF - Add user def fields
    if fUdf1 then
    begin
      DocUser1 := Inv.DocUser4;
      DocUser4 := Inv.DocUser2;
    end
    else
    begin
      DocUser1 := Inv.DocUser2;
      DocUser4 := Inv.DocUser4;
    end;
    DocUser2 := Inv.TransDesc;
    DocUser3 := Inv.DocUser3;

    //PR: 31/01/2013 ABSEXCH-13134 Add user fields 5-10.
    DocUser5  := Inv.DocUser5;
    DocUser6  := Inv.DocUser6;
    DocUser7  := Inv.DocUser7;
    DocUser8  := Inv.DocUser8;
    DocUser9  := Inv.DocUser9;
    DocUser10 := Inv.DocUser10;

    thPPDPercentage := Inv.thPPDPercentage;
    thPPDDays := Inv.thPPDDays;

    Tagged := Inv.Tagged;
    if ((fPostHoldFlag and POST_HOLD_HOLD = POST_HOLD_HOLD) and
         (Inv.HoldFlg and HOLD_STAT_HOLD = HOLD_STAT_HOLD)) or
       ((fPostHoldFlag and POST_HOLD_WARN = POST_HOLD_WARN) and
         (Inv.HoldFlg and HOLD_STAT_WARN = HOLD_STAT_WARN)) then
      HoldFlg := HoldFlg or 1; // Hold for query

    //PR: 16/10/2013 ABSEXCH-14703 Set delivery postcode
    thDeliveryPostcode := Inv.thDeliveryPostcode;

    //PR: 29/10/2013 ABSEXCH-14705  Set Transaction Originator
    thOriginator := EntryRec^.Login;

    //PR: 30/08/2016 ABSEXCH-17138 Include country code
    thDeliveryCountry := Inv.thDeliveryCountry;
  end;

  // Loop through all associated detail lines and add them to the details structure

  KeyS := FullNomKey(Inv.FolioNum);
  Status := Find_Rec(B_GetGEq, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
  while (Status = 0) and (Id.FolioRef = Inv.FolioNum) do
  begin
    Inc(LC);
    if (Status = 0) and GetStock(Id.StockCode) then
      LC := LC + DescriptionLineCount - 1;

    Status := Find_Rec(B_GetNext, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
  end;

  Try
    GetMem(DetailsArray, SizeOf(TBatchTLRec) * LC);
  Except
    On E: EOutOfMemory do
    begin
      ShowMessage('Not enough memory to process transaction ' + HeaderRec^.LongYrRef);
      Raise;
    end;

  End;

  LineNum := 1;
  KeyS := FullNomKey(Inv.FolioNum);
  Status := Find_Rec(B_GetGEq, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
  while (Status = 0) and (Id.FolioRef = Inv.FolioNum) do
    with DetailsRec^{[LineNum]} do
    begin
      Application.ProcessMessages;

      LineNo := LineNum;
      DocLTLink := Id.DocLTLink;
      TransRefNo := HeaderRec^.OurRef;
      Currency := Id.Currency;
      VATRate := 1;
      CoRate := 1;
      StockCode := Id.StockCode;

    //  if WantSSD and GetStock(StockCode) then
      begin
        SSDCommod  := Id.SSDCommod;
        SSDCountry := Id.SSDCountry;
        SSDSPUnit  := Id.SSDSPUnit;
        SSDUpLift  := Id.SSDUplift;
        LWeight := Id.LWeight;
      end;

      VATCode := Id.VATCode;  // DLL error 30107
      VAT := Id.VAT;
      QtyMul := Id.QtyMul; // was set to 1
      Qty := Id.Qty;

      //PR 6/12/07 Added QtyPick & QtyPickWoff (Done at KH's request for Polestar.)  These values should always be zero except on replicated SORs)
      QtyPick := Id.QtyPick;
      QtyPWoff := Id.QtyPWoff;
      // DLL error 30109 - appears to compare line NetValue to InvNetVal to 2DP
//      NetValue := Ex_RoundUp(Id.NetValue, 2);
      NetValue := Id.NetValue;
      NomCode := Id.NomCode;
      // Cost centre - avoid error 30105
      CC := Id.CCDep[true];
      // Department - avoid error 30105
      Dep := Id.CCDep[false];
      // Stock location - avoid error 30115
      MLocStk := Id.MLocStk;
      CostPrice := Id.CostPrice;
      Discount := Id.Discount;
      DiscountChr := Id.DiscountChr;
      tlMultiBuyDiscount := Id.Discount2;
      tlMultiBuyDiscountChr := Id.Discount2Chr;
      tlTransValueDiscount := Id.Discount3;
      tlTransValueDiscountChr := Id.Discount3Chr;
      tlTransValueDiscountType := Id.Discount3Type;
      Desc := Id.Desc;
      // LineDate ???
      LineDate := Id.PDate;
//      LineDate := Inv.DueDate;
      //UDF - Add User Def fields
      LineUser1 := Id.LineUser1;
      LineUser2 := Id.LineUser2;
      LineUser3 := Id.LineUser3;
      LineUser4 := Id.LineUser4;
      JobCode := Id.JobCode;
      AnalCode := Id.AnalCode;

      //PR: 28/01/2016 ABSEXCH-17116 Add new intrastat field
      tlIntrastatNoTC := Id.tlIntrastatNoTC;
      SSDUseLine := Id.SSDUseLine;

      //PR: 01/02/2012 ABSEXCH-2748 preserve KitLink into Exchequer, so lines are linked where necessary.
      KitLink := Id.KitLink;
      RecPos := Longint(DetailsArray) + (Pred(LineNum) * SizeOf(TBatchTLRec));
      Move(DetailsRec^, Pointer(RecPos)^, SizeOf(TBatchTLRec));
      inc(LineNum);

      //PR 17/12/2007
      //Check for any extra lines on the stock record, but only if we're not replicating and the lines aren't already in the message.
      if (Inv.PrePostFlg = 0) and GetStock(StockCode) and (Trim(SkRec.desc[2]) <> '' ) and not DescriptionLinesInMessage then
      begin
        j := DescriptionLineCount;
        if j > 1 then
          for k := 2 to j do
          begin
            if Trim(SkRec.desc[k]) <> '' then  //don't add blank lines
            begin
              FillChar(DetailsRec^, SizeOf(DetailsRec^), 0);
              DetailsRec.KitLink  := SkRec.StockFolio;
              DetailsRec.Desc := SkRec.Desc[k];
              DetailsRec.LineNo := LineNum;
              DetailsRec.ABSLineNo := LineNum;
              RecPos := Longint(DetailsArray) + (Pred(LineNum) * SizeOf(TBatchTLRec));
              Move(DetailsRec^, Pointer(RecPos)^, SizeOf(TBatchTLRec));
              inc(LineNum);
            end;
          end;
      end;

      Status := Find_Rec(B_GetNext, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);

    end; // while

  HeaderRec^.LineCount := LineNum - 1;  // This is important to avoid a 30109

  SetToolkitINI;
  if (HeaderRec.TransDocHed = 'PIN') and fUseMatching and (HeaderRec^.LineCount > 0) then
  begin
    UpdateInvoiceLines(Inv.OurRef, HeaderRec^.LineCount, DetailsArray);
    HeaderRec^.HoldFlg := Inv.HoldFlg;
    Status := MatchTransaction(Inv.OurRef, HeaderRec^);
  end
  else
    Status := Ex_StoreTrans(HeaderRec, DetailsArray, Sizeof(HeaderRec^), {Sizeof(DetailsRec^)}
                                SizeOf(TBatchTLRec) * LC, 2, B_Insert);

  if Status = 0 then
  begin
    PostNotes;

    RenamePreserveRec(Inv.OurRef, HeaderRec.OurRef, HeaderRec.FolioNum);
    {$IFDEF SENTEV}
    if Assigned(EventObject) and SentEvent and (not fUseMatching or (HeaderRec.TransDocHed <> 'PIN')) then
    begin
      EventObject.seWindowID := 102000; //Transaction window
      EventObject.seHandlerID := 170; //After Transaction Save
      EventObject.seKey := HeaderRec.OurRef;
      EventObject.seDataType := edtTransaction;
      EventObject.seDataPath := IncludeTrailingBackSlash(CurCompSettings.CompanyPath);
      EventObject.Save;
    end;
    {$ENDIF}
  end;
  ResetToolkitINI;
  if Status = 0 then
  begin
    PostOriginalOrder;
    if assigned(fLogFile) then
      fLogFile.WriteLogLineFmt('EBusiness trans : %s posted OK as : %s',
        [HeaderRec^.LongYrRef, HeaderRec^.OurRef]);


    If (HeaderRec^.TransDocHed=DocCodes[SOR]) then
      Send_Email_Acknowldegemnt(CurCompSettings.CompanyCode,HeaderRec^);
  end
  else
    if assigned(fLogFile) then
    begin
      fLogFile.WriteLogLineFmt('EBusiness trans : %s could not be posted',
        [HeaderRec^.LongYrRef]);
      fLogFile.WriteLogLineFmt('Error %d : %s', [Status, ErrorMsg(Status)]);
    end;

  Result := Status;
  dispose(HeaderRec);
  dispose(DetailsRec);
  FreeMem(DetailsArray, SizeOf(TBatchTLRec) * LC);
end; // TPostTransactions.InsertTransaction

//-----------------------------------------------------------------------

procedure TPostTransactions.IterateThroughOrders(JustTagged : boolean);
const
  FNum = InvF;
var
  KeyS : str255;
  PostedOK : boolean;
  Status : integer;

  //PR: 02/03/2012 ABSEXCH-11999.
  AList : TStringList;
  i : integer;
begin
  //PR: 02/03/2012 ABSEXCH-11999.
  //Under MS-SQL, the emulator doesn't seem to handle Step... correctly. Instead, it
  //seems to use index 0. As the RunNo is part of this index and is changed in
  //InsertTransaction, it was losing position after the first saved record.
  //As we're changing to use Get..., it makes sense to change the procedure to only
  //look at unposted records rather than all records: this should improve performance.

  //Because RunNo gets changed, we need to make a list of the records to update,
  //then update them once we have identified them all.

  AList := TStringList.Create;
  Try
    PostedOK := true;
    with Inv do
    begin

      //Find all records with a RunNo of 0 and add the required records to the list
      Status := Find_Rec(B_GetFirst, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);

      while (Status = 0) and (RunNo = 0) and (Not AbortRun) do
      begin
        Application.ProcessMessages;

        if ((Tagged > 0) or not JustTagged) and (RunNo = 0) then
          AList.Add(OurRef);

        Status := Find_Rec(B_GetNext, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
      end; // while  Status = 0

      //Now run through the list, find each record and process it.
      i := 0;
      while (i < AList.Count) and not AbortRun do
      begin
        KeyS := AList[i];
        Status := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, InvOurRefK, KeyS);
        if Status = 0 then
           PostedOK := (InsertTransaction = 0) and PostedOK;
        inc(i);
      end; //while i < AList.Count

    end; // with Inv
  Finally
    AList.Free;
  End;

  if not PostedOK then
    WarnUser;
end; // TPostTransactions.IterateThroughOrders

//-----------------------------------------------------------------------

destructor TPostTransactions.Destroy;
begin
  fLogFile.Free;
  if fToolkit.Status = tkOpen then
    fToolkit.CloseToolkit;
  fToolkit := nil;
  inherited Destroy;
end;

//-----------------------------------------------------------------------

constructor TPostTransactions.Create;
var
  i : integer;

  procedure StartToolkit;
  var
    a, b, c : longint;
  begin
    fToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit2;
    if Assigned(fToolkit) then
    begin
      EncodeOpCode(97, a, b, c);
      fToolkit.Configuration.SetDebugMode(a, b, c);
    end
    else
      raise Exception.Create('Unable to create COM Toolkit');
  end;

begin
  inherited Create;
  ReadCompanySettings;
  AbortRun:=BOff;

  SetRunNo;
  if fLogDir <> '' then
    CreatePostingLog;

  //fToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit2;
    StartToolkit;



  with fToolkit do
  begin
    for i := 1 to Company.cmCount do
    begin
      if Trim(CurCompSettings.CompanyCode) = Trim(Company.cmCompany[i].coCode) then
        Configuration.DataDirectory := Trim(Company.cmCompany[i].coPath);
    end;

    i := OpenToolkit;
  end;

{  With TEBusBtrieveCompany.Create(True) do
  Try
    Companycode:=CurCompSettings.CompanyCode;

    OpenFile;

    If (FindRecord=0) then
      fUseMatching := CompanySettings.CompUseMatching;
  Finally
    Free;
  End;}

end; // TPostTransactions.Create

procedure TPostTransactions.RenamePreserveRec(const OldRef : string;
                                              const NewRef : string;
                                              FolioNum : longint);
var
  Res : smallint;
  FEbusRec : TEBusRec;
  F : FileVar;
  KeyS : String[255];

  function LJVar(const s : string; Count : integer) : string;
  begin
    Result := Copy(s + StringOfChar(' ', Count), 1, Count);
  end;

begin
  Res := Open_File(F, 'ebus.dat', 0);
  if Res = 0 then
  begin
    KeyS := 'EP' + MakePreserveKey1(CurCompSettings.CompanyCode, OldRef) + MakePreserveKey2('');
    Res := Find_Rec(B_GetEq + B_SingLock, F, EbsF, FEbusRec, 0, KeyS);
    if Res = 0 then
    begin
      FEbusRec.EBusCode1 := MakePreserveKey1(CurCompSettings.CompanyCode, NewRef);
      FEbusRec.PreserveDoc.InvOrderNo := NewRef;                                                
      FEbusRec.PreserveDoc.InvPosted := True;
      FEbusRec.PreserveDoc.InvPostedDate := FormatDateTime('yyyymmdd', Date);
      FEbusRec.PreserveDoc.InvFolio := FolioNum;
      Res := Put_Rec(F, EbsF, FEbusRec, 0);

      KeyS := 'EQ' + MakePreserveKey1(CurCompSettings.CompanyCode, OldRef);
      Res := Find_Rec(B_GetGEq, F, EbsF, FEbusRec, 0, KeyS);
      while (Res = 0) and (Trim(FEbusRec.EBusCode1) = Trim(MakePreserveKey1(CurCompSettings.CompanyCode, OldRef))) do
      begin
        FEbusRec.EBusCode1 := MakePreserveKey1(CurCompSettings.CompanyCode, FullNomKey(FolioNum));
        Res := Put_Rec(F, EbsF, FEbusRec, 0);
        if Res = 0 then
          Res := Find_Rec(B_GetGEq, F, EbsF, FEbusRec, 0, KeyS);
      end;
    end;
    Close_File(F);
  end;
end;

function TPostTransactions.MatchTransaction(const OurRef : string; var HeadRec : TBatchTHRec) : integer;
var
  Res : smallint;
  FEbusRec : TEBusRec;
  F : FileVar;
  KeyS, KeyChk : String[255]; //PR: 28/04/2009

  function LJVar(const s : string; Count : integer) : string;
  begin
    Result := Copy(s + StringOfChar(' ', Count), 1, Count);
  end;

begin
  fMatching := TEbusMatching.Create;
  Try
    fMatching.Toolkit := fToolkit;
    fMatching.PostHoldFlag := fPostHoldFlag;
    Res := Open_File(F, 'ebus.dat', 0);
    if Res = 0 then
    begin
      //PR: 28/04/2009
      KeyChk := MakePreserveKey1(CurCompSettings.CompanyCode, OurRef);
      KeyS := 'EQ' + KeyChk;
      Res := Find_Rec(B_GetGEq, F, EbsF, FEbusRec, 0, KeyS);
      while (Res = 0) and (Trim(FEbusRec.EBusCode1) = Trim(KeyChk)) do
      begin
        //PR: 13/05/2010 Changed to allow lines with quantities but no values through
        if (FEbusRec.PreserveLine.IDQty <> 0.0) {and (FEbusRec.PreserveLine.IDValue <> 0.0)} then //don't add description lines
          fMatching.Add(@FEbusRec.PreserveLine);
        Res := Find_Rec(B_GetNext, F, EbsF, FEbusRec, 0, KeyS);
      end;
      Close_File(F);
    end;
    Result := fMatching.Convert(HeadRec, OurRef);
  Finally
    fMatching.Free;
  End;
end;

procedure TPostTransactions.UpdateInvoiceLines(const OurRef    : string;
                                                     LineCount : longint;
                                                     Lines     : Pointer);
//Update preserve lines with any changes that have been made to stock code, description, value or qty
var
  Res : smallInt;
  TLRec : TBatchTLRec;
  FEbusRec : TEbusRec;
  i, RecPos : longint;
  F : FileVar;
  KeyS : string[255];
begin
  Res := Open_File(F, 'ebus.dat', 0);
  if Res = 0 then
  begin
    for i := 1 to LineCount do
    begin
      RecPos := Longint(Lines) + (Pred(i) * SizeOf(TBatchTLRec));
      Move(Pointer(RecPos)^, TLRec, SizeOf(TBatchTLRec));

      //PR: 28/04/2009
      KeyS := 'EQ' + MakePreserveKey1(CurCompSettings.CompanyCode, OurRef) +  MakePreserveKey2(FullNomKey(TLRec.LineNo) + '!');
      Res := Find_Rec(B_GetEq, F, EbsF, FEbusRec, 0, KeyS);
      if Res = 0 then
      begin
        with FEbusRec do
        if (PreserveLine.IdValue <> TLRec.NetValue) or
           (PreserveLine.IDQty <> TLRec.Qty) or
           (PreserveLine.IdStockCode <> TLRec.StockCode) or
           (PreserveLine.IdDiscAmount <> TLRec.Discount) or
           (PreserveLine.IdDiscChar <> TLRec.DiscountChr) or
           (PreserveLine.IdDescription <> TLRec.Desc) then
        begin
          PreserveLine.IdValue := TLRec.NetValue;
          PreserveLine.IDQty   := TLRec.Qty;
          PreserveLine.IdStockCode := TLRec.StockCode;
          PreserveLine.IdDescription := TLRec.Desc;
          PreserveLine.IdDiscAmount := TLRec.Discount;
          PreserveLine.IdDiscChar := TLRec.DiscountChr;
          PreserveLine.IdDisc2Amount := TLRec.tlMultiBuyDiscount;
          PreserveLine.IdDisc2Char := TLRec.tlMultiBuyDiscountChr;
          PreserveLine.IdDisc3Amount := TLRec.tlTransValueDiscount;
          PreserveLine.IdDisc3Char := TLRec.tlTransValueDiscountChr;
          PreserveLine.IdDisc3Type := TLRec.tlTransValueDiscountType;
          Res := Put_Rec(F, EbsF, FEbusRec, 0);
        end;
      end; //res = 0
    end; //for i
    Close_File(F);
  end;
end;

procedure DeletePreserveLine(const OurRef : string;
                                   LineNo :longint);
var
  KeyS : Str255;
  Res  : SmallInt;
  F    : FileVar;
  FEbusRec : TEbusRec;
begin
  Res := Open_File(F, 'ebus.dat', 0);
  if Res = 0 then
  begin
    //PR: 28/04/2009
    KeyS := 'EQ' + MakePreserveKey1(CurCompSettings.CompanyCode, OurRef) +  MakePreserveKey2(FullNomKey(LineNo) + '!');
    Res := Find_Rec(B_GetEq, F, EbsF, FEbusRec, 0, KeyS);
    if Res = 0 then
      Delete_Rec(F, EbsF, 0);
  end;
end;


function TPostTransactions.ErrorMsg(ErrNo : integer) : string;
begin
  if ErrNo > 0 then
    Result := Ex_ErrorDescription(21, ErrNo)
  else
  begin
    Case Abs(ErrNo) of
      1 : Result := 'Unable to find required transaction when receiving an order';
      2 : Result := 'Unable to receive the order - record may be locked by another user';
      3 : Result := 'Unable to find the correct line when receiving an order';
      4 : Result := 'One or more lines have not been identified.';
      5 : Result := 'One or more orders have not been received';
      6 : Result := 'No matching information was found for this transaction';
      7 : Result := 'This order has already been invoiced';
    end;
  end;

end;

{==============================================================================}

constructor TEbusMatching.Create;
begin
  inherited Create;
  fUDList  := TStringList.Create;
  fUDList.Sorted := True;
  fUDList.Duplicates := dupAccept;
  fPORList := TStringList.Create;
  fPORList.Sorted := True;
  fPORList.Duplicates := dupAccept;
  fPDNList := TStringList.Create;
  fPDNList.Sorted := True;
  fPDNList.Duplicates := dupAccept;
  fDescList := TStringList.Create;
  fPINList := TStringList.Create;
  fPINList.Sorted := True;
  fPINList.Duplicates := dupAccept;
end;

procedure TEbusMatching.FreeList(List : TStringList);
var
  i : integer;
begin
  for i := 0 to List.Count - 1 do
    if Assigned(List.Objects[i]) then
      with List.Objects[i] as TPreserveLineObject do
        Free;
end;

destructor TEbusMatching.Destroy;
begin
  FreeList(fUDList);
  fUDList.Free;
  FreeList(fPORList);
  fPORList.Free;
  FreeList(fPDNList);
  fPDNList.Free;
  FreeList(fPINList);
  fPINList.Free;
  fDescList.Free;
  inherited Destroy;
end;

procedure TEbusMatching.AddToList(WhichList : TStringList);
var
  Key : string;
begin
  if WhichList = fUDList then
    Key := IntToStr(fUDList.Count)
  else
    Key := fToolkit.Transaction.thOurRef;

  WhichList.AddObject(Key, fCurrentRec);
end;

function TEbusMatching.FindOriginalOrder : Boolean;
begin
  with fToolkit do
  begin
    Result := Transaction.GetEqual(Transaction.BuildOurRefIndex(fCurrentRec.Fields.IdBuyersOrder)) = 0;
//    Result := Result and (Transaction.thRunNo <> -52);
  end;
end;

function TEbusMatching.FindPDNLine : Boolean;
var
 Res, Res2, i : longint;
 Found : Boolean;
 PORFolio : longint;
begin
  Found := False;
  with fToolkit do
  if Transaction.thNetValue > Transaction.thTotalOrderOS then
  begin  //There have been deliveries on the order so find PDN for this line
    with Transaction do
    begin
      PORFolio := thFolioNum;
      Res := thMatching.GetFirst;

      while (Res = 0) and not Found do
      begin
        if thMatching.maType = maTypeSPOP then
        begin
          thMatching.SavePosition;
          SavePosition; //Transaction

          Res2 := GetEqual(BuildOurRefIndex(thMatching.maDocRef));
          if (Res2 = 0) and {(Transaction.thRunNo <> -52) } (Transaction.thDocType = dtPDN)  then
          begin
            for i := 1 to thLines.thLineCount do
              if (thLines[i].tlSOPFolioNum = PORFolio) and
                 (thLines[i].tlSOPABSLineNo = fCurrentRec.Fields.IdOrderLineNo) then
                 begin
                   Found := True;
                   fCurrentRec.Fields.IdPDNNo := thOurRef;
                   fCurrentRec.Fields.IdPDNLineNo := i;
                   Break;
                 end;
            if not Found then
            begin
              RestorePosition;//Transaction
              thMatching.RestorePosition;
            end;
          end;
        end;
        if not Found then
         Res := thMatching.GetNext;
      end;
    end;
  end;
  Result := Found;
end;

function TEbusMatching.FindPORLine : Boolean;
var
  i : integer;
begin
  Result := False;
  if (fToolkit.Transaction.thDocType = dtPOR) and (fToolkit.Transaction.thRunNo <> -52) then
   with fToolkit.Transaction do
    for i := 1 to thLines.thLineCount do
      if thLines[i].tlABSLineNo = fCurrentRec.Fields.IdOrderLineNo then
      begin
        Result := True;
        fCurrentRec.Fields.IdLineNo := i;
        Break;
      end;
end;

procedure TEbusMatching.Add(Value : Pointer);
begin
  fCurrentRec := TPreserveLineObject.Create;
  fCurrentRec.Fields := TPreserveLineFields(Value^);
  if FindOriginalOrder then
  begin
    if FindPDNLine then
      AddToList(fPDNList)
    else
    begin
      FindOriginalOrder;
      if FindPORLine then
        AddToList(fPORList)
      else
      if IsInvoicedPIN then
        AddToList(fPINList)
      else //Shouldn't get here
        AddToList(fUDList);
    end;
  end
  else
    AddToList(fUDList);
end;

function TEbusMatching.UpdateTransValues(const OurRef : string; AList : TStringList; var HeadRec : TBatchTHRec) : integer;
var
  Res, i, j, OldPos : longint;
  LineObj : TPreserveLineObject;
  UpTrans : ITransaction11; //PR: 29/10/2013 ABSEXCH-14705 Change to ITransaction11
  LineDone : Array of Boolean;
  OldIdx : Integer;
begin
  with FToolkit do
  begin
    OldIdx := Transaction.Index;
    Transaction.SavePosition;
    OldPos := Transaction.Position;
    Transaction.Index := thIdxOurRef;
    Result := Transaction.GetEqual(Transaction.BuildOurRefIndex(OurRef));

    if Result = 0 then
      UpTrans := Transaction.Update as ITransaction11; //PR: 29/10/2013 ABSEXCH-14705 Cast to ITransaction11

    if Assigned(UpTrans) then
    with UpTrans do
    begin
      if ((PostHoldFlag and POST_HOLD_HOLD = POST_HOLD_HOLD) and
           (HeadRec.HoldFlg and HOLD_STAT_HOLD = HOLD_STAT_HOLD)) or
         ((PostHoldFlag and POST_HOLD_WARN = POST_HOLD_WARN) and
           (HeadRec.HoldFlg and HOLD_STAT_WARN = HOLD_STAT_WARN)) then
              thHoldFlag := thHoldFlag or 1; // Hold for query

      HeadRec.FolioNum := UpTrans.thFolioNum;
      SetLength(LineDone, Transaction.thLines.thLineCount + 1);
      Try
        for i := 0 to Transaction.thLines.thLineCount - 1 do
          LineDone[i] := False;

        for i := 0 to AList.Count - 1 do
        begin
          LineObj := TPreserveLineObject(AList.Objects[i]);

          for j := 1 to thLines.thLineCount do
            if (Trim(thLines[j].tlStockCode) = Trim(LineObj.Fields.IdStockCode)) and
               (Abs(thLines[j].tlQty - LineObj.Fields.IDQty) < 0.00001) and
                not LineDone[j] then
            begin
              LineDone[j] := True;
              thLines[j].tlNetValue := LineObj.Fields.IdValue;
              thLines[j].tlDiscount := LineObj.Fields.IdDiscAmount;
              thLines[j].tlDiscFlag := LineObj.Fields.IdDiscChar;
              ITransactionLine5(thLines[j]).tlMultiBuyDiscount := LineObj.Fields.IdDisc2Amount;
              ITransactionLine5(thLines[j]).tlMultiBuyDiscountFlag := LineObj.Fields.IdDisc2Char;
              ITransactionLine5(thLines[j]).tlTransValueDiscount := LineObj.Fields.IdDisc3Amount;
              ITransactionLine5(thLines[j]).tlTransValueDiscountFlag := LineObj.Fields.IdDisc3Char;
              ITransactionLine5(thLines[j]).tlTransValueDiscountType := LineObj.Fields.IdDisc3Type;
              thLines[j].CalcVATAmount;
              Break;
            end; //for j

        end; //for i

        thSettleDiscAmount := HeadRec.DiscSetAm;
        thSettleDiscPerc := HeadRec.DiscSetl;
        thSettleDiscDays := HeadRec.DiscDays;
        thSettleDiscTaken := HeadRec.DiscTaken;

        //PR: 29/10/2013 ABSEXCH-14705  Set Transaction Originator
        thOriginator := EntryRec^.Login;

        Result := Save(True);
      Finally
        LineDone := nil; //frees array memory
      End;
    end; //with UpTrans
    Transaction.Position := OldPos;
    Transaction.Index := OldIdx;
    Transaction.RestorePosition;
  end;
end;

function TEbusMatching.ConvertList(AList : TStringList; var HeadRec : TBatchTHRec) : integer;
var
  i : integer;
begin
  with fToolkit.SystemProcesses.ConvertToPIN do
  begin
    for i := 0 to AList.Count - 1 do
    begin
      if (clCount = 0) or (clConversions[clCount].cvStartTransaction <> AList[i]) then
        Add(AList[i]);
    end;
    clConsolidate := True;
    Result := Execute;
    if Result = 0 then
    begin
      HeadRec.OurRef := clConversions[1].cvEndTransaction;
      HeadRec.FolioNum := clConversions[1].cvEndTransactionI.thFolioNum;
      Result := UpdateTransValues(HeadRec.OurRef, AList, HeadRec);
    end;
{    for i := 0 to AList.Count - 1 do
      AList.Objects[i].Free;
    AList.Free;}
  end;
end;

function TEbusMatching.Convert(var HeadRec : TBatchTHRec; const DocRef : string) : integer;
var
  OKToPost : Boolean;
begin
  if (fUDList.Count = 0) and (fPDNList.Count = 0) and (fPORList.Count = 0) and (fPINList.Count = 0)  then
    Result := -6
  else
  begin
    OKToPost := True;
    fSupplier := Trim(HeadRec.CustCode);
    if fPINList.Count > 0 then
    begin
      with TfrmPINList.Create(nil) do
      Try
        PINs := fPINList;
        ShowModal;
        Case Action of
          paNone         : begin end; //do what?
          paAccept       : Result := UpdateExistingPINs(HeadRec); //update invoice in enterprise & clear list

          paUnidentified : PINsToUDs; //move entries from PINList to UDList
        end; //case
      Finally
        OKToPost := fPINList.Count = 0;
        if not OKToPost then
          Result := -7;
        Free;
      End;
    end;
    if fUDList.Count > 0 then
    begin
      //get user to identify any lines on Unidentified List & move into appropriate POR or PDN list.
      with TfrmEbusMatchList.Create(nil) do
      Try
        DefSupp := HeadRec.CustCode;
        Caption := 'Unmatched lines for ' + DocRef;
        DoMatch := MatchLine;
        GetUDList := LoadUDList;
        GetLineList := LoadLineList;
        Start;
      Finally
        Free;
      End;
      OKToPost := fUDList.Count = 0;
      if not OKToPost then
        Result := -4;
    end;
    if OKToPost and (fPORList.Count > 0) then
    begin
      //Give user the option of delivering the orders. Remove from list as delivered and add to PDN list
      if MessageDlg('Some of the order lines on this invoice have not been received.'#13'Do you want to receive them now?',
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
                      ProcessOrders;
      OKToPost := fPORList.Count = 0;
      if not OKToPost then
        Result := -5;
    end;
    if OKToPost then
    begin
      if (fPDNList.Count > 0) then
        Result := ConvertList(fPDNList, HeadRec);
    end;
  end;
end;

function TEbusMatching.ReceiveOrders(var WhichPOR : integer) : integer;
{Result:
  0 : all lines received ok
 -1 : couldn't find a transaction
 -2 : couldn't get an update object
 -3 : couldn't find the line
 other : error saving transaction}
var
  i, j, Res : longint;
  oTrans : ITransaction;
  ErrorCode : Byte;
  Found : Boolean;
begin
  Result := 0;
  i := 0;
  fToolkit.Transaction.Index := thIdxOurRef;
  while (i < fPORList.Count) and (Result = 0) do
  begin
    with fToolkit do
    begin
      WhichPor := i;
      Res := Transaction.GetEqual(Transaction.BuildOurRefIndex(fPORList[i]));
      if Res = 0 then
      begin
        oTrans := Transaction.Update;
        if Assigned(oTrans) then
        begin
          Found := False;
          j := 1;
          while (j <= oTrans.thLines.thLineCount) and not Found do
          begin
            with fPORList.Objects[i] as TPreserveLineObject do
              if oTrans.thLines[j].tlABSLineNo = Fields.IdOrderLineNo then
              begin
                Found := True;
                oTrans.thLines[j].tlQtyPicked := Fields.IDQty;
                Result := oTrans.Save(False);
              end
              else
                inc(j);
          end;
          if not Found then
            Result := -3;
          oTrans := nil;
        end
        else
          Result := -2;
      end
      else
        Result := -1;
    end;
    inc(i);
  end;
end;

function TEbusMatching.ConvertOrders(var ListNo : integer) : integer;
var
  i, j : longint;
begin
  with fToolkit.SystemProcesses.ConvertToPDN do
  begin
    for i := 0 to fPORList.Count - 1 do
    begin
      if (clCount = 0) or (clConversions[clCount].cvStartTransaction <> fPORList[i]) then
        Add(fPORList[i]);
    end;
    clConsolidate := False;
    Result := Check(ListNo);
    if Result = 0 then
    begin
      ListNo := 0;
      Result := Execute;
      if Result = 0 then
      begin
        fPORList.Sorted := False;
        for i := 1 to clCount do
          for j := 0 to fPORList.Count - 1 do
            if fPORList[j] = clConversions[i].cvStartTransaction then
                 fPORList[j] := clConversions[i].cvEndTransaction;
        fPORList.Sorted := True;
        while fPORList.Count > 0 do
        begin
          fPDNList.AddObject(fPORList[0], fPORList.Objects[0]);
          //TPreserveLineObject(fPORList.Objects[0]).Free;
          fPORList.Delete(0);
        end;
      end;
    end;
  end;
end;

function TEbusMatching.ProcessOrders : integer;
var
  ListNo : integer;
begin
  Result := ReceiveOrders(ListNo);
  if Result = 0 then
  begin
    ListNo := 0;
    Result := ConvertOrders(ListNo);
  end;
end;

procedure TEbusMatching.LoadLineList(ItemNo : integer; AList : TStrings; Opts : TMatchOptions);
var
  Res, i : integer;
  KeyS, s : string;
  LineObject : TLineDetails;


  procedure AddLines(const Key : String; DocType : TDocTypes);
  var
    supp : string;
    Res2 : longint;
  begin
    if Opts.UseAC then
      supp := Opts.StartAC;
    with fUdList.Objects[ItemNo] as TPreserveLineObject, fToolkit do
    begin
      Transaction.Index := thIdxFolio;
      TransactionDetails.Index := tdIdxLineClassCust;
      KeyS := Trim(TransactionDetails.BuildLineClassAcIndex(Key, supp, '', ''));
      Res := TransactionDetails.GetGreaterThanOrEqual(KeyS);
      while (Res = 0) and (TransactionDetails.tlLineClass = Key) and
            (((TransactionDetails.tlAcCode >= Opts.StartAC) and (TransactionDetails.tlAcCode <= Opts.EndAC)) or
              not Opts.UseAC) do
      begin
        if (TransactionDetails.tlDocType = DocType) and

           (((TransactionDetails.tlStockCode >= Opts.StartStock) and
             (TransactionDetails.tlStockCode <= Opts.EndStock)) or
               not Opts.UseStock) and

           (((TransactionDetails.tlLineDate >= Opts.StartDate) and
             (TransactionDetails.tlLineDate <= Opts.EndDate)) or
               not Opts.UseDate) and

           not AlreadyUsed(TransactionDetails.tlOurRef, TransactionDetails.tlABSLineNo)  then

        begin
          //Need to find parent transaction to check RunNo for posted status
          if TransactionDetails.tlFolioNum <> Transaction.thFolioNum then
            Res2 := Transaction.GetEqual(Transaction.BuildFolioIndex(TransactionDetails.tlFolioNum))
          else
            Res2 := 0;

          if (Res2 = 0) and (Transaction.thRunNo <> -52) then
          begin
            LineObject := TLineDetails.Create;
            with TransactionDetails do
            begin
              LineObject.ldAbsLineNo := tlAbsLineNo;
              LineObject.ldSupplier := tlAcCode;
              LineObject.ldOurRef := tlOurRef;
              LineObject.ldStockCode := tlStockCode;
              LineObject.ldDesc := tlDescr;
              LineObject.ldDate := tlLineDate;
              LineObject.ldValue := tlNetValue;
              LineObject.ldQty := tlQty - (tlQtyDel + tlQtyWOff);
             s := '';
            end;
            AList.AddObject(s, LineObject);
          end;
        end;

        Res := TransactionDetails.GetNext;
      end;
    end;
  end;

begin
  if ItemNo < fUdList.Count then
  begin
    for i := 0 to AList.Count - 1 do
      with AList.Objects[i] as TLineDetails do
        Free;
    AList.Clear;
    AddLines('N', dtPDN); //Delivery notes
    AddLines('R', dtPOR); //Orders
  end;
end;

procedure TEbusMatching.MatchLine(InvLine, OrderAbsLineNo : integer; const OrderRef : string);
//Set record specified by InvLine to have OrderRef & OrderAbsLineNo. Move to POR or PDN list
var
  IsOrder : Boolean;
begin
  IsOrder := Copy(OrderRef, 1, 3) = 'POR';

  if InvLine < fUDList.Count then
  begin
    with fUDList.Objects[InvLine] as TPreserveLineObject do
    begin
      if IsOrder then
      begin
        Fields.IdAbsLineNo := OrderAbsLineNo;
        Fields.IdBuyersOrder := OrderRef;
        fPORList.AddObject(OrderRef, fUDList.Objects[InvLine]);
      end
      else
      begin
        Fields.IdPDNNo := OrderRef;
        Fields.IdPDNLineNo := OrderAbsLineNo;
        fPDNList.AddObject(OrderRef, fUDList.Objects[InvLine]);
      end;
    end;
    fUDList.Delete(InvLine);
  end;
end;

procedure TEbusMatching.LoadUDList(AList : TStrings);
begin
  AList.Clear;
  AList.AddStrings(fUDList);
end;

function TEbusMatching.IsInvoicedPIN : Boolean;
begin
  Result := fToolkit.Transaction.thDocType = dtPIN;
end;

function TEbusMatching.Get_HasInvoices : Boolean;
begin
  Result := fPINList.Count > 0;
end;

function TEbusMatching.UpdateExistingPins(var HeadRec : TBatchTHRec) : integer;
var
  AList : TStringList;
  i : integer;
  ThisPIN : string;
begin
  Result := 0;
  AList := TStringList.Create;
  Try
    while fPINList.Count > 0 do
    begin
      ThisPIN := Trim(fPINList[0]);
      while (fPINList.Count > 0) and (Trim(fPINList[0]) = ThisPIN) do
      begin
        AList.AddObject(fPINList[0], fPINList.Objects[0]);
        fPINList.Delete(0);
      end;
      UpdateTransValues(AList[0], AList, HeadRec);
      AList.Clear;
    end;

  Finally
    AList.Free;
  End;
end;

procedure TEbusMatching.PINsToUDs;
begin
  fUDList.AddStrings(fPINList);
  fPINList.Clear;
end;

function TEbusMatching.AlreadyUsed(const OurRef : string; LineNo : longint) : Boolean;
var
  i : integer;
begin
  Result := False;

  for i := 0 to fPORList.Count - 1 do
  begin
    with fPORList.Objects[i] as TPreserveLineObject do
      if (Fields.IdAbsLineNo = LineNo) and (Trim(Fields.IdBuyersOrder) = Trim(OurRef)) then
      begin
        Result := True;
        Break;
      end;
  end;

  if not Result then
    for i := 0 to fPDNList.Count - 1 do
    begin
      with fPDNList.Objects[i] as TPreserveLineObject do
        if (Fields.IdAbsLineNo = LineNo) and (Trim(Fields.IdBuyersOrder) = Trim(OurRef)) then
        begin
          Result := True;
          Break;
        end;
    end;


end;



end.

