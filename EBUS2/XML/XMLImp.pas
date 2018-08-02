unit XMLImp;

{ prutherford440 09:52 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  XMLEmail, EBusVar, XMLParse, VarConst, EntUtil, XMLConst, Classes;

type
  TXMLImport = class
  private
    fXMLParser : TXmlParse;
    ExLocal : ^TExLocalEBus;
    fFolioNum : integer;
    fNewTransNo : string;
    fDocType : DocTypes; // Document type of the incoming XML doc i.e. before processing
    fSetPeriodMethod,
    fFixedFinPeriod,
    fFixedFinYear    : byte;
    {$IFNDEF EXTERNALIMPORT}
      fNoteList : TStringList;
      fXMLPolling : TdmoXMLPolling;
      procedure ProcessXMLFile(const XMLFileName : string);
    {$ENDIF}
    procedure StoreTransaction(ReadXMLStatus : TImportXML);
    procedure AllocateNewTransNo;
    function  GetFolioNum : longint;
    procedure WriteImportLog(LogFilePath : string);
    procedure WriteFatalXMLParseLog(const ErrorMsg, LogFilePath, XMLFileName : string);
    function FreightOrMisc(const s : string) : Boolean;
  public
    {$IFDEF EXTERNALIMPORT}
      fTKErrorNo : integer;
      fExternalImportLogFile, fExternalImportError : string;
      fXMLPolling : TdmoXMLPolling;
      procedure ProcessXMLFile(const XMLFileName : string);
    {$ENDIF}
    function  Initialise : boolean;
    destructor Destroy; override;
    procedure Pause;
    procedure Restart;
  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  EBusBtrv, BtrvU2, Dialogs, EBusUtil, UseDLLU, GlobVar, SysUtils, XMLUtil,
  BTSupU1, IOUtil, AdmnUtil, Controls, Debugger, BtKeys1U, StrUtil, EtStrU, MultiBuyFuncs, MultiBuyVar, TTD, MathUtil,
  PromptPaymentDiscountFuncs, TransactionHelperU, EtMiscU
  {$IFDEF EXTERNALIMPORT}
    , FileUtil
  {$ENDIF}
  ;

const
  CLIENT_ID = 60;

//-----------------------------------------------------------------------

destructor TXMLImport.Destroy;
begin
  {$IFNDEF EXTERNALIMPORT}
    fNoteList.Free;
    dispose(ExLocal, destroy);
  {$ENDIF}
  //PR: 01/02/2017 Turn off timer before freeing 
  fXMLPolling.SetPolling(tmrOff);
  fXMLPolling.Free;
  inherited Destroy;
end;

//-----------------------------------------------------------------------

function TXMLImport.GetFolioNum : longint;
// Post  : Returns a folio number to use to link the header and detail records together
//         in the EBusiness files
// Notes : Remember - will populate the global Inv record !
const
  FNum = InvF;
var
  KeyS : str255;
begin
  KeyS := '';
  Status := ExLocal^.LFind_Rec(B_GetLast, FNum, 3, KeyS);
  if Status = 0 then
    Result := ExLocal^.LInv.FolioNum + 1
  else
    Result := 1;
end;

//-----------------------------------------------------------------------

function TXMLImport.Initialise : boolean;
var
  Params : TEBusBtrieveParams;
const
  SECS_PER_MIN = 60;
(*
  procedure SetXMLPollingProperties;
  begin
    with fXMLPolling do
    begin
      PollFreq := EmailInfo.EmailSettings.EmailPollFreq;
      PromptUser := false;

      case EmailInfo.EmailSettings.EmailType of
        0 : EmailType := emlNone;
        1 : EmailType := emlMAPI;
        2 : EmailType := emlSMTP;
      end;

      Pop3Server := EmailInfo.EmailSettings.EmailServerName;
    end; // with
  end; // SetXMLPollingProperties *)

begin
  {$IFNDEF EXTERNALIMPORT}
    fNoteList := TStringList.Create;
    DefineEBusiness;
    new(ExLocal, Create(CLIENT_ID));

    fXMLPolling := TdmoXMLPolling.Create(nil);
    with fXMLPolling do
    begin
      if InitialiseXMLPolling then
      begin
        OnXMLMessageFound := ProcessXMLFile;
        // Set DisplayUpdate here

        // Read in XML parameters
        Params := TEBusBtrieveParams.Create;
        try
          Params.OpenFile;
          if Params.FindRecord = 0 then
          begin
            Result := true;
            PollFreq := Params.ParamsSettings.EntPollFreq;
            PromptUser := false;
            fXMLPolling.SetPolling(tmrOn);
          end
          else
          begin
            Result := false;
            MessageDlg('XML search frequency has not been set.', mtWarning, [mbOK], 0);
          end;
          Params.CloseFile;
        finally
          Params.Free;
        end;
      end;
    end;
  {$ENDIF}

  {$IFDEF EXTERNALIMPORT}
    fXMLPolling := TdmoXMLPolling.Create(nil);
    fTKErrorNo := 0;
    fExternalImportError := '';
    Result := TRUE;
  {$ENDIF}
end;


//-----------------------------------------------------------------------

procedure TXMLImport.WriteImportLog(LogFilePath : string);
var
  i : integer;
begin // TXMLImport.WriteImportLog
  {$IFDEF EXTERNALIMPORT}
    // Different Logging
    with fXMLParser do
    begin
      for i := 0 to ErrorLog.Count - 1 do
      begin
        AddLineToFileEx(DateToStr(Date) + ' ' + TimeToStr(Time) + '  '
        + 'XML Parse - ' + ErrorLog.GetErrorLogLine(i), fExternalImportLogFile, FALSE);
//        fExternalImportError := 'XML Parse Error';
      end;{for}
    end;{with}
  {$ELSE}
    {$I-}
    with TLogFile.Create(IncludeTrailingBackSlash(LogFilePath) + TransNoToLogName(fNewTransNo)) do
      try
        try
          WriteLogLine('Exchequer eBusiness Module XML Import Log File');
          WriteLogLine(GetCopyRightMessage);
          WriteLogLine(DateTimeToStr(Now));
          WriteLogLine('');
          WriteLogLineFmt('Importing into company : %s', [fXMLPolling.CompanyCode]);
          WriteLogLineFmt('Transaction : %s', [ExLocal^.LInv.OurRef]);
          WriteLogLine('');
          with fXMLParser do
          begin
            for i := 0 to ErrorLog.Count - 1 do
              WriteLogLine(ErrorLog.GetErrorLogLine(i));
          end;
        except
          on EInOutError do  HandleIOError(IOResult); // IO Error
        end;
      finally
        Free;
      end;

    {$I+}
  {$ENDIF}
end; // TXMLImport.WriteImportLog

//-----------------------------------------------------------------------

procedure TXMLImport.WriteFatalXMLParseLog(const ErrorMsg, LogFilePath, XMLFileName : string);
begin
  {$IFDEF EXTERNALIMPORT}
    // Different Logging
    with fXMLParser do
    begin
      AddLineToFileEx(DateToStr(Date) + ' ' + TimeToStr(Time) + '  '
      + 'Fatal XML parsing error : ' + ErrorMsg, fExternalImportLogFile, FALSE);
      fExternalImportError := 'Fatal XML Parse Error - Transaction not imported';
    end;{with}
  {$ELSE}
    with TLogFile.Create(IncludeTrailingBackSlash(LogFilePath) +
      ChangeFileExt(ExtractFileName(XMLFileName), '.LOG')) do
      try
        try
          WriteLogLine('Exchequer eBusiness Module XML Import Log File');
          WriteLogLine(GetCopyRightMessage);
          WriteLogLine(DateTimeToStr(Now));
          WriteLogLine('');
          WriteLogLineFmt('Importing into company : %s', [fXMLPolling.CompanyCode]);
          WriteLogLineFmt('Fatal XML parsing error : %s', [ErrorMsg]);
          WriteLogLine('');
        except
          on EInOutError do HandleIOError(IOResult); // IO Error
        end;
      finally
        Free;
      end;
  {$ENDIF}
end;

//-----------------------------------------------------------------------

procedure TXMLImport.StoreTransaction(ReadXMLStatus : TImportXML);
// Notes : fXMLParser.Header contains toolkit transaction header structure
//         fXMLParser.Lines contains toolkit transaction line structure
var

  SysRec   : TBatchSysRec;
  CustRec  : TBatchCURec;
  StockRec : TBatchSkRec;
  WantSSD  : Boolean;
  IsIreland : Boolean;
  F : FileVar;

  {$IFDEF EXTERNALIMPORT}
    procedure StoreTXUsingToolkit;
    var
      iVATRate, iLinesSize, iPos, iStatus : integer;
      PLine, PLines : Pointer;
    begin{StoreTXUsingToolkit}
      iLinesSize := SizeOf(TBatchTLRec) * (length(fXMLParser.Lines^) -1);

      if iLinesSize = 0 then iLinesSize := SizeOf(TBatchTLRec);
      GetMem(PLines, iLinesSize);

      try
        For iPos := 1 to length(fXMLParser.Lines^)-1 do
        begin
          PLine := Pointer(LongInt(PLines) + (SizeOf(TBatchTLRec) * (iPos -1)));
          Move(fXMLParser.Lines^[iPos], PLine^, SizeOf(TBatchTLRec));
        end;{for}

        // Add up total VAT
        fXMLParser.Header.InvVat := 0;
        for iVATRate := 0 to 20 do
        begin
          fXMLParser.Header.InvVat := fXMLParser.Header.InvVat + fXMLParser.Header.InvVatAnal[iVATRate];
        end;{for}

        //PR 5/11/07 At this point YourRef is stored in OpName field. Move to YourRef field before storing
        fXMLParser.Header.YourRef := fXMLParser.Header.OpName;
        fTKErrorNo := Ex_StoreTrans(fXMLParser.Header, PLines, {SizeOf(fXMLParser.Header^),} SizeOf(TBatchTHRec)
        , SizeOf(TBatchTLRec) * (length(fXMLParser.Lines^) -1), 0, B_Insert);
        if fTKErrorNo = 0 then
        begin
          // Store Details of new transaction in the error string, so we can put it in the log
          fExternalImportError := 'New Transaction : ' + Trim(fXMLParser.Header.OurRef)
          + '  ' + Str8ToScreenDate(fXMLParser.Header.TransDate)
          + '  ' + Trim(fXMLParser.Header.CustCode);
        end else
        begin
          fExternalImportError := 'Fatal Ex_StoreTrans Error ' + IntToStr(fTKErrorNo) + ' (' + EX_GETLASTERRORDESC + ')';
        end;
      finally
        Freemem(PLines);
      end;{try}
    end;{StoreTXUsingToolkit}
  {$ELSE}
    function SetSSD : Boolean;
    var
      Res : SmallInt;
    begin
      FillChar(SysRec, SizeOf(SysRec), 0);
      Res := EX_GETSYSDATA(@SysRec, SizeOf(SysRec));

      if Res = 0 then
      begin
        WantSSD := SysRec.IntraStat;
        IsIreland := UpperCase(SysRec.CurrentCountry) = '353';
      end
      else
      begin
        WantSSD := False;
        IsIreland := False;
      end;
    end;

    function GetCust(const CustCode : String) : Boolean;
    var
      Res : SmallInt;
      Skey : PChar;
    begin
      FillChar(CustRec, SizeOf(CustRec), 0);
      Skey := StrAlloc(255);
      StrPCopy(Skey, CustCode);
      Res := EX_GETACCOUNT(@CustRec, SizeOf(CustRec), Skey, 0, B_GetEq, 0, False);
      Result := Res = 0;
      StrDispose(Skey);
    end;

    function GetStock(const StockCode : String) : Boolean;
    var
      Res : SmallInt;
      Skey : PChar;
    begin
      FillChar(StockRec, SizeOf(StockRec), 0);
      Skey := StrAlloc(255);
      StrPCopy(Skey, StockCode);
      Res := EX_GETSTOCK(@StockRec, SizeOf(StockRec), Skey, 0, B_GetEq, False);
      Result := Res = 0;
      StrDispose(Skey);
    end;


    procedure SetPeriod;
    var
      FinPeriod,
      FinYear : smallint;
      SystemInfo : TBatchSysRec;
      pDate : array[0..8] of char;
    begin
      with ExLocal^ do
        case fSetPeriodMethod of
          0: // Set period based on date
             begin
               StrPCopy(pDate, fXMLParser.Header^.TransDate);
               if Ex_DateToEntPeriod(pDate, FinPeriod, FinYear) = 0 then
               begin
                 LInv.AcPr := FinPeriod;
                 LInv.AcYr := FinYear;
               end;
             end;
          1: // Use period in Enterprise
             begin
               FillChar(SystemInfo, SizeOf(SystemInfo), 0);
               if Ex_GetSysData(@SystemInfo, SizeOf(SystemInfo)) = 0 then
               begin
                 LInv.AcPr := SystemInfo.ExPr;
                 LInv.AcYr := SystemInfo.ExYr;
               end;
             end;
          2: begin // Set period to fixed date
               LInv.AcPr := fFixedFinPeriod;
               LInv.AcYr := fFixedFinYear;
             end;
        end; // case
    end; // SetPeriod

    procedure StoreHeader;
    var
      i, v : integer;
      Status : integer;
    begin
      fNoteList.Text := fXMLParser.Notes;
      with ExLocal^ do
      begin
        FillChar(LInv, SizeOf(LInv),0);
        with fXMLParser.Header^ do
        begin
          LInv.NLineCount := fNoteList.Count;
          LInv.OurRef := fNewTransNo;
          LInv.YourRef := YourRef;
          LInv.ILineCount := LineCount;
          LInv.TransDesc := LongYrRef;
          LInv.TransDate := TransDate;
          SetPeriod;
          LInv.CustCode := CustCode;

          //SSD header stuff
          if WantSSD then
          begin
            if IsIreland then
              LInv.TransNat := 1
            else
              LInv.TransNat := 10;
            if GetCust(CustCode) then
            begin
              LInv.DelTerms := CustRec.SSDDelTerms;
              LInv.TransMode := CustRec.SSDModeTr;
            end;
          end;

          LInv.Currency := Currency;
          LInv.CXRate[true] := CoRate;
          LInv.CXRate[false] := VATRate;
          // DocUser1 contains the name of the imported XML file for this transaction
          for i := 1 to 5 do
            LInv.DAddr[i] := DAddr[i];
          LInv.InvNetVal := InvNetVal;
          LInv.InvVAT := InvVAT;
          LInv.InvDocHed := fDocType;
          LInv.FolioNum := fFolioNum;
          LInv.DiscAmount := DiscAmount;
          LInv.TotOrdOS := TotOrdOS;

          //PR: 15/06/2015 v7.0.14 PPD Changes
          if SettlementDiscountSupportedForDate(TransDate) then
          begin
            LInv.DiscDays := DiscDays;
            LInv.DiscSetl := DiscSetl;
            LInv.DiscSetAm := DiscSetAm;
          end
          else
          begin
            if GetCust(CustCode) then
            begin
              //As requested by AP, PPD is taken from account defaults
              LInv.thPPDDays := CustRec.DefSetDDays;
              LInv.thPPDPercentage := Round_Up(CustRec.DefSetDisc / 100, 4);
              UpdatePPDTotals(LInv);
            end;
          end;

          LInv.ManVAT := ManVAT;
          LInv.DueDate := DueDate;
          LInv.DocUser1 := DocUser1;
          LInv.DocUser2 := DocUser2;
          //UDF
          LInv.DocUser3 := DocUser3;
          LInv.DocUser4 := DocUser4;

          //PR: 31/01/2013 ABSEXCH-13134 Add user fields 5-10.
          LInv.DocUser5  := DocUser5;
          LInv.DocUser6  := DocUser6;
          LInv.DocUser7  := DocUser7;
          LInv.DocUser8  := DocUser8;
          LInv.DocUser9  := DocUser9;
          LInv.DocUser10 := DocUser10;

          LInv.OpName := OpName;
          LInv.Tagged := Tagged;

          LInv.DJobCode := DJobCode;
          LInv.DJobAnal := DJobAnal;
          for i := 1 to 6 do
            LInv.DocLSplit[i] := fXmlParser.LSplit[i];
          for v := Low(VAT_CODES) to High(VAT_CODES) do
            LInv.InvVATAnal[VatType(v)] := InvVATAnal[v];
          LInv.TotalCost := TotalCost;
          case ReadXMLStatus of
  //          impOK    : LInv.HoldFlg := HOLD_STAT_NONE;
            impOK    : LInv.HoldFlg := HoldFlg;
            impWarn  : LInv.HoldFlg := HoldFlg or HOLD_STAT_WARN;
            impError : LInv.HoldFlg := HoldFlg or HOLD_STAT_ERROR;
          end;
          if fXMLParser.TransferMode = tfrReplication then
            LInv.PrePostFlg := 1;

          //PR: 16/10/2013 ABSEXCH-14703 Set delivery postcode
          LInv.thDeliveryPostcode := thDeliveryPostcode;

          //PR: 30/08/2016 ABSEXCH-17138 Include country code
          LInv.thDeliveryCountry := thDeliveryCountry;


          Status := LAdd_Rec(InvF, 0);
          if Status <> 0 then
            MessageDlg(Format('Could not add transaction header, status = %d' + CRLF + '%s',
              [Status, Set_StatMes(Status)]), mtError, [mbOK], 0);

          if Status = 0 then
          begin
            EbusRec.RecPfix := EBUS_RECPFIX_ENTERPRISE;
            EbusRec.SubType := EBUS_SUBTYPE_PRESERVEINV;
  //          EbusRec.EBusCode1 := Copy(Trim(LInv.OurRef) + StringOfChar(' ', 20), 1, 20);
            EbusRec.EBusCode1 := MakePreserveKey1(fxmlParser.CompanyCode, LInv.OurRef);
            EbusRec.EBusCode2 := MakePreserveKey2('');
            EbusRec.PreserveDoc := fXmlParser.PresDocFields;
            Status := Add_Rec(F, EbsF, EbusRec, 0);
          end;
        end;
      end;
    end; // StoreHeader

    procedure StoreLines;
    var
      i : integer;
      Count : integer;

      LastKitLink,
      KitCount     :  LongInt;

      IgnoreErrors : boolean;
    begin
      Count := 0;  LastKitLink:=0;  KitCount:=0;

      //Open up stock so we can get the stock folio

      try
        IgnoreErrors := false;
        for i := 1 to fXMLParser.Header^.LineCount do
          with fXMLParser.Lines^[i], ExLocal^ do
          begin
            inc(Count);


            FillChar(LId, SizeOf(LId), 0);
            LId.StockCode := StockCode;
            LId.FolioRef := fFolioNum;
            LId.Qty := Qty;
            //PR 6/12/07 Added QtyPick & QtyPickWoff
            LId.QtyPick := QtyPick;
            LId.QtyPWoff := QtyPWoff;
            
            LId.Currency := Currency;
            LId.VATCode := VATCode;
            // This is now EBUS_SOR, EBUS_SIN etc - but doesn't hurt ?
            LId.IDDocHed := fDocType;
            LId.LineNo := Count;
            LId.NetValue := NetValue;
            LId.NomCode := NomCode;
            LId.CostPrice := CostPrice;
            LId.CCDep[true] := CC;
            LId.CCDep[false] := Dep;
            LId.MLocStk := MLocStk;
            LId.Desc := Desc;
            LId.QtyMul := QtyMul;
            LId.DiscountChr := DiscountChr;

            LId.JobCode := JobCode;
            LId.AnalCode := AnalCode;
            //PR 04/08/03 Discount amount in xml message is for line total, but in ent it's for 1 unit
            if (DiscountChr = #0) and (Qty <> 0) and (fDocType <> SOR) then
            begin
              if QtyMul = 0 then
                QtyMul := 1;
              LId.Discount := Ex_RoundUp(Discount / (QtyMul * Qty), 2);
            end
            else
              LId.Discount := Discount; //%
            LId.VAT := VAT;
            LId.PDate := LineDate; // ????
            LId.DocLTLink := DocLTLink;

            //UDF
            LId.LineUser1 := LineUser1;
            LId.LineUser2 := LineUser2;
            LId.LineUser3 := LineUser3;
            LId.LineUser4 := LineUser4;

            //PR: 07/02/2012 Connect up following description lines ABSEXCH-2748
            LId.KitLink := KitLink;

            If (StockCode<>'') and (LGetMainRec(StockF,StockCode)) then
            Begin
{              Debug.Show('Kit Link set for '+StockCode);
              LId.KitLink:=0;

              LastKitLink:=LStock.StockFolio;
              KitCount:=0;}

              if WantSSD then
              begin
                LID.SSDCommod  := LStock.CommodCode;
                LID.SSDCountry := LStock.SSDCountry;
                LID.SSDSPUnit  := LStock.SuppSUnit;
                LID.SSDUpLift  := LStock.SSDDUplift;
                if LId.IdDocHed in PurchSplit then
                  LID.LWeight := LStock.PWeight
                else
                  LID.LWeight := LStock.SWeight;
              end;


            end;
{            else
            //Add extra test to prevent freight or misc line being treated as description
            If not FreightOrMisc(Desc) and (KitCount<5) and (Qty = 0) then
            Begin
              LId.KitLink:=LastKitLink;
              Inc(KitCount);

            end;}
            //PR: 26/05/2009 Added handling for Multi-Buy Discounts
            if (LInv.InvDocHed in [POR, SOR]) and fXMLParser.ReapplyPricing then
            begin
              //Adds discount, saves line & adds description lines
              if not AddMultiBuyDiscounts(LInv, LId, LStock.StockFolio, ExLocal, fXMLParser.GetVATRate(LID.VATCode)) then
              begin
                 //If no mbds then function won't have added line, so we'll do it here.
                 if LId.Discount3Type <> 255 then //if this was an MBD description line then we don't want to add it
                   Status := LAdd_Rec(IDetailF, 0);
              end
              else
              begin
                Count := LInv.ILineCount; //Adjust for description lines
                //Status := LPut_Rec(InvF, 0);
              end;
            end
            else
            begin
              if not ZeroFloat(Qty) then
              begin
                LID.Discount2Chr := tlMultiBuyDiscountChr;
                if LID.Discount2Chr <> '%' then
                  LID.Discount2 := tlMultiBuyDiscount / (QtyMul * Qty)
                else
                  LID.Discount2 := tlMultiBuyDiscount;

                LID.Discount3Chr := tlTransValueDiscountChr;
                if LID.Discount3Chr <> '%' then
                  LID.Discount3 := tlTransValueDiscount / (QtyMul * Qty)
                else
                  LID.Discount3 := tlTransValueDiscount;

                LID.Discount3Type := tlTransValueDiscountType;
              end;
              Status := LAdd_Rec(IDetailF, 0);
            end;

            if (Status <> 0) and not IgnoreErrors then
              IgnoreErrors := MessageDlg(Format(
                              'Could not add transaction line, status = %d'
                              + CRLF + '%s' + CRLF + CRLF +
                              'Click ''Cancel'' to ignore further errors on this transaction line',
                              [Status, Set_StatMes(Status)]), mtError, [mbOK, mbCancel], 0)
                              = mrCancel;
            if Status = 0 then
            begin
              EbusRec.RecPfix := EBUS_RECPFIX_ENTERPRISE;
              EbusRec.SubType := EBUS_SUBTYPE_PRESERVEID;
  //            EbusRec.EBusCode1 := Copy(Trim(LInv.OurRef) + StringOfChar(' ', 20), 1, 20);
              EbusRec.EBusCode1 := MakePreserveKey1(fxmlParser.CompanyCode, LInv.OurRef);
              EbusRec.EBusCode2 := MakePreserveKey2(FullNomKey(fXMLParser.PresLineFields[i].IdAbsLineNo) + '!');
              fXMLParser.PresLineFields[i].IdStockCode := StockCode;
              fXMLParser.PresLineFields[i].IdDescription := Desc;
              Move(fXMLParser.PresLineFields[i], EbusRec.PreserveLine, SizeOf(TPreserveLineFields));
              Status := Add_Rec(F, EbsF, EbusRec, 0);
            end;
          end; // for

          //All lines stored, now apply VBD if applicable
          if (ExLocal^.LInv.InvDocHed in [POR, SOR]) and fXMLParser.ReapplyPricing then
          with TTTDTransactionHelper.Create do
          Try
            TransactionMode := tmAdd;
            ApplyDiscounts(nil, nil, ExLocal^.LInv);
          Finally
            Free;
          End;

      finally

      end;
    end; // StoreLines

    procedure StoreNotes;
    var
      i, Status : integer;
      IgnoreErrors : boolean;
      NType : Char;
    begin
      IgnoreErrors := False;

        if fXmlParser.GeneralNotes then
          NType := '1'
        else
          NType := '2';

        for i := 0 to fNotelist.Count - 1 do
        begin
          ExLocal^.LPassword.RecPfix := 'N';
          ExLocal^.LPassword.SubType := 'D';
          ExLocal^.LPassword.NotesRec.NoteNo := FullNCode(FullNomKey(fFolioNum)) + NType;
          ExLocal^.LPassword.NotesRec.NoteLine := fNoteList[i];
          ExLocal^.LPassword.NotesRec.NoteDate := fXMLParser.Header^.TransDate;
          ExLocal^.LPassword.NotesRec.NType := NType;
          ExLocal^.LPassword.NotesRec.NoteFolio := FullNomKey(fFolioNum);
          ExLocal^.LPassword.NotesRec.LineNo := i + 1;
          ExLocal^.LPassword.NotesRec.ShowDate := True;

          Status := ExLocal^.LAdd_Rec(PwrdF, 0);
          if (Status <> 0) and not IgnoreErrors then
            IgnoreErrors := MessageDlg(Format(
                            'Could not add transaction note line, status = %d'
                            + CRLF + '%s' + CRLF + CRLF +
                            'Click ''Cancel'' to ignore further errors on this transaction note line',
                            [Status, Set_StatMes(Status)]), mtError, [mbOK, mbCancel], 0)
                            = mrCancel;

        end;

    end; //StoreNotes
  {$ENDIF}

begin
  {$IFDEF EXTERNALIMPORT}
    StoreTXUsingToolkit;
    Finalize(fXMLParser.Lines^);
    //PR 19/12/2007 PreserveLines array wasn't being finalized
    fXMLParser.FinalizePreserveLines;
  {$ELSE}
    Open_File(F, 'Ebus.dat', 0);
    SetSSD;
    fFolioNum := GetFolioNum;
    fDocType := EntTransStrToEnum(fXMLParser.Header^.TransDocHed);
    AllocateNewTransNo;
    Debug.Show('About to call StoreHeader');
    StoreHeader;
    Debug.Show('About to call StoreLines');
    StoreLines;
    Debug.Show('About to call StoreNotes');
    StoreNotes;
    Finalize(fXMLParser.Lines^);
    //PR 19/12/2007 PreserveLines array wasn't being finalized
    fXMLParser.FinalizePreserveLines;
    Close_File(F);
  {$ENDIF}
end;

//-----------------------------------------------------------------------

procedure TXMLImport.ProcessXMLFile(const XMLFileName : string);
var
  XMLReadStatus : TImportXML;
  SelCompPath : ansistring;
  ImportLogPath : string;

  procedure ReadDefaults;
  begin
    with TEBusBtrieveCompany.Create(true) do
    try
      OpenFile;
      CompanyCode := fXMLPolling.CompanyCode;
      if FindRecord = 0 then
        with fXMLParser, CompanySettings do
        begin
          CompanyCode := fXMLPolling.CompanyCode;
          {$IFDEF EXTERNALIMPORT}
            CompanyPath := fXMLPolling.CompanyPath;
          {$ENDIF}
          DefaultCC := CompDefCostCentre;
          DefaultDept := CompDefDept;
          DefaultLocation := CompDefLocation;
          LocationOrigin := CompLocationOrigin;
          DefaultCustCode := CompDefCustomer;
          DefaultSuppCode := CompDefSupplier;
          DefaultPurchNomCode := CompDefPurchNom;
          DefaultSalesNomCode := CompDefSalesNom;
          DefaultVATCode := CompDefVATCode;

          UseStockForCharges := CompUseStockForCharges <> 0;
          FreightStockCode := CompFreightStockCode;
          MiscStockCode :=  CompMiscStockCode;
          DiscStockCode := CompDiscStockCode;
          FreightDesc := CompFreightDesc;
          MiscDesc := CompMiscDesc;
          DiscDesc := CompDiscDesc;
          FreightMap := CompFreightLine;
          MiscMap := CompMiscLine;
          DiscMap := CompDiscount;
          ReapplyPricing := CompReapplyPricing <> 0;
          ImportUDF1 := CompImportUDF1;
          GeneralNotes := CompGeneralNotes;
      (*    DefaultPeriodMethod := TPeriodMethod(CompSetPeriodMethod);
          DefaultFinPeriod := CompPeriod;
          DefaultFinYear := CompYear; *)
          ImportLogPath := fXMLPolling.ImportLogDir;

          fSetPeriodMethod := CompSetPeriodMethod;
          fFixedFinPeriod := CompPeriod;
          fFixedFinYear := CompYear;

          CCDepFromXML := CompCCDepFromXML;

      {$IFDEF EXTERNALIMPORT}
        end else
        begin
          WriteFatalXMLParseLog('EBus Setup Record Not Found', ImportLogPath, XMLFileName);
        end;{if}
      {$ELSE}
        end;
      {$ENDIF}

      CloseFile
    finally
      Free;
    end;
  end;

  procedure OpenFiles;
  Var
    WasSetDrive  :  Str255;
    Locked : Boolean;
    FilePath : Str255;
    Res : Integer;
  begin
    WasSetDrive:=SetDrive;

    // Open client ID versions of transaction header and details files
    ExLocal^.ShowErrors := true;
    ExLocal^.OpenOneFile(InvF, SelCompPath, EBUS_DOCNAME);
    ExLocal^.OpenOneFile(IDetailF, SelCompPath, EBUS_DETAILNAME);
    ExLocal^.OpenOneFile(PwrdF, SelCompPath, EBUS_NOTESNAME);

    //Open up stock so we can get the stock folio

    SetDrive:=IncludeTrailingBackSlash(SelCompPath);

    ExLocal^.Open_System(StockF,StockF);
    //PR: 26/05/2009 Need to open extra files for Advanced Discounts
    ExLocal^.Open_System(MultiBuyF,MultiBuyF);

    Open_System(SysF, SysF);
    Open_System(MiscF, MiscF);

    //For VBD we need to open ebus\doc + detl without ExLocal
    FilePath := GetEBusSubDir(SelCompPath, EBUS_DOCNAME);
    Res := Open_File(F[InvF], FilePath, 0);

    FilePath := GetEBusSubDir(SelCompPath, EBUS_DETAILNAME);
    Res := Open_File(F[IDetailF], FilePath, 0);

    Locked := False;
    GetMultiSys(False, Locked, VATR);

    SetDrive:=WasSetDrive;
  end;

  procedure CloseFiles;
  begin
    // Close client ID versions of transaction header and details files
    ExLocal^.CloseSelFiles([InvF, IDetailF, PwrdF, StockF, MultiBuyF]);
  end;

begin
  try
    fXMLParser := TXmlParse.Create;
    ReadDefaults;
    fXMLParser.Initialise(xmlEBusiness, XMLFileName);
  except
    on E:EXMLFatalError do
    begin
      WriteFatalXMLParseLog(E.Message, ImportLogPath, XMLFileName);
      {$IFNDEF EXTERNALIMPORT}
        fXMLPolling.PostParsingProcess(XMLFileName, false);
        fXMLPolling.NotifyAdmin(XMLFileName, impFatal);
      {$ENDIF}
      fXMLParser.Free;
      fXMLParser := nil;
    end;
  end;

  if Assigned(fXMLParser) then
  begin
    {$IFDEF EXTERNALIMPORT}
      SelCompPath := GetCompanyDirFromCode(fXMLPolling.CompanyCode, fXMLPolling.CompanyPath);
    {$ELSE}
      SelCompPath := GetCompanyDirFromCode(fXMLPolling.CompanyCode);
    {$ENDIF}
    Debug.Show('Selected Company path :'+SelCompPath+': for company code '+fxMLPolling.CompanyCode+': ends here');
    XMLReadStatus := impFatal;
    try
      {$IFNDEF EXTERNALIMPORT}
        OpenFiles;
      {$ENDIF}
      try
        Debug.Show('About to call fXMLParser.Parse for '+SelCompPath);
        XMLReadStatus := fXMLParser.Parse;
        Debug.Show('About to call StoreTransaction');
        StoreTransaction(XMLReadStatus);
        Debug.Show('Returned from StoreTransaction');
        {if XMLReadStatus <> impOK then}
          WriteImportLog(ImportLogPath);

        {$IFNDEF EXTERNALIMPORT}
          fXMLPolling.SendNotifySender(SelCompPath,XMLFileName,XMLReadStatus,ExLocal^.LInv) //Send notification of ok/fail receipt ENEBISNOTIFY}
        {$ENDIF}
      except
        on E:EXMLFatalError do
          WriteFatalXMLParseLog(E.Message, ImportLogPath, XMLFileName)
      end;
    finally
      {$IFNDEF EXTERNALIMPORT}
        fXMLPolling.PostParsingProcess(XMLFileName, XMLReadStatus in [impOK, impWarn]);
        fXMLPolling.NotifyAdmin(XMLFileName, XMLReadStatus, fXMLParser.TransferMode);
      {$ENDIF}

      fXMLParser.Free;

      {$IFNDEF EXTERNALIMPORT}
        CloseFiles;
      {$ENDIF}
    end;
  end;
end; // TXMLImport.ProcessXMLFile

//-----------------------------------------------------------------------

procedure TXMLImport.AllocateNewTransNo;
var
  DocType : array[0..4] of char;
  NextNo : array[0..255] of char;
  Status : integer;
begin
  case fDocType of
    SOR : StrPCopy(DocType, EBUS_SOR);
    POR : StrPCopy(DocType, EBUS_POR);
    SIN : StrPCopy(DocType, EBUS_SIN);
    PIN : StrPCopy(DocType, EBUS_PIN);
    //PR 29/08/07 Added SCR & PCR
    SCR : StrPCopy(DocType, EBUS_SCR);
    PCR : StrPCopy(DocType, EBUS_PCR);
  end;
  Status := Ex_GetNextTransNo(DocType, NextNo, true);
  if Status <> 0 then
    MessageDlg(Format(
      'Allocating next transaction number via Ex_GetNextTransNo returned %d' + CRLF + '%s',
      [Status, Ex_ErrorDescription(22, Status)]), mtError, [mbOK], 0);
  fNewTransNo := copy(string(NextNo),1,9);
end;

//-----------------------------------------------------------------------

function TXMLImport.FreightOrMisc(const s : string) : Boolean;
begin
  with fXmlParser do
  begin
    if (s = FreightDesc) or (s = MiscDesc) then
      Result := True
    else
      Result := False;
  end;
end;

procedure TXMLImport.Pause;
begin
  if Assigned(fXMLPolling) then
    fXMLPolling.SetPolling(tmrOff);
end;

procedure TXMLImport.Restart;
begin
  if Assigned(fXMLPolling) then
    fXMLPolling.SetPolling(tmrOn);
end;


end.
