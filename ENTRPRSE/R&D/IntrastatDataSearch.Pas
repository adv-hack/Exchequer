unit IntrastatDataSearch;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, DB, BTSupU3,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons, Contnrs, StrUtils,
  GlobVar,VARRec2U,VarConst,BtrvU2,BTSupU1,ExWrap1U, Scrtch2U, ReportU, SQLRep_BaseReport;

const
  //PR: 03/03/2014 ABSEXCH-15077 Array for ValidVatCode function
  ISVatCodes : Array[False..True] of Char = ('A', 'D');

type
  TCheckAbortFunc = Function : Boolean of Object;

  // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
  //
  // Record and array to keep track of the Delivery Charges on Transactions. This
  // array is built up in Scan_4Items(). In PrintReportLine() on the actual
  // Intrastat Report the delivery charge for the transaction is assigned to the
  // stock lines on a pro-rata basis (each stock line is assigned an equal
  // portion of the total Delivery Charge for the Transaction).
  TTransactionFreightDetails = record
    TransactionFolioRef: LongInt; // Folio number of Transaction
    ItemCount: Integer;           // Number of stock lines
    DeliveryCharge: Double;       // Total Delivery Charge on the Transaction
  end;
  TFreightDetails = array of TTransactionFreightDetails;

  // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
  // Moved the Scan_4Items() and IntraInvInclude() functions into a class, to
  // avoid having to make the FreightDetails array global.
  TIntrastatDataSearch = class(TObject)
  private
    fFreightDetails: TFreightDetails;

    // Locate the entry for the specified transaction folio ref
    function FindFreightDetails(ForFolio: LongInt): Integer;

    // Increase the size of the Freight Details array and initialise the new
    // records with null values
    procedure ExpandFreightDetailsArray;

    // Add a new entry to the Freight Details array with the supplied values
    procedure AddFreightDetails(FolioRef: LongInt; ItemCount: Integer;
                                DeliveryCharge: Double);

  public
    constructor Create;
    destructor Destroy; override;
    Function Scan_4Items(CMode       :  Byte;
                         Sdate,
                         Edate       :  LongDate;
                         VATChk      :  Char;
                         Summary     :  Boolean;
                         ThisScrt    :  Scratch2Ptr;
                         MTExLocal   :  TdMTExLocalPtr;
                   const ChkRepAbort :  TCheckAbortFunc;
                         RepAbort    :  Boolean)  :  LongInt;

    // PR: 03/03/2014 ABSEXCH-15077 Added extra parameter to indicate whether we're running report for Arrivals or Dispatches
    Function IntraInvInclude(InvR  :  InvRec;
                             Sdate,
                             Edate :  LongDate;
                             IsArrivals : Boolean)  :  Boolean;

    // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
    function CalculateDeliveryCharge(IdR: IDetail): Double;
  end;

implementation

uses SQLUtils, RpDefine, Comnu2, ETDateU, ETMiscU, ETStrU, BTKeys1U, CurrncyU,
     SysU1, ExThrd2U,  BTSupU2, SalTxl1U, ComnUnit,
     SQLRep_Config, EntLoggerClass;

constructor TIntrastatDataSearch.Create;
begin
  // Initialise the array of Freight Details
  SetLength(fFreightDetails, 10);
end;

destructor TIntrastatDataSearch.Destroy;
begin
  // Ensure that the array memory is freed
  Finalize(fFreightDetails);
  inherited;
end;

Function TIntrastatDataSearch.Scan_4Items(CMode  :  Byte;
                                          Sdate,
                                          Edate          :  LongDate;
                                          VATChk         :  Char;
                                          Summary        :  Boolean;
                                          ThisScrt       :  Scratch2Ptr;
                                          MTExLocal      :  TdMTExLocalPtr;
                                    const ChkRepAbort    :  TCheckAbortFunc;
                                          RepAbort       :  Boolean)  :  LongInt;

Const
  Fnum        =  CustF;
  Keypath     =  CustCntyK;

  Fnum1       =  InvF;
  Keypath1    =  InvCustK;

  Fnum2       =  IdetailF;
  Keypath2    =  IdFolioK;


Var
  KeyCS,
  KeyChk,
  KeyS2,
  KeyChk2,
  KeyCF,
  CommodKey   :  Str255;
  Lnum,
  RecAddr     :  LongInt;
  TmpInclude  :  Boolean;

  // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
  TotalDeliveryCharge: Double;
  TotalStockLines: Integer;
  LineValue: Double;

  //PR: 03/03/2014 ABSEXCH-15077
  AcType,
  bStart, bEnd : Boolean;

  //PR: 03/03/2014 ABSEXCH-15077 Function to check VAT codes for Ireland, as credit notes will have wrong Vat code for usual check.
  function ValidVatCode(VatC : Char) : Boolean;
  var
    ThisVAT : Char;
  begin
    if CurrentCountry <> IECCode then
      Result := VatC = VatChk
    else
    begin
      with MTExLocal.LInv do
        ThisVAT := ISVatCodes[CustSupp = 'C'];

      Result := VatC = ThisVAT;
    end;
  end;

Begin
  Lnum:=0; RecAddr:=0;

  //PR: 03/03/2014 ABSEXCH-15077 In order to include PCRs in arrivals and SCRs in dispatches,
  //                             we need to go through customers/suppliers. Ireland only.
  if CurrentCountry <> IECCode then
  begin
    //Suppliers or Customers depending on mode
    bStart := Cmode = 1;
    bEnd := bStart;
  end
  else
  begin
    //Ireland - Suppliers and Customers
    bStart := False;
    bEnd := True;
  end;

  for AcType := bStart to bEnd do
  With MTExLocal^ do
  Begin

    KeyCF:=TradeCode[(AcType)];

    TmpInclude:=BOff;

    CommodKey:='';

    // Go through all the Trader records
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCF);
    While (LStatusOk) and (ChkRepAbort) and (LCust.CustSupp=TradeCode[(AcType)]) do
    With LCust do
    Begin
      // Only process EEC Members
      TmpInclude := (EECMember);
      If (TmpInclude) then
      Begin
        // Go through all the Transactions for this Trader
        KeyChk  := FullCustType(CustCode, CustSupp);
        KeyCS   := KeyChk;
        LStatus := LFind_Rec(B_GetGEq, Fnum1, KeyPath1, KeyCS);
        While (LStatusOk) and (Checkkey(KeyChk, KeyCS, Length(KeyChk), BOn)) and (ChkRepAbort) do
        With LInv do
        Begin
          // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
          TotalDeliveryCharge := 0.0;
          TotalStockLines     := 0;

          // PR: 03/03/2014 ABSEXCH-15077 Tell functions whether we're running report for Arrivals (CMode = 2) or Dispatches
          If (IntraInvInclude(LInv,SDate,Edate, CMode = 2)) then
          Begin

            // Go through all the lines on the Transaction
            KeyChk2 := FullNomKey(FolioNum);
            KeyS2   := FullIdKey(FolioNum,1);

            LStatus := LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyS2);

            While (LStatusOk) and (Checkkey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) and (ChkRepAbort) do
            With LId do
            Begin
              // MH 10/09/2009: Modified to exclude service lines (FRv6.2.003)

              //PR: 03/03/2014 ABSEXCH-15077 Added ValidVatCode function
              If ((ValidVatCode(VATCode)) and (LineNo>0) And (Not ECService)) then
              Begin
                // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
                // Check for Delivery Charge lines (line-type of 'Freight')
                // CJS 2014-05-13 - ABSEXCH-15337 - removed 'dispatches only' restriction
                if (Cmode in [1, 2]) and (DocLTLink = 3) then
                begin
                  // Delivery Charge line. Do not include it directly on the
                  // report, but accumulate the Delivery Charge details for
                  // this transaction

                  // Calculate the line value with the correct sign, to match
                  // with the equivalent calculation in TIntrastatReport.PrintReportLine.
                  //
                  // Don't convert to currency, as this will be done after the
                  // value has been added to the lines in PrintReportLine.
                  LineValue := (DetLTotal(LId,BOn,BOff,0.0)) * LineCnst(Payment);

                  TotalDeliveryCharge := TotalDeliveryCharge + LineValue;
                end
                else If (Trim(StockCode) <> '') and (Assigned(ThisScrt)) then
                Begin
                  // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
                  // Keep a count of the number of actual Stock lines on the
                  // current transaction
                  // CJS 2014-05-13 - ABSEXCH-15337 - removed 'dispatches only' restriction
                  if (Cmode in  [1, 2]) then
                    TotalStockLines := TotalStockLines + 1;

                  LStatus:=LGetPos(Fnum2,RecAddr);  {* Get Preserve IdPosn *}

                  With ThisScrt^ do
                  Begin
                    If (LStock.StockCode<>StockCode) then
                      LGetMainRec(StockF,LId.StockCode);

                    If (SSDUseLine) then
                    Begin
                      // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                      CommodKey := Copy(LId.SSDCommod, 1, 8) +
                                   Copy(VATRegNo,1,2) +
                                   LId.SSDCountry +
                                   Form_Int(TransNat,2) +
                                   Form_Int(TransMode,1) +
                                   DelTerms;
                    end
                    else
                    Begin
                      // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                      CommodKey := Copy(LStock.CommodCode, 1, 8) +
                                   Copy(VATRegNo,1,2) +
                                   LStock.SSDCountry +
                                   Form_Int(TransNat,2) +
                                   Form_Int(TransMode,1) +
                                   DelTerms;
                    end;

                    {$B-}

                    {* Only count unique keys *}
                    If (Not Summary) or (Not Find_ScratchK(CommodKey)) then
                      Inc(Lnum);

                    {$B+}
                    Add_Scratch(Fnum2,Keypath2,RecAddr,CommodKey,CommodKey);
                  end;
                end;
              end;


              LStatus:=LFind_Rec(B_GetNext,Fnum2,KeyPath2,KeyS2);


            end; {Loop..}

          end;{If In Range }

          // Store any Freight details for this Transaction
          if (TotalDeliveryCharge <> 0) then
            AddFreightDetails(FolioNum, TotalStockLines, TotalDeliveryCharge);

          LStatus:=LFind_Rec(B_GetNext,Fnum1,KeyPath1,KeyCS);

        end; {Inv Loop..}

      end; {Cust Check Loop..}

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCF);

    end; {Cust Loop..}
  end; {With..}

  If (ChkRepAbort) then
    RepAbort:=(Lnum=0);


  Scan_4Items:=LNum;

end; {Proc..}

// PR: 03/03/2014 ABSEXCH-15077 Added extra parameter to indicate whether we're running report for Arrivals or Dispatches
Function TIntrastatDataSearch.IntraInvInclude(InvR  :  InvRec;
                                              Sdate,
                                              Edate :  LongDate;
                                              IsArrivals : Boolean)  :  Boolean;
const
  IncludeTransactions : Array[False..True] of DocSetType = (SalesSplit - [SCR, SRF, SJC] + [PCR, PRF, PJC],
                                                            PurchSplit - [PCR, PRF, PJC] + [SCR, SRF, SJC]);
Begin

  {* ************ If this is altered, must alter version in ReportAU, and EDI section *}
  With InvR do
  Begin
    Result:=((TransDate>=SDate) and (TransDate<=EDate))
      and ((RunNo>=0) or (RunNo=BatchRunNo)) {Debug mode only }
      and (SSDProcess<>'P')
      and (Not (InvDocHed In QuotesSet+RecieptSet+PSOPSet));

    //PR: 03/03/2014 ABSEXCH-15077 Include/exclude appropriate credit notes.
    if Result and (CurrentCountry = IECCode)then
      Result := InvDocHed in IncludeTransactions[IsArrivals];


  {$IFDEF USEONEDAY}
    Result:= ((PostDate>=SDate) and (PostDate<=EDate)) and (RunNo>0)
              and (SSDProcess<>'P')
      and (Not (InvDocHed In QuotesSet+RecieptSet+PSOPSet))
      and ((Not (InvDocHed In CreditSet)) or (CurrentCountry<>IECCode));

    {$ENDIF}

  end; {With..}
end; {Func..}


function TIntrastatDataSearch.CalculateDeliveryCharge(IdR: IDetail): Double;
var
  Entry: Integer;
  Count: Integer;
  Value: Double;
begin
  Result := 0;
  // Try to find an entry matching the Folio number
  Entry := FindFreightDetails(IdR.FolioRef);
  if (Entry <> -1) then
  begin
    Count := fFreightDetails[Entry].ItemCount;
    Value := fFreightDetails[Entry].DeliveryCharge;
    if (Count > 0) and (Value > 0) then
    begin
      // The pro-rata Delivery Charge is the remaining Delivery Charge value
      // divided by the number of remaining items. We don't need to do anything
      // special to assign any stray pence to the final item, because the item
      // count that we are dividing by will be 1 at that point, leaving the
      // entire remaining value.
      Result := Value / Count;
      // Decrement the remaining Delivery Charge and Item Count
      Value := Value - Result;
      Count := Count - 1;
      // Update the actual array entry with the new values
      fFreightDetails[Entry].ItemCount := Count;
      fFreightDetails[Entry].DeliveryCharge := Value;
    end;
  end;
end;

function TIntrastatDataSearch.FindFreightDetails(
  ForFolio: Integer): Integer;
var
  Entry: Integer;
  Found: Boolean;
begin
  // Return -1 if we don't find a matching entry
  Result := -1;
  // Look through the array for a match with the supplied transaction folio
  Entry := Low(fFreightDetails);
  Found := False;
  while (Entry <= High(fFreightDetails)) and not Found do
  begin
    if fFreightDetails[Entry].TransactionFolioRef = ForFolio then
    begin
      Result := Entry;
      Found  := True;
    end
    else
      Entry := Entry + 1;
  end;
end;

procedure TIntrastatDataSearch.ExpandFreightDetailsArray;
var
  NewLength: Integer;
  FirstNewEntry: Integer;
  Entry: Integer;
begin
  // Take a note of the index position for the first new record
  FirstNewEntry := High(fFreightDetails) + 1;

  // Increase the array by 10 elements
  NewLength := High(fFreightDetails) + 10;
  SetLength(fFreightDetails, NewLength);

  // Fill the new elements with null values
  for Entry := FirstNewEntry to High(fFreightDetails) do
  begin
    fFreightDetails[Entry].TransactionFolioRef := -1;
    fFreightDetails[Entry].ItemCount := 0;
    fFreightDetails[Entry].DeliveryCharge := 0;
  end;
end;

procedure TIntrastatDataSearch.AddFreightDetails(FolioRef,
  ItemCount: Integer; DeliveryCharge: Double);
var
  Entry: Integer;
  InsertAt: Integer;
begin
  InsertAt := -1;
  // Find the first unused entry
  for Entry := Low(fFreightDetails) to High(fFreightDetails) do
  begin
    if fFreightDetails[Entry].TransactionFolioRef = -1 then
    begin
      // Found an entry
      InsertAt := Entry;
      break;
    end;
  end;
  // If we didn't find any unused entries...
  if InsertAt = -1 then
  begin
    // ...expand the array, and use the first of the new elements
    InsertAt := High(fFreightDetails) + 1;
    ExpandFreightDetailsArray;
  end;
  // Fill in the details
  fFreightDetails[InsertAt].TransactionFolioRef := FolioRef;
  fFreightDetails[InsertAt].ItemCount           := ItemCount;
  fFreightDetails[InsertAt].DeliveryCharge      := DeliveryCharge;
end;

End.

